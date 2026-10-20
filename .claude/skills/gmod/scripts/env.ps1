# Dot-sourced by preflight.ps1 and launch.ps1. Finds this machine's Garry's Mod setup and throws one error
# naming every missing piece, so neither script starts on a half-present environment.
#
# Steam and GMod are found through Steam's own registry key and library list. What can't be discovered comes
# from <main checkout>\.claude\gmod.local.json, which is gitignored:
#   { "gtermExe": "C:\\...\\gterm.exe", "gmodRoot": "optional override" }

function Get-MainCheckout {
	$common = git -C $PSScriptRoot rev-parse --path-format=absolute --git-common-dir 2>$null
	if ($LASTEXITCODE -ne 0 -or -not $common) { return $null }
	Split-Path -Parent ([System.IO.Path]::GetFullPath($common))
}

# The Steam library holding app 4000, read from libraryfolders.vdf, then its appmanifest's installdir.
function Find-GmodInstall([string]$SteamPath) {
	$libraries = @($SteamPath)
	$vdf = Join-Path $SteamPath 'steamapps\libraryfolders.vdf'
	if (Test-Path -LiteralPath $vdf) {
		foreach ($match in Select-String -LiteralPath $vdf -Pattern '^\s*"path"\s+"(.+)"\s*$') {
			$libraries += $match.Matches[0].Groups[1].Value -replace '\\\\', '\'
		}
	}
	foreach ($library in $libraries | Select-Object -Unique) {
		$manifest = Join-Path $library 'steamapps\appmanifest_4000.acf'
		if (-not (Test-Path -LiteralPath $manifest)) { continue }
		$installDir = (Select-String -LiteralPath $manifest -Pattern '^\s*"installdir"\s+"(.+)"\s*$' | Select-Object -First 1).Matches[0].Groups[1].Value
		return Join-Path $library "steamapps\common\$installDir"
	}
	$null
}

function Resolve-GmodEnv {
	if (-not $IsWindows -or $PSVersionTable.PSVersion.Major -lt 7) {
		throw 'The local GMod setup needs Windows and PowerShell 7 (pwsh). This environment cannot run Garry''s Mod.'
	}

	$problems = [System.Collections.Generic.List[string]]::new()
	$info = [ordered]@{}

	$main = Get-MainCheckout
	$config = @{}
	if (-not $main) {
		$problems.Add("$PSScriptRoot is not inside a git checkout of Photon.")
	} else {
		$info.MainCheckout = $main
		$info.ConfigPath = Join-Path $main '.claude\gmod.local.json'
		if (Test-Path -LiteralPath $info.ConfigPath) {
			try {
				$config = Get-Content -Raw -LiteralPath $info.ConfigPath | ConvertFrom-Json -AsHashtable
			} catch {
				$problems.Add("$($info.ConfigPath) is not valid JSON: $($_.Exception.Message)")
			}
		}
	}
	$configName = if ($info.ConfigPath) { $info.ConfigPath } else { '.claude\gmod.local.json' }

	$steam = Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue
	if (-not $steam -or -not $steam.SteamExe -or -not (Test-Path -LiteralPath $steam.SteamExe)) {
		$problems.Add('Steam is not installed (no SteamExe under HKCU:\Software\Valve\Steam). GMod is launched through Steam, so Steam must be installed and signed in.')
	} else {
		$info.SteamExe = $steam.SteamExe
	}

	$gmodRoot = $config.gmodRoot
	if (-not $gmodRoot -and $steam -and $steam.SteamPath) { $gmodRoot = Find-GmodInstall $steam.SteamPath }
	if (-not $gmodRoot) {
		$problems.Add("Garry's Mod (Steam app 4000) is not installed in any Steam library. If it is installed somewhere Steam doesn't list, set gmodRoot in $configName.")
	} elseif (-not (Test-Path -LiteralPath (Join-Path $gmodRoot 'garrysmod'))) {
		$problems.Add("$gmodRoot has no garrysmod folder, so it is not a Garry's Mod install.")
	} else {
		$info.GmodRoot = $gmodRoot
		$info.GarrysMod = Join-Path $gmodRoot 'garrysmod'
	}

	$gterm = $config.gtermExe
	if (-not $gterm) {
		$problems.Add("GTerm is not configured. Set gtermExe in $configName to the path of gterm.exe; GTerm is the bridge an agent drives the game through.")
	} elseif (-not (Test-Path -LiteralPath $gterm)) {
		$problems.Add("gtermExe points at $gterm, which does not exist.")
	} else {
		$gtermConfigPath = Join-Path (Split-Path $gterm) 'Config.json'
		$gtermConfig = $null
		if (Test-Path -LiteralPath $gtermConfigPath) {
			try { $gtermConfig = Get-Content -Raw -LiteralPath $gtermConfigPath | ConvertFrom-Json } catch { }
		}
		if (-not $gtermConfig) {
			$problems.Add("GTerm has no readable Config.json beside $gterm.")
		} elseif (-not $gtermConfig.MCP -or -not $gtermConfig.MCPSecret -or -not $gtermConfig.MCPPort) {
			$problems.Add("$gtermConfigPath must have MCP true, an MCPSecret and an MCPPort.")
		} else {
			$info.GTermExe = $gterm
			$info.GTermPort = [int]$gtermConfig.MCPPort
			$info.GTermSecret = $gtermConfig.MCPSecret
		}
	}

	if ($problems.Count) {
		throw ("The local GMod environment is not usable:`n" + (($problems | ForEach-Object { "  - $_" }) -join "`n"))
	}
	[pscustomobject]$info
}

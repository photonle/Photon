<#
.SYNOPSIS
Boots a Photon checkout in the local Windows Garry's Mod, on sandbox.

.DESCRIPTION
The gmod skill's launcher; see .claude/skills/gmod/SKILL.md and REFERENCE.md. It first runs the same
environment check as preflight.ps1 and stops if anything is missing. Each run then:
  1. points the garrysmod\addons\photon junction at -Worktree;
  2. takes down the cityrp2_* junctions CityRP's launcher leaves behind, and moves back anything it set
     aside, so a sandbox boot loads Photon and the player's own addons only;
  3. installs the ready probe and the GTerm dev addon;
  4. starts GTerm if it is not listening, then GMod through Steam, and sends the map once the workshop
     has mounted.

-Restore points addons\photon back at the main checkout and does nothing else: run it once the game has
been handed back, since CityRP's launcher loads whatever that junction points at.

.EXAMPLE
pwsh -File .claude\skills\gmod\scripts\launch.ps1 -Worktree E:\Photon\Photon\.claude\worktrees\dreamy-dubinsky-3cc923
#>
[CmdletBinding()]
param(
	# The checkout to test. Defaults to the main checkout of the repository this script is in.
	[string]$Worktree,
	[string]$Map = 'gm_construct',
	[string]$Gamemode = 'sandbox',
	[int]$MaxPlayers = 2,
	# Server tick rate, passed as -tickrate; it cannot change once the game is running. 0 keeps the game's default.
	[int]$TickRate = 0,
	# Sets the addons up without starting anything.
	[switch]$NoLaunch,
	# Points addons\photon back at the main checkout, and exits.
	[switch]$Restore
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'env.ps1')
$GmodEnv = Resolve-GmodEnv
if ($Restore -or -not $Worktree) { $Worktree = $GmodEnv.MainCheckout }

$GarrysMod = $GmodEnv.GarrysMod
$GTermExe = $GmodEnv.GTermExe
$GTermPort = $GmodEnv.GTermPort

# Copies $Source over $Destination unless the two already match.
function Sync-File([string]$Source, [string]$Destination) {
	if ((Test-Path -LiteralPath $Destination) -and
		((Get-FileHash -LiteralPath $Source).Hash -eq (Get-FileHash -LiteralPath $Destination).Hash)) {
		return
	}
	Copy-Item -LiteralPath $Source -Destination $Destination -Force
	Write-Host "  installed $(Split-Path $Destination -Leaf)"
}

function Remove-Junction([string]$Path) {
	$item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
	# Deletes the junction only, never the folder it points at.
	if ($item -and $item.LinkType -eq 'Junction') { [System.IO.Directory]::Delete($Path) }
}

function Set-PhotonJunction {
	$target = (Resolve-Path -LiteralPath $Worktree).Path
	if (-not (Test-Path -LiteralPath (Join-Path $target 'lua\autorun\photon'))) { throw "$Worktree is not a Photon checkout: it has no lua\autorun\photon" }

	$link = Join-Path $GarrysMod 'addons\photon'
	if (Test-Path -LiteralPath $link) {
		$item = Get-Item -LiteralPath $link -Force
		if ($item.LinkType -ne 'Junction') { throw "$link is a real folder, not a junction; move it aside first" }
		if ($item.Target -eq $target) {
			Write-Host "addons\photon already points at $target"
			return
		}
		Remove-Junction $link
	}
	New-Item -ItemType Junction -Path $link -Target $target | Out-Null
	Write-Host "addons\photon -> $target"
}

# CityRP's launcher junctions its repo's addons in as addons\cityrp2_<name> (and lua\, scripts\ through
# addons\cityrp2_root), moving clashing local addons to addons_cityrp2_aside\. It undoes this itself on a
# non-CityRP launch; doing the same here keeps a sandbox boot from loading half of CityRP. Its next launch
# puts them back.
function Clear-CityRPAddons {
	$addons = Join-Path $GarrysMod 'addons'
	foreach ($old in Get-ChildItem -LiteralPath $addons -Directory -Force -Filter 'cityrp2_*') {
		if ($old.Name -eq 'cityrp2_root') {
			foreach ($inner in Get-ChildItem -LiteralPath $old.FullName -Force) { Remove-Junction $inner.FullName }
			Remove-Item -LiteralPath $old.FullName -Force
		} else {
			Remove-Junction $old.FullName
		}
	}
	$aside = Join-Path $GarrysMod 'addons_cityrp2_aside'
	if (Test-Path -LiteralPath $aside) {
		foreach ($moved in Get-ChildItem -LiteralPath $aside -Directory -Force) {
			Move-Item -LiteralPath $moved.FullName -Destination (Join-Path $addons $moved.Name)
			Write-Host "  restored addons\$($moved.Name)"
		}
		Remove-Item -LiteralPath $aside -Force
	}
}

function Install-DevAddons {
	foreach ($name in 'gterm_ready', 'gterm_dev') {
		$autorun = Join-Path $GarrysMod "addons\$name\lua\autorun"
		New-Item -ItemType Directory -Force $autorun | Out-Null
		Sync-File (Join-Path $PSScriptRoot "..\addons\$name.lua") (Join-Path $autorun "$name.lua")
	}
	Remove-Item (Join-Path $GarrysMod 'data\gterm_ready\*.txt') -ErrorAction SilentlyContinue
}

function Start-GTerm {
	if (Get-NetTCPConnection -LocalPort $GTermPort -State Listen -ErrorAction SilentlyContinue) { return }
	Write-Host 'Starting GTerm'
	Start-Process -FilePath $GTermExe -WorkingDirectory (Split-Path $GTermExe)
}

if (Get-Process gmod -ErrorAction SilentlyContinue) {
	throw 'Garry''s Mod is running; quit it first, since addons are only mounted at startup (its CEF helpers can take a minute to exit)'
}

Set-PhotonJunction
if ($Restore) { return }

Clear-CityRPAddons
Install-DevAddons
if ($NoLaunch) { return }

Start-GTerm
# Through Steam, so workshop subscriptions mount; starting gmod.exe directly mounts none of them.
# -condebug writes garrysmod\console.log, the only full boot log; GTerm's buffer only holds recent lines.
$gmodArgs = @('-console', '-novid', '-condebug')
if ($TickRate -gt 0) { $gmodArgs += @('-tickrate', "$TickRate") }
$consoleLog = Join-Path $GarrysMod 'console.log'
Remove-Item -LiteralPath $consoleLog -ErrorAction SilentlyContinue
Write-Host "Starting Garry's Mod through Steam to the main menu"
# -applaunch hands the arguments to the running Steam client; a steam://run URL with arguments makes Steam ask first.
Start-Process -FilePath $GmodEnv.SteamExe -ArgumentList (@('-applaunch', '4000') + $gmodArgs)

# GMod grabs focus when its window first appears. Give it focus once, so it finishes initialising as the
# foreground app, then minimise it so it stops stealing focus from whatever you were doing.
Add-Type -Name Win32 -Namespace PhotonGmodLaunch -MemberDefinition @'
[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
'@
$windowDeadline = (Get-Date).AddMinutes(2)
$gmodWindow = [IntPtr]::Zero
while ($gmodWindow -eq [IntPtr]::Zero -and (Get-Date) -lt $windowDeadline) {
	Start-Sleep -Seconds 1
	$gmodWindow = Get-Process gmod -ErrorAction SilentlyContinue | Where-Object MainWindowHandle -ne 0 | Select-Object -First 1 -ExpandProperty MainWindowHandle
	if (-not $gmodWindow) { $gmodWindow = [IntPtr]::Zero }
}
if ($gmodWindow -ne [IntPtr]::Zero) {
	# Windows only lets a background process take the foreground just after a keypress; a bare Alt tap counts.
	[PhotonGmodLaunch.Win32]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero)
	[PhotonGmodLaunch.Win32]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
	[PhotonGmodLaunch.Win32]::ShowWindow($gmodWindow, 9) | Out-Null # SW_RESTORE
	[PhotonGmodLaunch.Win32]::SetForegroundWindow($gmodWindow) | Out-Null
	Start-Sleep -Seconds 2
	[PhotonGmodLaunch.Win32]::ShowWindow($gmodWindow, 6) | Out-Null # SW_MINIMIZE
}

# A +map on the command line starts the server before the workshop has mounted, and the load then
# blocks the main thread the mount needs: the game hangs at "fetching subscriptions". So wait at the
# menu for the mount to finish, then start the map through GTerm's console.
Write-Host 'Waiting for the workshop to mount'
$deadline = (Get-Date).AddMinutes(20)
while (-not ((Test-Path -LiteralPath $consoleLog) -and (Select-String -LiteralPath $consoleLog -Pattern 'Mounted \d+ of \d+ workshop addons' -Quiet))) {
	if ((Get-Date) -gt $deadline) { throw 'The workshop did not mount within 20 minutes' }
	Start-Sleep -Seconds 3
}
# The first mount is often followed by "Addons have changes - remounting", and a console command sent
# while that remount runs is dropped. Wait until the log has gone 10 seconds with no new remount.
$remounts = -1
$quietSince = Get-Date
while ((Get-Date) - $quietSince -lt [TimeSpan]::FromSeconds(10)) {
	if ((Get-Date) -gt $deadline) { throw 'The workshop kept remounting for 20 minutes' }
	$now = @(Select-String -LiteralPath $consoleLog -Pattern 'Addons have changes - remounting').Count
	if ($now -ne $remounts) { $remounts = $now; $quietSince = Get-Date }
	Start-Sleep -Seconds 2
}

$command = "maxplayers $MaxPlayers; sv_lan 1; gamemode $Gamemode; map $Map"
$body = @{
	jsonrpc = '2.0'; id = 1; method = 'tools/call'
	params = @{ name = 'run_gmod_command'; arguments = @{ command = $command; force = $true } }
} | ConvertTo-Json -Depth 5
# The listen server prints "Network: IP ..." as the map starts; resend if it hasn't, since a late remount can still eat the command.
$started = $false
foreach ($attempt in 1..3) {
	$before = @(Select-String -LiteralPath $consoleLog -Pattern '^Network: IP ').Count
	Invoke-RestMethod -Method Post -Uri "http://localhost:$GTermPort/?secret=$($GmodEnv.GTermSecret)" -ContentType 'application/json' -Body $body | Out-Null
	$wait = (Get-Date).AddSeconds(45)
	while ((Get-Date) -lt $wait) {
		Start-Sleep -Seconds 3
		if (@(Select-String -LiteralPath $consoleLog -Pattern '^Network: IP ').Count -gt $before) { $started = $true; break }
	}
	if ($started) { break }
	Write-Host "  the map command was not picked up (attempt $attempt); resending"
}
if (-not $started) { throw "GMod did not start the map after 3 attempts; send it through GTerm by hand: $command" }
Write-Host "Started: $command. The ready probe writes data\gterm_ready\<realm>.txt once each realm has loaded."

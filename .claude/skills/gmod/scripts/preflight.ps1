<#
.SYNOPSIS
Checks this machine can boot Photon in the local Garry's Mod, and prints where everything is.

.DESCRIPTION
Exits 1 with one "gmod-preflight FATAL:" line per missing piece. Run it through preflight.sh, which
fails first where PowerShell itself is missing.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'env.ps1')

try {
	$gmodEnv = Resolve-GmodEnv
} catch {
	foreach ($line in $_.Exception.Message -split "`n") { Write-Output "gmod-preflight FATAL: $line" }
	exit 1
}

$photonLink = Get-Item -LiteralPath (Join-Path $gmodEnv.GarrysMod 'addons\photon') -Force -ErrorAction SilentlyContinue

Write-Output 'gmod-preflight ok'
Write-Output "main_checkout=$($gmodEnv.MainCheckout)"
Write-Output "gmod_root=$($gmodEnv.GmodRoot)"
Write-Output "console_log=$(Join-Path $gmodEnv.GarrysMod 'console.log')"
Write-Output "ready_dir=$(Join-Path $gmodEnv.GarrysMod 'data\gterm_ready')"
Write-Output "photon_addon=$(if ($photonLink) { "$($photonLink.LinkType) $($photonLink.Target)" } else { 'missing' })"
Write-Output "gterm_port=$($gmodEnv.GTermPort)"
Write-Output "gterm_listening=$([bool](Get-NetTCPConnection -LocalPort $gmodEnv.GTermPort -State Listen -ErrorAction SilentlyContinue))"
Write-Output "gmod_running=$([bool](Get-Process gmod -ErrorAction SilentlyContinue))"

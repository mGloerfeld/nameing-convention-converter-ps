<#
.SYNOPSIS
	Erstellt einen Windows Kontextmenüeintrag mit zwei Untermenüs für Dateien.

.DESCRIPTION
	Legt unter HKCR:*\shell einen Hauptmenüeintrag an und fügt zwei Sub-Menüeinträge hinzu:
	  1. "In CamelCase umwandeln"
	  2. "In Kebab-Case umwandeln"
	Jeder Eintrag ruft das Modul / Skript mit dem ausgewählten Dateinamen als Parameter auf.

.PARAMETER Install
	Erstellt / aktualisiert die Registrierungseinträge.

.PARAMETER Uninstall
	Entfernt die Registrierungseinträge.

.NOTES
	Muss als Administrator ausgeführt werden.
	Nutzt powershell.exe. Bei Pwsh Core anpassen.
#>
[CmdletBinding(DefaultParameterSetName = 'Install')]
param(
	[Parameter(ParameterSetName = 'Install')][switch] $Install,
	[Parameter(ParameterSetName = 'Uninstall')][switch] $Uninstall,
	[Parameter()][string] $RootName = 'NameingConverter',
	[Parameter()][string] $ModulePath = "$PSScriptRoot/../src/GlobeCruising.Common.NameingConventionConverter.psd1"
)

function Test-Admin {
	$current = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = New-Object Security.Principal.WindowsPrincipal($current)
	return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
	Write-Warning 'Dieses Skript sollte als Administrator ausgeführt werden.'
}

$rootKey = "HKCR:\*\shell\$RootName"
$subCamel = "$rootKey\shell\CamelCase"
$subKebab = "$rootKey\shell\KebabCase"

if ($Uninstall) {
	Write-Host "Entferne Kontextmenüeinträge..." -ForegroundColor Yellow
	foreach ($k in @($subCamel, $subKebab, $rootKey)) {
		if (Test-Path $k) {
			Remove-Item -Path $k -Recurse -Force -ErrorAction SilentlyContinue
		}
	}
	Write-Host "Fertig." -ForegroundColor Green
	return
}

if ($Install) {
	Write-Host "Installiere Kontextmenüeinträge..." -ForegroundColor Cyan
	# Hauptmenü
	New-Item -Path $rootKey -Force | Out-Null
	Set-ItemProperty -Path $rootKey -Name '(default)' -Value 'Naming Converter'
	# Optional Icon festlegen (hier powershell.exe als Beispiel)
	Set-ItemProperty -Path $rootKey -Name 'Icon' -Value "$PSHOME\powershell.exe"
	# Verhindert direkten Klick ohne Untermenu -> keine command unter root

	# Sub: CamelCase
	New-Item -Path $subCamel -Force | Out-Null
	Set-ItemProperty -Path $subCamel -Name '(default)' -Value 'In CamelCase umwandeln'
	$camelCmd = 'powershell.exe -NoLogo -ExecutionPolicy Bypass -Command ''Import-Module "' + $ModulePath + '" -Force; ConvertTo-CamelCase ((Get-Item "%1").Name) | Out-Host'''
	New-Item -Path "$subCamel\command" -Force | Out-Null
	Set-ItemProperty -Path "$subCamel\command" -Name '(default)' -Value $camelCmd

	# Sub: KebabCase
	New-Item -Path $subKebab -Force | Out-Null
	Set-ItemProperty -Path $subKebab -Name '(default)' -Value 'In Kebab-Case umwandeln'
	$kebabCmd = 'powershell.exe -NoLogo -ExecutionPolicy Bypass -Command ''Import-Module "' + $ModulePath + '" -Force; ConvertTo-KebabCase ((Get-Item "%1").Name) | Out-Host'''
	New-Item -Path "$subKebab\command" -Force | Out-Null
	Set-ItemProperty -Path "$subKebab\command" -Name '(default)' -Value $kebabCmd

	Write-Host "Kontextmenü erfolgreich installiert." -ForegroundColor Green
	Write-Host "Zum Entfernen: .\tools\register.ps1 -Uninstall" -ForegroundColor DarkGray
	return
}

Write-Host 'Bitte mit -Install oder -Uninstall aufrufen.' -ForegroundColor Yellow
<#
.SYNOPSIS
	Installiert oder entfernt Windows Explorer Kontextmenüeinträge zur direkten Umwandlung von Dateinamen (CamelCase / Kebab-Case).

.DESCRIPTION
	Erstellt unter HKCR:*\shell einen Hauptmenüeintrag (CaseStyle Converter) mit zwei Untermenüs:
	  1. "In CamelCase umwandeln"
	  2. "In Kebab-Case umwandeln"
	Jeder Eintrag lädt das Modul und wandelt den reinen Dateinamen (ohne Pfad) um. Ausgabe erfolgt in einem transienten PowerShell-Fenster.
	Optional kann Pwsh (Core) statt Windows PowerShell genutzt werden (Parameter -UsePwsh).

.PARAMETER Install
	Führt die Installation durch (Standardaktion wenn kein Parameter angegeben wird).

.PARAMETER Uninstall
	Entfernt alle zuvor erzeugten Registrierungseinträge.

.PARAMETER UsePwsh
	Verwendet "pwsh" statt "powershell.exe" für die Kontextmenübefehle.

.PARAMETER Silent
	Unterdrückt nicht-kritische Ausgaben (nur Warnungen/Fehler erscheinen).

.PARAMETER DryRun
	Zeigt nur an, was gemacht würde, ohne Änderungen vorzunehmen.

.NOTES
	Erfordert typischerweise Administratorrechte für HKCR (abhängig von System und UAC). Bei fehlenden Rechten besser HKCU:Software\Classes verwenden.
	Dieses Skript nutzt feste Befehlsstrings mit korrektem Quoting; Sonderzeichen oder Leerzeichen in Modulpfaden werden unterstützt.

.EXAMPLE
	./install.ps1 -Install
	Installiert die Kontextmenüs.

.EXAMPLE
	./install.ps1 -Uninstall
	Entfernt die Kontextmenüs.

.EXAMPLE
	./install.ps1 -Install -UsePwsh -Silent
	Nutzt pwsh und minimiert Ausgaben.

.LINK
	https://github.com/mGloerfeld/nameing-convention-converter
#>
 
  
$RootName = 'CaseStyleConverter'
$ModuleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) # geht von ...\src\lib\register aus
$ModulePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'CaseStyleConverter.psd1'

param(
	[switch]$Install,
	[switch]$Uninstall,
	[switch]$UsePwsh,
	[switch]$Silent,
	[switch]$DryRun
)

if (-not ($Install -or $Uninstall)) { $Install = $true }
 
function Test-Admin {
	$current = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = New-Object Security.Principal.WindowsPrincipal($current)
	return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
	Write-Warning 'Hinweis: Keine Administratorrechte erkannt. HKCR Schreibzugriff könnte fehlschlagen.'
}

$rootKey = "HKCR:\*\shell\$RootName"
$subCamel = "$rootKey\shell\CamelCase"
$subKebab = "$rootKey\shell\KebabCase"
  
function Invoke-Log {
	param([string]$Message, [ConsoleColor]$Color = 'Gray')
	if ($Silent) { return }
	Write-Host $Message -ForegroundColor $Color
}

function Get-CommandExecutable {
	if ($UsePwsh) { 'pwsh' } else { 'powershell.exe' }
}

function Get-QuotedModuleImport {
	param([string]$Path)
	$escaped = $Path.Replace('`', '``').Replace("'", "''")
	"Import-Module '$escaped' -Force"
}

function New-ConversionCommand {
	param(
		[Parameter(Mandatory)] [string]$FunctionName,
		[Parameter(Mandatory)] [string]$ModulePath
	)
	$exe = Get-CommandExecutable
	$import = Get-QuotedModuleImport -Path $ModulePath
	# Wir nutzen Single Quotes außen für Registry Default-Wert; innen doppelte Quotes für %1.
	# Der Dateiname wird als (Get-Item "%1").Name bezogen.
	$inner = "$import; $FunctionName ((Get-Item \" % 1\").Name) | Out-Host"
	return "$exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command '$inner'"
}

function Install-CaseStyleContextMenu {
	Invoke-Log "Installiere Kontextmenüeinträge..." Cyan
	if ($DryRun) { Invoke-Log '[DryRun] Installation nur simuliert.' Yellow }
	if ($DryRun) { return }

	# Hauptmenü
	New-Item -Path $rootKey -Force | Out-Null
	Set-ItemProperty -Path $rootKey -Name '(default)' -Value 'CaseStyle Converter'
	Set-ItemProperty -Path $rootKey -Name 'Icon' -Value (Join-Path $PSHOME 'powershell.exe')

	# Untermenüs
	New-Item -Path $subCamel -Force | Out-Null
	Set-ItemProperty -Path $subCamel -Name '(default)' -Value 'In CamelCase umwandeln'
	$camelCmd = New-ConversionCommand -FunctionName 'ConvertTo-CamelCase' -ModulePath $ModulePath
	New-Item -Path "$subCamel\command" -Force | Out-Null
	Set-ItemProperty -Path "$subCamel\command" -Name '(default)' -Value $camelCmd

	New-Item -Path $subKebab -Force | Out-Null
	Set-ItemProperty -Path $subKebab -Name '(default)' -Value 'In Kebab-Case umwandeln'
	$kebabCmd = New-ConversionCommand -FunctionName 'ConvertTo-KebabCase' -ModulePath $ModulePath
	New-Item -Path "$subKebab\command" -Force | Out-Null
	Set-ItemProperty -Path "$subKebab\command" -Name '(default)' -Value $kebabCmd

	Invoke-Log 'Fertig.' Green
}

function Uninstall-CaseStyleContextMenu {
	Invoke-Log 'Entferne Kontextmenüeinträge...' Cyan
	if ($DryRun) { Invoke-Log '[DryRun] Entfernung nur simuliert.' Yellow; return }
	Remove-Item -Path $rootKey -Recurse -Force -ErrorAction SilentlyContinue
	Invoke-Log 'Fertig.' Green
}

if ($Install) { Install-CaseStyleContextMenu }
if ($Uninstall) { Uninstall-CaseStyleContextMenu }

function Test-CaseStyleContextMenu {
	[PSCustomObject]@{
		RootKeyExists = Test-Path $rootKey
		CamelExists   = Test-Path "$subCamel\command"
		KebabExists   = Test-Path "$subKebab\command"
		ModulePath    = $ModulePath
		Executable    = Get-CommandExecutable()
	}
}

if (-not $Silent) {
	Invoke-Log 'Status:' DarkGray
	Test-CaseStyleContextMenu | Format-List
}
 
 
 
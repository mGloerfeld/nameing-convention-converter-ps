 
<#
.SYNOPSIS
    Konvertiert einen String oder alle Datei- und Ordnernamen in einem Pfad in camelCase.

.DESCRIPTION
    Diese Funktion kann entweder einen einzelnen String oder einen Verzeichnispfad entgegennehmen.
    Bei einem String wird dieser direkt in camelCase konvertiert.
    Bei einem Pfad werden alle Dateien und Ordner mittels des files and folders Moduls ermittelt
    und deren Namen in camelCase konvertiert.

.PARAMETER InputValue
    Der zu konvertierende String oder Verzeichnispfad. 
    Wenn es sich um einen gültigen Verzeichnispfad handelt, werden alle Dateien und Ordner verarbeitet.
    Andernfalls wird der Wert als String behandelt und direkt konvertiert.

.PARAMETER Recurse
    Wenn gesetzt und InputValue ist ein Pfad, werden Unterordner rekursiv durchsucht.

.PARAMETER IncludeFolders
    Wenn gesetzt und InputValue ist ein Pfad, werden auch Ordner berücksichtigt. Standardmäßig werden nur Dateien verarbeitet.

.PARAMETER PreserveAcronyms
    Wenn gesetzt, bleiben Wörter in Großbuchstaben (z. B. "API") unverändert erhalten.

.PARAMETER Invariant
    Wenn gesetzt, wird die InvariantCulture für die Groß-/Kleinschreibung verwendet.

.EXAMPLE
    ConvertTo-CamelCase "my_test_string" -PreserveAcronyms
    # Konvertiert den String direkt: "myTestString"

.EXAMPLE
    ConvertTo-CamelCase "C:\Temp" -PreserveAcronyms
    # Konvertiert alle Dateinamen in C:\Temp zu camelCase (keine Ordner)

.EXAMPLE
    ConvertTo-CamelCase "C:\Temp" -IncludeFolders -PreserveAcronyms
    # Konvertiert alle Datei- und Ordnernamen in C:\Temp zu camelCase

.EXAMPLE
    ConvertTo-CamelCase "C:\Temp" -Recurse -IncludeFolders -Invariant
    # Konvertiert rekursiv alle Namen mit InvariantCulture

.NOTES
    Die Funktion ist pipeline-fähig und Teil eines Moduls.
#>

# Hilfsfunktionen einbinden
. "$PSScriptRoot\camel-case.ps1"

# Files and Folders Modul importieren
Import-Module "$PSScriptRoot\..\FilesAndFolder\files and folders.psm1" -Force

function ConvertTo-CamelCase {
    [CmdletBinding()]
    [OutputType([System.String], [PSCustomObject[]])]
    param (
        [Parameter(
            Mandatory = $true, 
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The string to convert or directory path to process"
        )]
        [AllowEmptyString()]
        [string]$InputValue,

        [Parameter(HelpMessage = "Include subdirectories recursively (only for paths)")]
        [switch]$Recurse,

        [Parameter(HelpMessage = "Include folders when processing paths (default: files only)")]
        [switch]$IncludeFolders,

        [Parameter(HelpMessage = "Preserve uppercase acronyms like API, ID, etc.")]
        [switch]$PreserveAcronyms,

        [Parameter(HelpMessage = "Use InvariantCulture for case operations")]
        [switch]$Invariant
    )

    begin {
        Write-Verbose "[ConvertTo-CamelCase] Starting camelCase conversion process for input: $InputValue"
    }

    process {
        try {
            # Prüfen ob Input leer ist
            if ([string]::IsNullOrWhiteSpace($InputValue)) {
                Write-Verbose "[ConvertTo-CamelCase] Input is null, empty, or whitespace. Returning empty string."
                return ""
            }

            # Prüfen ob es sich um einen gültigen Verzeichnispfad handelt
            $isPath = Test-Path -LiteralPath $InputValue -PathType Container
            
            if ($isPath) {
                Write-Verbose "[ConvertTo-CamelCase] Input is a valid directory path. Processing files and folders."
                
                # Dateien und Ordner über das files and folders Modul abrufen
                $items = if ($Recurse) {
                    filesAndFolders -Path $InputValue -Recurse
                }
                else {
                    filesAndFolders -Path $InputValue
                }
                
                Write-Verbose "[ConvertTo-CamelCase] Found $($items.Count) items to process"
                
                # Array für Ergebnisse sammeln
                $results = @()
                
                # Jedes Element verarbeiten
                foreach ($item in $items) {
                    # Überspringe Ordner wenn IncludeFolders nicht gesetzt ist
                    if ($null -eq $item.Extension -and -not $IncludeFolders) {
                        Write-Verbose "[ConvertTo-CamelCase] Skipping folder '$($item.Dateiname)' (IncludeFolders not set)"
                        continue
                    }
                    
                    if ([string]::IsNullOrWhiteSpace($item.Dateiname)) {
                        Write-Verbose "[ConvertTo-CamelCase] Skipping item with empty filename"
                        continue
                    }

                    Write-Verbose "[ConvertTo-CamelCase] Converting: '$($item.Dateiname)'"
                    
                    $convertedName = $item.Dateiname | ToCamelCase -PreserveAcronyms:$PreserveAcronyms.IsPresent -Invariant:$Invariant.IsPresent
                    
                    Write-Verbose "[ConvertTo-CamelCase] Result: '$convertedName'"
                    
                    # Erweiterte Ausgabe mit Original- und konvertiertem Namen
                    $results += [PSCustomObject]@{
                        Typ               = if ($null -eq $item.Extension) { 'Ordner' } else { 'Datei' }
                        OriginalName      = $item.Dateiname
                        ConvertedName     = $convertedName
                        Extension         = $item.Extension
                        Pfad              = $item.Pfad
                        FullOriginalPath  = if ($item.Extension) { 
                            Join-Path $item.Pfad "$($item.Dateiname)$($item.Extension)" 
                        }
                        else { 
                            Join-Path $item.Pfad $item.Dateiname 
                        }
                        FullConvertedPath = if ($item.Extension) { 
                            Join-Path $item.Pfad "$convertedName$($item.Extension)" 
                        }
                        else { 
                            Join-Path $item.Pfad $convertedName 
                        }
                    }
                }
                
                # Ergebnisse als Tabelle ausgeben
                if ($results.Count -gt 0) {
                    Write-Host "`nErgebnisse der CamelCase-Konvertierung:" -ForegroundColor Green
                    $results | Format-Table -Property Typ, OriginalName, ConvertedName, Extension, Pfad -AutoSize
                     
                }
                else {
                    Write-Host "Keine Elemente zum Verarbeiten gefunden." -ForegroundColor Yellow
                }
                
                # Rückgabe für Pipeline
                return $results
            }
            else {
                Write-Verbose "[ConvertTo-CamelCase] Input is a string. Converting directly."
                
                Write-Verbose "[ConvertTo-CamelCase] Converting: '$InputValue'"
                
                $result = $InputValue | ToCamelCase -PreserveAcronyms:$PreserveAcronyms.IsPresent -Invariant:$Invariant.IsPresent
                
                Write-Verbose "[ConvertTo-CamelCase] Result: '$result'"
                return $result
            }
        }
        catch {
            Write-Error "[ConvertTo-CamelCase] Failed to process input '$InputValue': $($_.Exception.Message)"
            throw
        }
    }

    end {
        Write-Verbose "[ConvertTo-CamelCase] Conversion process completed"
    }
}

# Funktion für Modulexport freigeben
Export-ModuleMember -Function ConvertTo-CamelCase
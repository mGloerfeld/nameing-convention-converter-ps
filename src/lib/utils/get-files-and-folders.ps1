<#
.SYNOPSIS
    Listet alle Dateien und Ordner in einem angegebenen Pfad auf.
.DESCRIPTION
    Gibt eine rekursive Liste aller Dateien und Unterordner für einen übergebenen Verzeichnispfad zurück.
.PARAMETER Path
    Der zu durchsuchende Verzeichnispfad.
.EXAMPLE
    Get-FilesAndFolders -Path 'C:\Temp'
.NOTES
    Pipeline-fähig. Gibt Objekte mit Typ, Name und vollständigem Pfad zurück.
#>
function Get-FilesAndFolders {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Pfad zum Verzeichnis')]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    process {
        try {
            if (-not (Test-Path $Path -PathType Container)) {
                Write-Error "Pfad existiert nicht oder ist kein Verzeichnis: $Path"
                return
            }
            Get-ChildItem -Path $Path -Recurse | ForEach-Object {
                [PSCustomObject]@{
                    Type     = if ($_.PSIsContainer) { 'Ordner' } else { 'Datei' }
                    Name     = $_.Name
                    FullName = $_.FullName
                }
            }
        }
        catch {
            Write-Error "Fehler beim Auflisten: $($_.Exception.Message)"
        }
    }
}

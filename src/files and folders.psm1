 

<#
.SYNOPSIS
    Listet Dateien und Ordner in einem Pfad.

.DESCRIPTION
    Gibt eine Liste aller Dateien und Ordner im angegebenen Pfad zurück. Optional können auch Unterordner rekursiv berücksichtigt werden.
    Implementierung nutzt explizite for-Schleifen statt Pipeline-Verarbeitung von Get-ChildItem.

.PARAMETER Path
    Der zu durchsuchende Pfad (Verzeichnis).

.PARAMETER Recurse
    Wenn gesetzt, werden Unterordner rekursiv durchsucht.

.EXAMPLE
    filesAndFolders -Path 'C:\Temp'

.EXAMPLE
    filesAndFolders -Path 'C:\Temp' -Recurse

.OUTPUTS
    PSCustomObject mit Eigenschaften: Type, Name, FullName

.NOTES
    Unterdrückt versteckte und System-Dateien nicht automatisch; kann bei Bedarf erweitert werden.
#>
function filesAndFolders {
    [CmdletBinding()] [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter()] [switch] $Recurse
    )

    begin {
        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            Throw "Pfad existiert nicht oder ist kein Verzeichnis: $Path"
        }
    }

    process {
        try {
            # Nicht rekursive Ebene zuerst
            $items = Get-ChildItem -LiteralPath $Path -Force
            for ($i = 0; $i -lt $items.Count; $i++) {
                $item = $items[$i]
                [PSCustomObject]@{
                    Type     = if ($item.PSIsContainer) { 'Ordner' } else { 'Datei' }
                    Name     = $item.Name
                    FullName = $item.FullName
                }
            }

            if ($Recurse) {
                # Rekursive Durchläufe der Unterordner mit Stack (iterativ statt echter Rekursion)
                $stack = New-Object System.Collections.Stack
                # Starte mit allen Unterordnern der ersten Ebene
                for ($j = 0; $j -lt $items.Count; $j++) {
                    if ($items[$j].PSIsContainer) { $stack.Push($items[$j].FullName) }
                }

                while ($stack.Count -gt 0) {
                    $current = $stack.Pop()
                    $subItems = Get-ChildItem -LiteralPath $current -Force
                    for ($k = 0; $k -lt $subItems.Count; $k++) {
                        $sub = $subItems[$k]
                        [PSCustomObject]@{
                            Type     = if ($sub.PSIsContainer) { 'Ordner' } else { 'Datei' }
                            Name     = $sub.Name
                            FullName = $sub.FullName
                        }
                        if ($sub.PSIsContainer) { $stack.Push($sub.FullName) }
                    }
                }
            }
        }
        catch {
            Write-Error "Fehler beim Auflisten: $($_.Exception.Message)"
        }
    }
}

 
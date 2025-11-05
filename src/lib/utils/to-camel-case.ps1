<#
.SYNOPSIS
    Konvertiert einen Eingabestring in camelCase.

.DESCRIPTION
    Diese Funktion nimmt einen String entgegen und wandelt ihn in camelCase um.
    Dabei werden einzelne Wörter erkannt und entsprechend formatiert:
    - Das erste Wort wird vollständig kleingeschrieben.
    - Nachfolgende Wörter werden mit großem Anfangsbuchstaben geschrieben.
    - Optional können Sonderzeichen entfernt werden.
    - Optional können Akronyme (z. B. "API", "ID") erhalten bleiben.
    - Optional kann die Kulturwahl auf Invariant gesetzt werden.

.PARAMETER Value
    Der Eingabestring, der konvertiert werden soll.

.PARAMETER PreserveAcronyms
    Wenn gesetzt, bleiben Wörter in Großbuchstaben (z. B. "API") unverändert erhalten.

.PARAMETER Invariant
    Wenn gesetzt, wird die InvariantCulture für die Groß-/Kleinschreibung verwendet.

 
.EXAMPLE
    ToCamelCase "mein_test_string" -KeepSpecialChars -PreserveAcronyms
    # -> "meinTestString"

.NOTES
    Die Funktion ist pipeline-fähig.
#>

. "$PSScriptRoot\filter-string.ps1"
. "$PSScriptRoot\string-to-array.ps1"
function ToCamelCase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$Value,

        [Parameter()]
        [switch]$PreserveAcronyms,

        [Parameter()]
        [switch]$Invariant,

        [Parameter()]
        [switch]$KeepSpecialChars
    )

    begin {
        $inputBuffer = @()
        $culture = if ($Invariant.IsPresent) {
            [System.Globalization.CultureInfo]::InvariantCulture
        }
        else {
            [System.Globalization.CultureInfo]::CurrentCulture
        }
    }

    process {
        $inputBuffer += , $Value
    }

    end {
        $segments = @()

        foreach ($item in $inputBuffer) {
            # Sonderzeichen entfernen, falls nicht erlaubt
            $filtered = if ($KeepSpecialChars) {
                $item
            }
            else {
                ([regex]::Replace($item, '[^\\p{L}\\p{N} \-_]', ''))
            }

            # In Wörter zerlegen
            $words = $filtered | StringTo-Array -AsValues

            $builder = [System.Text.StringBuilder]::new()
            $isFirst = $true

            foreach ($word in $words) {
                if ([string]::IsNullOrWhiteSpace($word)) { continue }

                if ($isFirst) {
                    [void]$builder.Append($word.ToLower($culture))
                    $isFirst = $false
                    continue
                }

                if ($PreserveAcronyms.IsPresent -and $word -match '^[A-Z0-9]{2,}$') {
                    [void]$builder.Append($word)
                }
                else {
                    $first = $word.Substring(0, 1).ToUpper($culture)
                    $rest = if ($word.Length -gt 1) { $word.Substring(1).ToLower($culture) } else { '' }
                    [void]$builder.Append($first + $rest)
                }
            }

            Write-Output $builder.ToString()
        }
    }
}
 
<#
.SYNOPSIS
    Konvertiert einen Eingabestring in camelCase.

.DESCRIPTION
    Diese Funktion nimmt einen String entgegen und wandelt ihn mithilfe der Hilfsfunktion `ToCamelCase` in camelCase um.
    Dabei können optional Sonderzeichen entfernt, Akronyme erhalten und die Kulturwahl beeinflusst werden.
    Zusätzlich kann eine Zeichenliste angegeben werden, die beim Filtern erlaubt bleiben soll.

.PARAMETER Value
    Der Eingabestring, der konvertiert werden soll.

.PARAMETER PreserveAcronyms
    Wenn gesetzt, bleiben Wörter in Großbuchstaben (z. B. "API") unverändert erhalten.

.PARAMETER Invariant
    Wenn gesetzt, wird die InvariantCulture für die Groß-/Kleinschreibung verwendet.

.PARAMETER StripSpecial
    Wenn gesetzt, werden Sonderzeichen entfernt (über `ToCamelCase` → `filter-string`).

.PARAMETER AllowCharacters
    Ein optionaler String mit zusätzlichen erlaubten Zeichen, die beim Filtern nicht entfernt werden sollen.
    Muss ein regulärer Ausdruck ohne eckige Klammern sein.

.EXAMPLE
    ConvertTo-CamelCase "mein_test_string" -StripSpecial -PreserveAcronyms
    # -> "meinTestString"

.NOTES
    Die Funktion ist pipeline-fähig und Teil eines Moduls.
#>

# Hilfsfunktionen einbinden
. "$PSScriptRoot\CamelCase.ps1"

function ConvertTo-CamelCase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "The string to convert to camelCase")]
        [AllowNull()]
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
    }

    process {
        $inputBuffer += , $Value
    }

    end {
        foreach ($item in $inputBuffer) {
            if ($null -eq $item -or $item -eq '') {
                Write-Verbose "[ConvertTo-CamelCase] Input is null or empty. Returning empty string."
                Write-Output ''
                continue
            }
            try {
                Write-Verbose "[ConvertTo-CamelCase] Input: '$item'"
                $result = $item | ToCamelCase  -PreserveAcronyms
                Write-Verbose "[ConvertTo-CamelCase] Output: '$result'"
                Write-Output $result
            }
            catch {
                Write-Error "Fehler bei der Konvertierung von '$item' zu camelCase: $($_.Exception.Message)"
                Write-Error $_.ScriptStackTrace
                Write-Output ''
            }
        }
    }
}

# Funktion für Modulexport freigeben
Export-ModuleMember -Function ConvertTo-CamelCase
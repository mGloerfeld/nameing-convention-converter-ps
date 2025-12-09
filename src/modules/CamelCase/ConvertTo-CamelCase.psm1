 
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
. "$PSScriptRoot\camel-case.ps1"

function ConvertTo-CamelCase {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The string to convert to camelCase"
        )]
        [AllowEmptyString()]
        [string]$Value,

        [Parameter(HelpMessage = "Preserve uppercase acronyms like API, ID, etc.")]
        [switch]$PreserveAcronyms,

        [Parameter(HelpMessage = "Use InvariantCulture for case operations")]
        [switch]$Invariant
    )

    begin {
        Write-Verbose "[ConvertTo-CamelCase] Starting camelCase conversion process"
    }

    process {
        try {
            if ([string]::IsNullOrWhiteSpace($Value)) {
                Write-Verbose "[ConvertTo-CamelCase] Input is null, empty, or whitespace. Returning empty string."
                return ""
            }

            Write-Verbose "[ConvertTo-CamelCase] Converting: '$Value'"
            
            $result = $Value | ToCamelCase -PreserveAcronyms:$PreserveAcronyms.IsPresent -Invariant:$Invariant.IsPresent
            
            Write-Verbose "[ConvertTo-CamelCase] Result: '$result'"
            return $result
        }
        catch {
            Write-Error "[ConvertTo-CamelCase] Failed to convert '$Value' to camelCase: $($_.Exception.Message)"
            throw
        }
    }

    end {
        Write-Verbose "[ConvertTo-CamelCase] Conversion process completed"
    }
}

# Funktion für Modulexport freigeben
Export-ModuleMember -Function ConvertTo-CamelCase
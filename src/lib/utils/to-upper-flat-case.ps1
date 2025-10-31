
<#
.SYNOPSIS
   Converts an array of words into UPPERFLATCASE format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into UPPERFLATCASE notation. All words are converted to uppercase and concatenated together
   without any separators. This creates a single continuous uppercase string.

.PARAMETER Value
   An array of strings representing individual words to be converted to UPPERFLATCASE.

.EXAMPLE
   @("hello", "world") | ToUpperFlatCase
   Returns: "HELLOWORLD"

.EXAMPLE
   @("my", "constant", "name") | ToUpperFlatCase
   Returns: "MYCONSTANTNAME"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in UPPERFLATCASE format (all uppercase, no separators).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to uppercase and joined together without any separators.
   Empty or whitespace-only words are skipped.
#>
function ToUpperFlatCase {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Value,
        [Parameter()] [switch] $Invariant
    )
    begin {
        $builder = New-Object System.Text.StringBuilder
        $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
    }
    process {
        foreach ($word in $Value) {
            if ([string]::IsNullOrWhiteSpace($word)) { continue }
            [void]$builder.Append($word.ToUpper($culture))
        }
    }
    end { $builder.ToString() }
}
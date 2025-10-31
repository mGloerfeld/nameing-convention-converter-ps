
<#
.SYNOPSIS
    Converts an array of words to camel snake case format.

.DESCRIPTION
    Transforms an array of words into camel snake case notation where the first word 
    is lowercase and subsequent words are capitalized, all separated by underscores.
    Example: "hello", "world", "test" becomes "hello_World_Test"

.PARAMETER value
    An array of strings representing individual words to be converted.

.INPUTS
    String[] - An array of words to convert.

.OUTPUTS
    String - The camel snake case formatted string.

.EXAMPLE
    @("hello", "world") | ToCamelSnakeCase
    Returns: "hello_World"

.NOTES
    This function is designed to work with the pipeline and processes each word
    to build the final camel snake case string.
#>
function ToCamelSnakeCase {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Value,
        [Parameter()] [switch] $Invariant
    )
    BEGIN {
        $builder = New-Object System.Text.StringBuilder
        $isFirstWord = $true
        $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
    }
    PROCESS {
        foreach ($word in $Value) {
            if ([string]::IsNullOrWhiteSpace($word)) { continue }
            if ($isFirstWord) {
                [void]$builder.Append($word.ToLower($culture))
                $isFirstWord = $false
            }
            else {
                if ($word.Length -eq 1) {
                    [void]$builder.Append('_').Append($word.ToUpper($culture))
                } else {
                    $cap = $word.Substring(0,1).ToUpper($culture) + $word.Substring(1).ToLower($culture)
                    [void]$builder.Append('_').Append($cap)
                }
            }
        }
    }
    END { $builder.ToString() }
}
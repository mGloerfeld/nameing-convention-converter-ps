
<#
.SYNOPSIS
   Converts an array of words into Pascal_Snake_Case format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into Pascal_Snake_Case notation. Each word has its first letter capitalized while the rest
   are lowercase, and words are separated by underscores. This naming convention combines
   aspects of both PascalCase and snake_case.

.PARAMETER Value
   An array of strings representing individual words to be converted to Pascal_Snake_Case.

.EXAMPLE
   @("hello", "world") | ToPascalSnakeCase
   Returns: "Hello_World"

.EXAMPLE
   @("my", "class", "name") | ToPascalSnakeCase
   Returns: "My_Class_Name"

.INPUTSF
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in Pascal_Snake_Case format (each word capitalized, separated by underscores).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   Each word will have its first letter capitalized and the rest lowercase.
   Words are joined with underscores.
   Empty or whitespace-only words are skipped.
#>
function ToPascalSnakeCase {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Value,
        [Parameter()] [switch] $Invariant,
        [Parameter()] [switch] $PreserveAcronyms
    )
    begin {
        $builder = New-Object System.Text.StringBuilder
        $first = $true
        $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
    }
    process {
        foreach ($word in $Value) {
            if ([string]::IsNullOrWhiteSpace($word)) { continue }
            $segment = $word
            if ($PreserveAcronyms -and $segment -match '^[A-Z0-9]{2,}$') {
                $proper = $segment
            }
            elseif ($segment.Length -eq 1) {
                $proper = $segment.ToUpper($culture)
            }
            else {
                $proper = $segment.Substring(0, 1).ToUpper($culture) + $segment.Substring(1).ToLower($culture)
            }
            if ($first) { [void]$builder.Append($proper); $first = $false } else { [void]$builder.Append('_').Append($proper) }
        }
    }
    end { $builder.ToString() }
}
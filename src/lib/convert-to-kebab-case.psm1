. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-kebab-case.ps1"

<#
.SYNOPSIS
   Converts a string to kebab-case (lowercase words separated by hyphens).
.DESCRIPTION
   Splits the input into alphanumeric segments, lowercases them and joins with hyphens.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-KebabCase "Unified Canadian Aboriginal Syllabics" # unified-canadian-aboriginal-syllabics
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-KebabCase {
    [CmdletBinding()] param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Value
    )
    process {
        try { StringTo-Array $Value -AsValues | ToKebabCase }
        catch { Write-Error "Failed to convert '$Value' to kebab-case: $($_.Exception.Message)"; return $null }
    }
}

Export-ModuleMember -Function ConvertTo-KebabCase
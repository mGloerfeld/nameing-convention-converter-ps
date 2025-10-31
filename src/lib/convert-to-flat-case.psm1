. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-flat-case.ps1"

<#
.SYNOPSIS
   Converts a string to flatcase (all lowercase concatenated).
.DESCRIPTION
   Splits the input into alphanumeric segments, lowercases each and concatenates.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-FlatCase "Hello world!"  # helloworld
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-FlatCase {
    [CmdletBinding()] param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Value
    )
    process {
        try { StringTo-Array $Value -AsValues | ToFlatCase }
        catch { Write-Error "Failed to convert '$Value' to flatcase: $($_.Exception.Message)"; return $null }
    }
}

Export-ModuleMember -Function ConvertTo-FlatCase
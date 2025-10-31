. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-cobol-case.ps1"

<#
.SYNOPSIS
   Converts a string to COBOL-CASE (UPPERCASE words separated by hyphens).
.DESCRIPTION
   Splits the input into alphanumeric segments, uppercases them and joins with hyphens.
   Non-alphanumeric characters act as separators. Collapses multiple separators.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-CobolCase "Hello world!"  # HELLO-WORLD
.EXAMPLE
   ConvertTo-CobolCase "api response handler"  # API-RESPONSE-HANDLER
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-CobolCase {
    [CmdletBinding()] param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Value
    )
    process {
        try { StringTo-Array $Value -AsValues | ToCobolCase }
        catch { Write-Error "Failed to convert '$Value' to COBOL-CASE: $($_.Exception.Message)"; return $null }
    }
}

Export-ModuleMember -Function ConvertTo-CobolCase
. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-pascal-case.ps1"

<#
.SYNOPSIS
   Converts a string to PascalCase.
.DESCRIPTION
   Splits the input into alphanumeric segments; capitalizes first letter of each segment and
   lowercases the remainder; concatenates them with no separator.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-PascalCase "Hello world!"  # HelloWorld
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-PascalCase {
    [CmdletBinding()] param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Value
    )
    process {
        try { StringTo-Array $Value -AsValues | ToPascalCase }
        catch { Write-Error "Failed to convert '$Value' to PascalCase: $($_.Exception.Message)"; return $null }
    }
}

Export-ModuleMember -Function ConvertTo-PascalCase
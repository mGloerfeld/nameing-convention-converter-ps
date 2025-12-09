. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-screaming-snake-case.ps1"

<#
.SYNOPSIS
   Converts a string to SCREAMING_SNAKE_CASE.
.DESCRIPTION
   Splits input into alphanumeric segments, uppercases each, joins with underscores.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-ScreamingSnakeCase "Hello world!"  # HELLO_WORLD
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-ScreamingSnakeCase {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value
   )
   process {
      try { StringTo-Array $Value -AsValues | ToScreamingSnakeCase }
      catch { Write-Error "Failed to convert '$Value' to SCREAMING_SNAKE_CASE: $($_.Exception.Message)"; return $null }
   }
}

Export-ModuleMember -Function ConvertTo-ScreamingSnakeCase
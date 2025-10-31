. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-snake-case.ps1"

<#
.SYNOPSIS
   Converts a string to snake_case.
.DESCRIPTION
   Splits input into alphanumeric segments, lowercases them, joins with underscores.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-SnakeCase "Hello world!"  # hello_world
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-SnakeCase {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value
   )
   process {
      try { StringTo-Array $Value -AsValues | ToSnakeCase }
      catch { Write-Error "Failed to convert '$Value' to snake_case: $($_.Exception.Message)"; return $null }
   }
}

Export-ModuleMember -Function ConvertTo-SnakeCase
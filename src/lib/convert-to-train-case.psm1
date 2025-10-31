. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-train-case.ps1"

<#
.SYNOPSIS
   Converts a string to Train-Case (Capitalized words separated by hyphens).
.DESCRIPTION
   Splits input into alphanumeric segments, capitalizes first letter of each, lowercases rest, joins with hyphens.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-TrainCase "Hello world!"  # Hello-World
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-TrainCase {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value
   )
   process {
      try { StringTo-Array $Value -AsValues | ToTrainCase }
      catch { Write-Error "Failed to convert '$Value' to Train-Case: $($_.Exception.Message)"; return $null }
   }
}

Export-ModuleMember -Function ConvertTo-TrainCase
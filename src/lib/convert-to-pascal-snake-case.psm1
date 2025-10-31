. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-pascal-snake-case.ps1"

<#
.SYNOPSIS
   Converts a string to Pascal_Snake_Case.
.DESCRIPTION
   Splits into alphanumeric segments; capitalizes each segment (Pascal) and joins by underscores.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-PascalSnakeCase "Hello world!"  # Hello_World
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Returns empty string if no segments found.
#>
function ConvertTo-PascalSnakeCase {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value
   )
   process {
      try { StringTo-Array $Value -AsValues | ToPascalSnakeCase }
      catch { Write-Error "Failed to convert '$Value' to Pascal_Snake_Case: $($_.Exception.Message)"; return $null }
   }
}

Export-ModuleMember -Function ConvertTo-PascalSnakeCase
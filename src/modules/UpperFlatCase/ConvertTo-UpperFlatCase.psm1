. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-upper-flat-case.ps1"

<#
.SYNOPSIS
   Converts a string to UPPERFLATCASE (all uppercase concatenated).
.DESCRIPTION
   Splits the input into alphanumeric segments, uppercases each and concatenates.
.PARAMETER Value
   The input string to convert.
.EXAMPLE
   ConvertTo-UpperFlatCase "Hello world!"  # HELLOWORLD
.INPUTS
   System.String
.OUTPUTS
   System.String
.NOTES
   Provides backward-compatible alias 'ConvetTo-UpperFlatCase' for previous typo.
#>
function ConvertTo-UpperFlatCase {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value
   )
   process {
      try { StringTo-Array $Value -AsValues | ToUpperFlatCase }
      catch { Write-Error "Failed to convert '$Value' to UPPERFLATCASE: $($_.Exception.Message)"; return $null }
   }
}

Set-Alias -Name ConvetTo-UpperFlatCase -Value ConvertTo-UpperFlatCase -Scope Local -Option ReadOnly -ErrorAction SilentlyContinue

Export-ModuleMember -Function ConvertTo-UpperFlatCase -Alias ConvetTo-UpperFlatCase
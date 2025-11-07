
<#
.SYNOPSIS
   Converts an array of words into flatcase format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into flatcase notation. All words are converted to lowercase and concatenated together
   without any separators. This creates a single continuous lowercase string.

.PARAMETER Value
   An array of strings representing individual words to be converted to flatcase.

.EXAMPLE
   @("hello", "world") | ToFlatCase
   Returns: "helloworld"

.EXAMPLE
   @("my", "variable", "name") | ToFlatCase
   Returns: "myvariablename"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in flatcase format (all lowercase, no separators).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to lowercase and joined together without any separators.
   Empty or whitespace-only words are skipped.
#>
function ToFlatCase {
   [CmdletBinding()]
   [OutputType([string])]
   param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string[]]$Value,
      [Parameter()] [switch] $Invariant
   )
   begin {
      $builder = New-Object System.Text.StringBuilder
      $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
   }
   process {
      foreach ($word in $Value) {
         if ([string]::IsNullOrWhiteSpace($word)) { continue }
         [void]$builder.Append($word.ToLower($culture))
      }
   }
   end { $builder.ToString() }
}
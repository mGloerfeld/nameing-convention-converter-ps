
<#
.SYNOPSIS
   Converts an array of words into SCREAMING_SNAKE_CASE format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into SCREAMING_SNAKE_CASE notation. All words are converted to uppercase and separated by
   underscores. This naming convention is commonly used for constants, environment variables,
   and configuration settings.

.PARAMETER Value
   An array of strings representing individual words to be converted to SCREAMING_SNAKE_CASE.

.EXAMPLE
   @("hello", "world") | ToScreamingSnakeCase
   Returns: "HELLO_WORLD"

.EXAMPLE
   @("my", "constant", "name") | ToScreamingSnakeCase
   Returns: "MY_CONSTANT_NAME"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in SCREAMING_SNAKE_CASE format (uppercase words separated by underscores).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to uppercase and joined with underscores.
   Empty or whitespace-only words are skipped.
#>
function ToScreamingSnakeCase {
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
      $first = $true
      $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
   }
   process {
      foreach ($word in $Value) {
         if ([string]::IsNullOrWhiteSpace($word)) { continue }
         $upper = $word.ToUpper($culture)
         if ($first) { [void]$builder.Append($upper); $first = $false } else { [void]$builder.Append('_').Append($upper) }
      }
   }
   end { $builder.ToString() }
}
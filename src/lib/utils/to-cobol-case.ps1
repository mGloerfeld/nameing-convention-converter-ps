
<#
.SYNOPSIS
   Converts an array of words into COBOL-CASE format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into COBOL-CASE notation. All words are converted to uppercase and separated by hyphens.
   This naming convention is commonly used in COBOL programming and some configuration files.

.PARAMETER Value
   An array of strings representing individual words to be converted to COBOL-CASE.

.EXAMPLE
   @("hello", "world") | ToCobolCase
   Returns: "HELLO-WORLD"

.EXAMPLE
   @("my", "variable", "name") | ToCobolCase
   Returns: "MY-VARIABLE-NAME"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in COBOL-CASE format (uppercase words separated by hyphens).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to uppercase and joined with hyphens.
   Empty or whitespace-only words are skipped.
#>
function ToCobolCase {
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
      $first = $true
   }
   process {
      foreach ($word in $Value) {
         if ([string]::IsNullOrWhiteSpace($word)) { continue }
         $upper = $word.ToUpper($culture)
         if ($first) { [void]$builder.Append($upper); $first = $false } else { [void]$builder.Append('-').Append($upper) }
      }
   }
   end { $builder.ToString() }
}
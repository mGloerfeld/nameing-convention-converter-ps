
<#
.SYNOPSIS
   Converts an array of words into kebab-case format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into kebab-case notation. All words are converted to lowercase and separated by hyphens.
   This naming convention is commonly used in URLs, CSS class names, and file names.

.PARAMETER Value
   An array of strings representing individual words to be converted to kebab-case.

.EXAMPLE
   @("hello", "world") | ToKebabCase
   Returns: "hello-world"

.EXAMPLE
   @("my", "variable", "name") | ToKebabCase
   Returns: "my-variable-name"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in kebab-case format (lowercase words separated by hyphens).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to lowercase and joined with hyphens.
   Empty or whitespace-only words are skipped.
#>
function ToKebabCase {
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
         $lower = $word.ToLower($culture)
         if ($first) { [void]$builder.Append($lower); $first = $false } else { [void]$builder.Append('-').Append($lower) }
      }
   }
   end { $builder.ToString() }
}
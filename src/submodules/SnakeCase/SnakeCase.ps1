
<#
.SYNOPSIS
   Converts an array of words into snake_case format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into snake_case notation. All words are converted to lowercase and separated by underscores.
   This naming convention is commonly used for variable names, function names, and file names
   in many programming languages.

.PARAMETER Value
   An array of strings representing individual words to be converted to snake_case.

.EXAMPLE
   @("hello", "world") | ToSnakeCase
   Returns: "hello_world"

.EXAMPLE
   @("my", "variable", "name") | ToSnakeCase
   Returns: "my_variable_name"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in snake_case format (lowercase words separated by underscores).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   All words are converted to lowercase and joined with underscores.
   Empty or whitespace-only words are skipped.
#>
function ToSnakeCase {
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
         if ($first) { [void]$builder.Append($lower); $first = $false } else { [void]$builder.Append('_').Append($lower) }
      }
   }
   end { $builder.ToString() }
}
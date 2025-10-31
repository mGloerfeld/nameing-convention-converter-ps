
<#
.SYNOPSIS
   Converts an array of words into PascalCase format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into PascalCase notation. Each word has its first letter capitalized while the rest are
   lowercase, and all words are concatenated together without separators. This is commonly
   used for class names, type names, and public members in many programming languages.

.PARAMETER Value
   An array of strings representing individual words to be converted to PascalCase.

.EXAMPLE
   @("hello", "world") | ToPascalCase
   Returns: "HelloWorld"

.EXAMPLE
   @("my", "class", "name") | ToPascalCase
   Returns: "MyClassName"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in PascalCase format (each word capitalized, no separators).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   Each word will have its first letter capitalized and the rest lowercase.
   Empty or whitespace-only words are skipped.
#>
function ToPascalCase {
   [CmdletBinding()]
   [OutputType([string])]
   param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string[]]$Value,
      [Parameter()] [switch] $Invariant,
      [Parameter()] [switch] $PreserveAcronyms
   )
   begin {
      $builder = New-Object System.Text.StringBuilder
      $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
   }
   process {
      foreach ($word in $Value) {
         if ([string]::IsNullOrWhiteSpace($word)) { continue }
         if ($PreserveAcronyms -and $word -match '^[A-Z0-9]{2,}$') { [void]$builder.Append($word); continue }
         if ($word.Length -eq 1) { [void]$builder.Append($word.ToUpper($culture)); continue }
         $segment = $word.Substring(0, 1).ToUpper($culture) + $word.Substring(1).ToLower($culture)
         [void]$builder.Append($segment)
      }
   }
   end { $builder.ToString() }
}
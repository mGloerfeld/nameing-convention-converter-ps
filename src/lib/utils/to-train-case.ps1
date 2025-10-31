
<#
.SYNOPSIS
   Converts an array of words into Train-Case format.

.DESCRIPTION
   This function takes an array of words (typically from StringTo-Array) and converts them
   into Train-Case notation. Each word has its first letter capitalized while the rest are
   lowercase, and words are separated by hyphens. This naming convention is also known as
   "kebab-case with capitalization" or "Pascal-kebab-case".

.PARAMETER Value
   An array of strings representing individual words to be converted to Train-Case.

.EXAMPLE
   @("hello", "world") | ToTrainCase
   Returns: "Hello-World"

.EXAMPLE
   @("my", "class", "name") | ToTrainCase
   Returns: "My-Class-Name"

.INPUTS
   String[]
   An array of strings representing individual words.

.OUTPUTS
   String
   A single string in Train-Case format (each word capitalized, separated by hyphens).

.NOTES
   This function is designed to work with the pipeline output from StringTo-Array.
   Each word will have its first letter capitalized and the rest lowercase.
   Words are joined with hyphens.
   Empty or whitespace-only words are skipped.
#>
function ToTrainCase {
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
      $first = $true
      $culture = if ($Invariant) { [System.Globalization.CultureInfo]::InvariantCulture } else { [System.Globalization.CultureInfo]::CurrentCulture }
   }
   process {
      foreach ($word in $Value) {
         if ([string]::IsNullOrWhiteSpace($word)) { continue }
         if ($PreserveAcronyms -and $word -match '^[A-Z0-9]{2,}$') { $proper = $word }
         elseif ($word.Length -eq 1) { $proper = $word.ToUpper($culture) }
         else { $proper = $word.Substring(0, 1).ToUpper($culture) + $word.Substring(1).ToLower($culture) }
         if ($first) { [void]$builder.Append($proper); $first = $false } else { [void]$builder.Append('-').Append($proper) }
      }
   }
   end { $builder.ToString() }
}
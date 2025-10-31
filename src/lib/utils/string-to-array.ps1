
<#
.SYNOPSIS
   Splits an input string into word segments using Unicode letter/number detection.

.DESCRIPTION
   Extracts contiguous sequences of Unicode letters (\p{L}) and optionally numbers (\p{N}).
   Additional optional behaviors:
     -SplitCamel splits camelCase/PascalCase tokens into their individual parts.
     -ExcludeNumbers omits pure number segments.
     -MinLength filters out segments shorter than a specified length.
     -AsValues returns plain strings instead of Match objects (default remains MatchCollection).

.PARAMETER Value
   The input string to split.

.PARAMETER SplitCamel
   When provided, camelCase or PascalCase segments are further split at transitions
   from lower-to-upper and upper-to-lower followed by lower (handling simple acronyms).

.PARAMETER ExcludeNumbers
   Omits segments consisting only of digits.

.PARAMETER MinLength
   Filters out segments shorter than this length. Default is 1 (no filtering).

.PARAMETER AsValues
   Return an array of plain strings instead of Match objects.

.EXAMPLE
   StringTo-Array "Hello world!" -AsValues
   Returns: @("Hello", "world")

.EXAMPLE
   StringTo-Array "camelCaseExample123" -SplitCamel -ExcludeNumbers -AsValues
   Returns: @("camel", "Case", "Example")

.EXAMPLE
   StringTo-Array "kebab-case-example" -AsValues
   Returns: @("kebab", "case", "example")

.INPUTS
   System.String

.OUTPUTS
   System.Text.RegularExpressions.MatchCollection (default) OR System.String[] when -AsValues is used.

.NOTES
   - Uses Select-String for Unicode-aware pattern matching.
   - Camel splitting is heuristic; acronyms like HTTPRequest become HTTP + Request.
   - For advanced tokenization, consider adding bespoke regex or a dedicated parser.
#>
function StringTo-Array {
   [CmdletBinding()] param(
      [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
      [ValidateNotNullOrEmpty()]
      [string] $Value,

      [Parameter()] [switch] $SplitCamel,
      [Parameter()] [switch] $ExcludeNumbers,
      [Parameter()] [ValidateRange(1, 1024)] [int] $MinLength = 1,
      [Parameter()] [switch] $AsValues
   )

   process {
      try {
         $pattern = '[\p{L}\p{N}]+'
         $matchResult = $Value | Select-String -Pattern $pattern -AllMatches
         if (-not $matchResult -or -not $matchResult.Matches) { return @() }

         $segments = @()
         foreach ($m in $matchResult.Matches) {
            $raw = $m.Value
            if ($ExcludeNumbers -and $raw -match '^[0-9]+$') { continue }

            $toAdd = @($raw)
            if ($SplitCamel -and $raw -match '[A-Za-z]' -and $raw.Length -gt 1) {
               # Split on transitions: acronym boundaries and lower->upper boundaries
               $toAdd = [System.Text.RegularExpressions.Regex]::Matches($raw, '([A-Z]+(?![a-z]))|([A-Z]?[a-z]+)|([0-9]+)') | ForEach-Object { $_.Value }
            }

            foreach ($seg in $toAdd) {
               if ($seg.Length -ge $MinLength) {
                  if ($AsValues) { $segments += $seg } else { $segments += $m } # preserve original Match object when not AsValues
               }
            }
         }

         return $segments
      }
      catch {
         Write-Error "Failed to process string '$Value': $($_.Exception.Message)"
         return @()
      }
   }
}
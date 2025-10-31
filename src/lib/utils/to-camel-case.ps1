
<#
.SYNOPSIS
   Converts an array of words into camelCase format.

.DESCRIPTION
   Takes a sequence of words (typically produced by StringTo-Array) and returns a single
   camelCase string. The first word is fully lowercased. Subsequent words have their first
   letter uppercased and the remainder lowercased. Optional switches allow preserving fully
   uppercased acronyms (e.g. "API") and using culture invariant casing rules.

.PARAMETER Value
   Sequence of word segments to convert.

.PARAMETER PreserveAcronyms
   If set, words that are entirely uppercase and length > 1 are preserved as-is (e.g. "API").

.PARAMETER Invariant
   If set, uses culture invariant ToLower/ToUpper operations for deterministic casing.

.EXAMPLE
   @("hello", "world") | ToCamelCase
   Returns: "helloWorld"

.EXAMPLE
   @("my", "API", "client") | ToCamelCase -PreserveAcronyms
   Returns: "myAPIClient"

.EXAMPLE
   @("straße", "über") | ToCamelCase -Invariant
   Returns: "strasseUber" (culture invariant handling of ß -> ss may vary by .NET version)

.INPUTS
   String[]

.OUTPUTS
   String

.NOTES
   - Empty or whitespace-only segments are skipped.
   - Acronym preservation only applies to segments matching ^[A-Z0-9]{2,}$.
   - Invariant switch uses [CultureInfo]::InvariantCulture for casing.
#>
function ToCamelCase {
    [CmdletBinding()] param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Value,

        [Parameter()] [switch] $PreserveAcronyms,
        [Parameter()] [switch] $Invariant
    )

    begin {
        $builder = New-Object System.Text.StringBuilder
        $isFirst = $true
        if ($Invariant) { $culture = [System.Globalization.CultureInfo]::InvariantCulture } else { $culture = [System.Globalization.CultureInfo]::CurrentCulture }
    }

    process {
        try {
            foreach ($word in $Value) {
                if ([string]::IsNullOrWhiteSpace($word)) { continue }

                $segment = $word
                # Invariant or culture specific normalization (lower for first pass)
                $lower = $segment.ToLower($culture)

                if ($isFirst) {
                    # first word -> fully lower
                    [void]$builder.Append($lower)
                    $isFirst = $false
                    continue
                }

                if ($PreserveAcronyms -and $segment -match '^[A-Z0-9]{2,}$') {
                    # preserve acronym exactly
                    [void]$builder.Append($segment)
                    continue
                }

                if ($segment.Length -eq 1) {
                    [void]$builder.Append($segment.ToUpper($culture))
                }
                else {
                    $first = $segment.Substring(0, 1).ToUpper($culture)
                    $rest = $segment.Substring(1).ToLower($culture)
                    [void]$builder.Append($first + $rest)
                }
            }
        }
        catch {
            Write-Error "Failed processing segment '$word': $($_.Exception.Message)"
        }
    }

    end { $builder.ToString() }
}
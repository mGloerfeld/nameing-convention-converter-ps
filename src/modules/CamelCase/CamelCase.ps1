<#
.SYNOPSIS
    Converts an input string to camelCase.

.DESCRIPTION
    This function transforms a string into camelCase format.
    It identifies individual words and formats them accordingly:
    - The first word is fully lowercase.
    - Subsequent words start with an uppercase letter.
    - Optionally, special characters can be preserved.
    - Optionally, acronyms (e.g., "API", "ID") can be preserved.
    - Optionally, culture can be set to InvariantCulture.

.PARAMETER Value
    The input string to be converted.

.PARAMETER PreserveAcronyms
    If set, words in uppercase (e.g., "API") will be preserved as-is.

.PARAMETER Invariant
    If set, uses InvariantCulture for casing operations.

.PARAMETER KeepSpecialChars
    If set, special characters will be preserved during filtering.

.EXAMPLE
    ToCamelCase "my_test_string" -KeepSpecialChars -PreserveAcronyms
    # -> "myTestString"

.NOTES
    This function supports pipeline input.
#>

. "$PSScriptRoot\..\..\private\filter-string.ps1"
. "$PSScriptRoot\..\..\private\string-to-array.ps1"

function ToCamelCase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [AllowNull()]
        [string]$Value,

        [Parameter()]
        [switch]$PreserveAcronyms,

        [Parameter()]
        [switch]$Invariant,

        [Parameter()]
        [switch]$KeepSpecialChars
    )

    begin {
        $inputBuffer = @()

        # Determine culture for casing operations
        $culture = if ($Invariant.IsPresent) {
            [System.Globalization.CultureInfo]::InvariantCulture
        }
        else {
            [System.Globalization.CultureInfo]::CurrentCulture
        }
    }

    process {
        # Collect input values into buffer
        $inputBuffer += , $Value
    }

    end {
        foreach ($item in $inputBuffer) {
            if ([string]::IsNullOrWhiteSpace($item)) {
                Write-Output ''
                continue
            }

            # Filter input string (e.g., remove special characters)
            $filtered = $item | filter-string

            # Split filtered string into words
            $words = $filtered | StringTo-Array -AsValues

            $builder = [System.Text.StringBuilder]::new()
            $isFirst = $true

            foreach ($word in $words) {
                if ([string]::IsNullOrWhiteSpace($word)) { continue }

                if ($isFirst) {
                    # First word: lowercase
                    [void]$builder.Append($word.ToLower($culture))
                    $isFirst = $false
                }
                else {
                    if ($PreserveAcronyms.IsPresent) {
                        # Preserve acronyms as-is
                        [void]$builder.Append($word)
                    }
                    else {
                        # Capitalize first letter, lowercase the rest
                        $first = $word.Substring(0, 1).ToUpper($culture)
                        $rest = if ($word.Length -gt 1) {
                            $word.Substring(1).ToLower($culture)
                        }
                        else {
                            ''
                        }
                        [void]$builder.Append($first + $rest)
                    }
                }
            }

            # Output the final camelCase string
            Write-Output $builder.ToString()
        }
    }
}
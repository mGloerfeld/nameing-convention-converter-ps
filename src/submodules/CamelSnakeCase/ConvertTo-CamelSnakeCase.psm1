. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-camel-snake-case.ps1"
1
<#
.SYNOPSIS
   Converts text into camel_Snake_Case format.

.DESCRIPTION
   Splits the input string into alphanumeric word segments, lowercases the first word
   fully, and capitalizes the first letter of each subsequent word while keeping the rest
   lowercase. Words are then joined by underscores. This is a hybrid between camelCase
   and snake_case, e.g. "helloWorld" -> "hello_World" when segmented.

.PARAMETER Value
   The input string to be converted. Must be a non-empty string. Accepts pipeline input.

.EXAMPLE
   ConvertTo-CamelSnakeCase "Hello world!"
   Returns: hello_World

.EXAMPLE
   ConvertTo-CamelSnakeCase "  Hello   heros  from  PowerShell  !  "
   Returns: hello_Heros_From_PowerShell

.INPUTS
   System.String

.OUTPUTS
   System.String
   A single string in camel_Snake_Case, e.g. 'hello_World'.

.NOTES
   - Non alphanumeric characters are treated as separators.
   - Multiple whitespace / punctuation sequences are collapsed.
   - Returns an empty string if no alphanumeric characters are found.
   - Uses Unicode categories \p{L} (letters) and \p{N} (numbers) for word detection.
#>
function ConvertTo-CamelSnakeCase {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            HelpMessage = "String to convert to camel_Snake_Case"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    process {
        try {
            $segments = StringTo-Array $Value
            if (-not $segments -or $segments.Count -eq 0) { return "" }

            $result = ""
            $isFirst = $true
            foreach ($seg in $segments) {
                if ($isFirst) {
                    $result += $seg.ToLower()
                    $isFirst = $false
                }
                else {
                    if ($seg.Length -eq 1) {
                        $result += "_" + $seg.ToUpper()
                    }
                    else {
                        $result += "_" + $seg.Substring(0, 1).ToUpper() + $seg.Substring(1).ToLower()
                    }
                }
            }
            return $result
        }
        catch {
            Write-Error "Failed to convert '$Value' to camel_Snake_Case: $($_.Exception.Message)"
            return $null
        }
    }
}

Export-ModuleMember -Function ConvertTo-CamelSnakeCase
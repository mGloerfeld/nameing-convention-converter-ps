
<#
.SYNOPSIS
    Converts a string into an array of words by extracting alphanumeric sequences.

.DESCRIPTION
    The ConvertTo-WordArray function takes a string input and extracts all sequences 
    of letters and numbers, returning them as an array. This is useful for parsing 
    strings that contain words separated by special characters, spaces, or mixed case.

.PARAMETER InputString
    The string to be converted into an array of words. This parameter is mandatory and supports pipeline input.

.EXAMPLE
    ConvertTo-WordArray "hello-world_test123"
    # Returns: @("hello", "world", "test123")

.EXAMPLE
    "camelCaseString" | ConvertTo-WordArray
    # Returns: @("camel", "Case", "String")

.EXAMPLE
    @("foo-bar", "baz_qux") | ConvertTo-WordArray
    # Returns: @("foo", "bar", "baz", "qux")

.OUTPUTS
    System.String[]
    An array of strings containing the extracted words.

.NOTES
    - Uses Unicode character classes to properly handle international characters:
      - \p{L} matches any Unicode letter
      - \p{N} matches any Unicode number
    - Exported via Export-ModuleMember
#>
function ConvertTo-WordArray {
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(
            Mandatory = $true, 
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNull()]
        [AllowEmptyString()]
        [string] $InputString
    )

    begin {
        Write-Verbose "[ConvertTo-WordArray] Starting word extraction process"
    }

    process {
        try {
            if ([string]::IsNullOrWhiteSpace($InputString)) {
                Write-Verbose "[ConvertTo-WordArray] Input string is null, empty, or whitespace only"
                return
            }

            $pattern = '[\p{L}\p{N}]+'
            Write-Verbose "[ConvertTo-WordArray] Extracting words from: '$InputString'"
            $matches = [regex]::Matches($InputString, $pattern)

            if ($matches.Count -eq 0) {
                Write-Verbose "[ConvertTo-WordArray] No alphanumeric sequences found"
                return
            }

            $result = $matches | ForEach-Object { $_.Value }
            Write-Verbose "[ConvertTo-WordArray] Extracted $($result.Count) word(s): $($result -join ', ')"
            $result
        }
        catch {
            Write-Error "[ConvertTo-WordArray] Failed to extract words from string: $($_.Exception.Message)"
            throw
        }
    }

    end {
        Write-Verbose "[ConvertTo-WordArray] Word extraction process completed"
    }
}

# Export the function
Export-ModuleMember -Function ConvertTo-WordArray



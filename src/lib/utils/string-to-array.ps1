
<#
.SYNOPSIS
    Converts a string into an array of words by extracting alphanumeric sequences.

.DESCRIPTION
    The ConvertTo-WordArray function takes a string input and extracts all sequences 
    of letters and numbers, returning them as an array. This is useful for parsing 
    strings that contain words separated by special characters, spaces, or mixed case.

.PARAMETER InputString
    The string to be converted into an array of words. This parameter is mandatory.

.PARAMETER ValueFromPipeline
    Allows the function to accept pipeline input.

.EXAMPLE
    ConvertTo-WordArray "hello-world_test123"
    Returns: @("hello", "world", "test123")

.EXAMPLE
    "camelCaseString" | ConvertTo-WordArray
    Returns: @("camel", "Case", "String")

.EXAMPLE
    ConvertTo-WordArray "  Hello	world from PowerShell !  "
    Returns: @("Hello", "world", "from", "PowerShell")

.OUTPUTS
    System.String[]
    An array of strings containing the extracted words.

.NOTES
    This function uses Unicode character classes to properly handle international characters:
    - \p{L} matches any Unicode letter
    - \p{N} matches any Unicode number
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
        Write-Verbose "Starting word extraction process"
    }
    
    process {
        try {
            # Handle empty or whitespace-only strings
            if ([string]::IsNullOrWhiteSpace($InputString)) {
                Write-Verbose "Input string is null, empty, or whitespace only"
                return @()
            }
            
            # Extract sequences of Unicode letters and numbers
            # This pattern handles international characters and mixed alphanumeric sequences
            $pattern = '[\p{L}\p{N}]+'
            
            Write-Verbose "Extracting words from: '$InputString'"
            
            $matches = [regex]::Matches($InputString, $pattern)
            
            if ($matches.Count -eq 0) {
                Write-Verbose "No alphanumeric sequences found"
                return @()
            }
            
            # Extract the matched values and return as array
            $result = $matches | ForEach-Object { $_.Value }
            
            Write-Verbose "Extracted $($result.Count) word(s): $($result -join ', ')"
            
            return $result
        }
        catch {
            Write-Error "Failed to extract words from string: $($_.Exception.Message)"
            throw
        }
    }
    
    end {
        Write-Verbose "Word extraction process completed 2"
    }
}

# Create an alias for backward compatibility
Set-Alias -Name StringTo-Array -Value ConvertTo-WordArray

# Export the function
Export-ModuleMember -Function ConvertTo-WordArray -Alias StringTo-Array
 
. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-camel-case.ps1"

<#
.SYNOPSIS
   Converts text into camelCase.

.DESCRIPTION
   Converts any text into camelCase notation. The first word is entirely lowercase,
   and subsequent words have their first letter capitalized. All unnecessary spaces
   and special characters are filtered out.

.PARAMETER Value
   The input string to be converted to camelCase. Required.
   
.EXAMPLE
   ConvertTo-CamelCase "Hello world"
   Returns: helloWorld

.EXAMPLE
   ConvertTo-CamelCase "my variable name"
   Returns: myVariableName

.INPUTS
   System.String
   Any string input like 'Hello world!' or 'my-variable-name'.

.OUTPUTS
   System.String
   A converted string in camelCase format like 'helloWorld'.

.NOTES
   - Removes all leading, trailing, and special characters
   - Only preserves alphanumeric characters
   - The first word is entirely lowercase
   - Subsequent words have their first letter capitalized
#>
function ConvertTo-CamelCase {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            HelpMessage = "The string to convert to camelCase"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    process {
        try {
            return StringTo-Array $Value | ToCamelCase
        }
        catch {
            Write-Error "Failed to convert '$Value' to camelCase: $($_.Exception.Message)"
            return $null
        }
    }
}

Export-ModuleMember -Function ConvertTo-CamelCase
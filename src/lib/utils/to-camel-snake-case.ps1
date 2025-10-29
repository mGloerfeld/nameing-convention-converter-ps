
<#
.SYNOPSIS
    Converts an array of words to camel snake case format.

.DESCRIPTION
    Transforms an array of words into camel snake case notation where the first word 
    is lowercase and subsequent words are capitalized, all separated by underscores.
    Example: "hello", "world", "test" becomes "hello_World_Test"

.PARAMETER value
    An array of strings representing individual words to be converted.

.INPUTS
    String[] - An array of words to convert.

.OUTPUTS
    String - The camel snake case formatted string.

.EXAMPLE
    @("hello", "world") | ToCamelSnakeCase
    Returns: "hello_World"

.NOTES
    This function is designed to work with the pipeline and processes each word
    to build the final camel snake case string.
#>
function ToCamelSnakeCase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [String[]] $value 
    )
 
    BEGIN {
        $result = ""
        $isFirstWord = $true
    }

    PROCESS {
        if ($isFirstWord) {
            # First word should be lowercase
            $result += $value.ToLower()
            $isFirstWord = $false
        }
        else {
            # Subsequent words should be capitalized and preceded by underscore
            $capitalizedWord = $value.Substring(0, 1).ToUpper() + $value.Substring(1).ToLower()
            $result += "_" + $capitalizedWord
        }
    }

    END {
        return $result
    }
}
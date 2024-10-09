<#
.Synopsis
   Convert text into Camel Case. 
.DESCRIPTION
   Converts any text into Kebab Case notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-Upper-CamelCase("Unified Canadian Aboriginal Syllabics")
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Any string like 'Unified Canadian Aboriginal Syllabics'
.OUTPUTS
   An converted string like 'unified-canadian-aboriginal-syllabics'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-UpperCamelCase {
    param (
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    # Remove all leading, colseing and multiple whitespaces in text. 
    $Text = $Text -replace '(\s+)',' '
    $Parts = $Text.Trim().Split(" ").ToLower();

    # return [string]::Join("-", $Parts);     
    return "Hello World!"       
}

 Export-ModuleMember -Function ConvertTo-UpperCamelCase  
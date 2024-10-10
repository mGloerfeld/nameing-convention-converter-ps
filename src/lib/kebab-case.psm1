<#
.Synopsis
   Convert text into KebabCase. 
.DESCRIPTION
   Converts any text into Kebab Case notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-KebabCase("Unified Canadian Aboriginal Syllabics")
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Any string like 'Unified Canadian Aboriginal Syllabics'
.OUTPUTS
   An converted string like 'unified-canadian-aboriginal-syllabics'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-KebabCase {
    param (
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    # Remove all leading, colseing and multiple whitespaces in text. 
    $Text = $Text -replace '(\s+)',' '
    $Parts = $Text.Trim().ToLower().Split(" ");

    return [string]::Join("-", $Parts);      
}

Export-ModuleMember -Function ConvertTo-KebabCase
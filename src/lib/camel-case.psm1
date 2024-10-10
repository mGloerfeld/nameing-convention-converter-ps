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
   An converted string like 'UnifiedCanadianAboriginalSyllabics'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-CamelCase {
    param (
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    # Remove all leading, colseing and multiple whitespaces in text. 
    $Text = $Text -replace '(\s+)',' '
    $Parts = $Text.Trim().Split(" ");

   # Capitalize the first letter of each word
    $capitalizedWords = $Parts | ForEach-Object {
      $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
   } 

     return [string]::Join("", $capitalizedWords);     
}

Export-ModuleMember -Function ConvertTo-CamelCase
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
function ConvertTo-LowerCamelCase {
    param (
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    # Remove all leading, colseing and multiple whitespaces in text. 
    $Text = $Text -replace '(\s+)',' '
    $Parts = $Text.Trim().Split(" ");
    $capitalizedWords="";

    For ($i=0; $i -lt  $Parts.Count; $i++) {
     
      if($i -eq 0){
          $capitalizedWords += $($Parts[$i].Substring(0,1).ToLower() +  $Parts[$i].Substring(1).ToLower());
      }else {
           $capitalizedWords += $($Parts[$i].Substring(0,1).ToUpper() + $Parts[$i].Substring(1).ToLower());
      }
      
   }
  
     return [string]::Join("", $capitalizedWords);     
}

Export-ModuleMember -Function ConvertTo-LowerCamelCase

 
<#
.Synopsis
   Converts text into CamelCase. 
.DESCRIPTION
   Converts any text into camelCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-CamelCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-CamelCase {
    param (
        [string]$Text
    )
 
    if ([string]::IsNullOrEmpty($Text) -or [string]::IsNullOrWhiteSpace($Text)) {
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

Export-ModuleMember -Function ConvertTo-CamelCase
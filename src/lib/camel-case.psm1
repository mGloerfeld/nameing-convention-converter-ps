. ".\utils\cleanup-string.ps1"

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
    
   param
   (
      [parameter(Mandatory=$true, Position=0)]
      [ValidateNotNull()]
      [string] $value
   )
 
   return  StringTo-Array $value | ToCamelCase
}

function ToCamelCase() {
    
 param
   (
      [Parameter(Mandatory=$true, Position=0, ValueFromPipeline = $true)]
      [ValidateNotNull()]
      [String[]] $value 
   )
 
 BEGIN {
  $str = "";
 }

 PROCESS {
       
   if($str -eq ""){
      $str += $($value.Substring(0,1).ToLower() +  $value.Substring(1).ToLower())
   }else {
       $str += $($value.Substring(0,1).ToUpper() + $value.Substring(1).ToLower())
   }
 }

  END {
   return $str
   }
}

 Export-ModuleMember -Function ConvertTo-CamelCase
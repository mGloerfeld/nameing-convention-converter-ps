. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-upper-flat-case.ps1"
         

<#
.Synopsis
   Converts text into UpperFlatCase. 
.DESCRIPTION
   Converts any text into UpperFlatCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-UpperFlatCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-UpperFlatCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToUpperFlatCase
}

Export-ModuleMember -Function ConvertTo-UpperFlatCase
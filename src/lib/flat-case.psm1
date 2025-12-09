. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-flat-case.ps1"

<#
.Synopsis
   Converts text into FlatCase. 
.DESCRIPTION
   Converts any text into FlatCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-FlatCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-FlatCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToFlatCase
}

Export-ModuleMember -Function ConvertTo-FlatCase

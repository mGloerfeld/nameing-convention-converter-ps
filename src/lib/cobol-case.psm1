. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-cobol-case.ps1"

<#
.Synopsis
   Converts text into CobolCase. 
.DESCRIPTION
   Converts any text into CobolCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-CobolCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-CobolCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToCobolCase    
}

Export-ModuleMember -Function ConvertTo-CobolCase

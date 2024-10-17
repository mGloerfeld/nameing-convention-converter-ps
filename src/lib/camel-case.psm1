. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-camel-case.ps1"

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
 
 Export-ModuleMember -Function ConvertTo-CamelCase
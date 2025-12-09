. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-camel-snake-case.ps1"

<#
.Synopsis
   Converts text into CamelSnakeCase. 
.DESCRIPTION
   Converts any text into CamelSnakeCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-CamelSnakeCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-CamelSnakeCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToCamelSnakeCase
}

Export-ModuleMember -Function ConvertTo-CamelSnakeCase

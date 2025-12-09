. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-snake-case.ps1"

<#
.Synopsis
   Converts text into SnakeCase. 
.DESCRIPTION
   Converts any text into SnakeCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-SnakeCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-SnakeCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToSnakeCase   
}

Export-ModuleMember -Function ConvertTo-SnakeCase

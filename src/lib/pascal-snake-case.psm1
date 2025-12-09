. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-pascal-snake-case.ps1"

<#
.Synopsis
   Converts text into PascalSnakeCase. 
.DESCRIPTION
   Converts any text into PascalSnakeCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-PascalSnakeCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-PascalSnakeCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToPascalSnakeCase
}

Export-ModuleMember -Function ConvertTo-PascalSnakeCase

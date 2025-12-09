. $PSScriptRoot"\utils\to-word-array.ps1"
. $PSScriptRoot"\utils\to-screaming-snake-case.ps1"

<#
.Synopsis
   Converts text into ScreamingSnakeCase. 
.DESCRIPTION
   Converts any text into ScreamingSnakeCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-ScreamingSnakeCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-ScreamingSnakeCase {

   param
   (
      [parameter(Mandatory = $true, Position = 0)]
      [ValidateNotNull()]
      [string] $value
   )
  
   return  ConvertTo-WordArray $value | ToScreamingSnakeCase
}

Export-ModuleMember -Function ConvertTo-ScreamingSnakeCase

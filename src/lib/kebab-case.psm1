. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-kebab-case.ps1"

<#
.Synopsis
   Convert text into KebabCase. 
.DESCRIPTION
   Converts any text into KebabCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-KebabCase(" ")
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Any string like 'Unified Canadian Aboriginal Syllabics'
.OUTPUTS
   An converted string like 'unified-canadian-aboriginal-syllabics'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-KebabCase {

      param
   (
      [parameter(Mandatory=$true, Position=0)]
      [ValidateNotNull()]
      [string] $value
   )
  
     return  StringTo-Array $value | ToKebabCase
}

Export-ModuleMember -Function ConvertTo-KebabCase
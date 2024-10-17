. $PSScriptRoot"\utils\string-to-array.ps1"
. $PSScriptRoot"\utils\to-train-case.ps1"

<#
.Synopsis
   Converts text into TrainCase. 
.DESCRIPTION
   Converts any text into TrainCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-TrainCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-TrainCase {

      param
   (
      [parameter(Mandatory=$true, Position=0)]
      [ValidateNotNull()]
      [string] $value
   )
  
     return  StringTo-Array $value | ToTrainCase
}

Export-ModuleMember -Function ConvertTo-TrainCase
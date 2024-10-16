
 function StringTo-Array {

 param
   (
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateNotNull()]
      [string] $value 
   )
   
   $result = $value | Select-String -Pattern "[\p{L}|\p{N}]+" -AllMatches  
   
   return  $result.Matches
 }
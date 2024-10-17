
 function StringTo-Array {

 param
   (
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateNotNull()]
      [string] $value 
   )
   
  # $Matches -> Die $Matches Variable funktioniert mit den -match Operatoren und -notmatch Operatoren

   $result = $value | Select-String -Pattern "[\p{L}|\p{N}]+" -AllMatches  
   
   return  $result.Matches
 }
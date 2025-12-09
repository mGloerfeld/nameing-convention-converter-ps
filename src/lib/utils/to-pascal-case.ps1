
function ToPascalCase() {
    
 param
   (
      [Parameter(Mandatory=$true, Position=0, ValueFromPipeline = $true)]
      [ValidateNotNull()]
      [String[]] $value 
   )
 
 BEGIN {
  $str = "";
 }

 PROCESS {

      $str += $($value.Substring(0,1).ToLower() +  $value.Substring(1).ToLower())
 }

  END {
   return $str
   }
}


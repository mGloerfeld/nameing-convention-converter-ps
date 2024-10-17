
function ToCamelCase() {
    
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
   
   if($str -eq ""){
      $str +=  $value.ToLower()
   }else {
       $str += $($value.Substring(0,1).ToUpper() + $value.Substring(1).ToLower())
   }
 }

  END {
   return $str
   }
}

function ToPascalSnakeCase() {
    
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
       
   $str += $($value.Substring(0,1).ToLower() +  $value.Substring(1).ToLower() + "_")
 }

  END {
   return $str.Substring(0, $str.Length - 1)
   }
}
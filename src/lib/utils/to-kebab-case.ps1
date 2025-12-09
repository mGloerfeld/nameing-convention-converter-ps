
function ToKebabCase() {
    
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
       
 
      $str += $($value.ToLower() +  "-")
 }

  END {
   return $str.Substring(0, $str.Length - 1)
   }
}


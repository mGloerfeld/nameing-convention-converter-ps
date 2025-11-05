function StringTo-Array {
   <#
   .SYNOPSIS
      Splits an input string into word segments using Unicode letter/number detection.

   .DESCRIPTION
      Extracts contiguous sequences of Unicode letters (\p{L}) and numbers (\p{N}).
      Optionally returns plain strings instead of Match objects.

   .PARAMETER Value
      The input string to split.

   .PARAMETER AsValues
      Return an array of plain strings instead of Match objects.

   .EXAMPLE
      "Hello world!" | StringTo-Array -AsValues
      Returns: @("Hello", "world")

   .INPUTS
      System.String

   .OUTPUTS
      System.Text.RegularExpressions.MatchCollection (default) OR System.String[] when -AsValues is used.
   #>

   param(
      [Parameter(Mandatory = $true, ValueFromPipeline)]
      [string]$Value,
      [Parameter()] [switch] $AsValues
   )

   begin {
      $inputBuffer = @()

   }

   process {
      # Eingabewerte sammeln (für Pipeline-Unterstützung)
      $inputBuffer += , $Value
   }

   end {
 
      try {
         $pattern = '[\p{L}\p{N}]+'
         $regex = [regex]$pattern
         $matches = $regex.Matches($inputBuffer)

         if ($AsValues) {
            $matches | ForEach-Object { $_.Value }
         }
         else {
            $matches
         }
      }
      catch {
         Write-Error "Fehler beim Verarbeiten des Strings '$Value': $($_.Exception.Message)"
      }
   }
}
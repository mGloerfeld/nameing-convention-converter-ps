function ConvertTo-Array {
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
      "Hello world!" | ConvertTo-Array -AsValues
      Returns: @("Hello", "world")

   .INPUTS
      System.String

   .OUTPUTS
      System.Text.RegularExpressions.MatchCollection (default) OR System.String[] when -AsValues is used.
   #>

   param(
      [Parameter(Mandatory = $true, ValueFromPipeline)]
      [string]$Value,

      [Parameter()]
      [switch]$AsValues
   )

   begin {
      # Initialize a buffer to collect input from the pipeline
      $inputBuffer = @()
   }

   process {
      # Collect each input value into the buffer (supports pipeline input)
      $inputBuffer += , $Value
   }

   end {
      try {
         # Define a regex pattern to match Unicode letters and numbers
         $pattern = '[\p{L}\p{N}]+'

         # Create a regex object from the pattern
         $regex = [regex]$pattern

         # Apply the regex to the collected input
         $matches = $regex.Matches($inputBuffer)

         # If -AsValues is specified, return only the matched strings
         if ($AsValues) {
            $matches | ForEach-Object { $_.Value }
         }
         else {
            # Otherwise, return the full Match objects
            $matches
         }
      }
      catch {
         # Handle any errors and output a meaningful message
         Write-Error "Error processing string '$Value': $($_.Exception.Message)"
      }
   }
}
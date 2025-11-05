<#
.SYNOPSIS
   Filtert einen übergebenen String.

.DESCRIPTION
   Entfernt alle Sonderzeichen und alle Whitespace-Zeichen außer dem gewöhnlichen ASCII-Leerzeichen (Space U+0020).
   Erlaubt bleiben:
     - Buchstaben (Unicode \p{L})
     - Ziffern (Unicode \p{N})
     - Das normale Space ' '
     - Bindestrich '-'
   Unterstriche '_' werden in Bindestriche '-' umgewandelt.
   Alle anderen Zeichen (Interpunktion, Tabs, Newlines, geschützte Leerzeichen, Emojis etc.) werden entfernt.
   Optional kann mehrfache aufeinanderfolgende Spaces auf einen einzelnen reduziert werden.

.PARAMETER Value
   Der zu filternde Eingabestring.
 

.PARAMETER RemoveSpecialChars
   Entfernt alle Zeichen außer Buchstaben, Ziffern, Leerzeichen und Bindestrich.

.EXAMPLE
   filter-string "Hallo,\tWelt!"  
   # -> "Hallo Welt"

.EXAMPLE
   filter-string "Über‑größe  Test"  
   # -> "Übergröße Test"

.EXAMPLE
   filter-string "Mein_Wert_A  +++  Test" 
   # -> "Mein-Wert-A Test"

.NOTES
   Die Funktion ist pipeline-fähig.
#>
function filter-string {
  
   param (
      [Parameter(Mandatory = $true, ValueFromPipeline)]
      [string]$Value,
 
      [Parameter()]
      [switch]$KeepSpecialChars
   )

   begin {
      $whitespacePattern = '\s+'
      $specialCharsPattern = '[^\p{L}\p{N} \-_]'  # erlaubt: Buchstaben, Ziffern, Leerzeichen, Bindestrich, Unterstrich  
      $inputBuffer = @()
   }

   process {
      # Eingabewerte sammeln (für Pipeline-Unterstützung)
      $inputBuffer += , $Value
   }
  
   end {
      try {
         $clean = $inputBuffer

         # Schritt 1: Alle Whitespaces zu einfachem Leerzeichen
         $clean = $clean -replace $whitespacePattern, ' '

         # Schritt 2: Unterstriche in Bindestriche umwandeln
         $clean = $clean -replace '_', '-'

         # Schritt 3: Sonderzeichen entfernen, falls aktiviert
         if (!$KeepSpecialChars.IsPresent) {
            $clean = $clean -replace $specialCharsPattern, ''
         }

         # Schritt 4: Mehrere Leerzeichen zu einem reduzieren, falls aktiviert
         $clean = [System.Text.RegularExpressions.Regex]::Replace($clean, ' {2,}', ' ')

         # Schritt 5: Trimmen
         $clean = $clean.Trim()

         return $clean
      }
      catch {
         Write-Error "Fehler beim Filtern des Strings: $($_.Exception.Message)"
         return ''
      }
   }
}
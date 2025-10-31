
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
     Unterstriche '_' werden nicht beibehalten, sondern in Bindestriche '-' umgewandelt.
     Alle anderen Zeichen (Interpunktion, Tabs, Newlines, geschützte/geschützte Leerzeichen, Emojis, alle anderen Arten von Bindestrichen usw.) werden entfernt.
     Optional kann mehrfache aufeinanderfolgende Spaces auf einen einzelnen reduziert werden.

.PARAMETER Value
   Der zu filternde Eingabestring.

.PARAMETER CollapseSpaces
   Reduziert mehrere aufeinanderfolgende Leerzeichen auf genau eines.

.EXAMPLE
    filter-string "Hallo,\tWelt!"  # -> "Hallo Welt"

.EXAMPLE
    filter-string "Über‑größe  Test" -CollapseSpaces  # geschützte Bindestriche und doppelte Spaces entfernt -> "Übergröße Test"

.EXAMPLE
    filter-string "Mein_Wert_A  +++  Test" -CollapseSpaces  # Unterstriche werden zu Bindestrichen -> "Mein-Wert-A Test"

.NOTES
   Die Funktion ist pipeline-fähig.
#>
function filter-string {
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "", Justification = "Benutzeranforderung: spezifischer Funktionsname 'filter-string'")]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Zu filternder String')]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        [Parameter()] [switch] $CollapseSpaces
    )

    begin {
        # Regex: Erlaube Buchstaben/Ziffern, Bindestrich oder ein Space, alles andere entfernen (Unterstrich wird später konvertiert).
        # Vorgehen: Erst nicht erlaubte Whitespaces/Sonderzeichen durch '' ersetzen, dann optional Spaces kollabieren und '_' -> '-'.
        $allowedPattern = '[^\p{L}\p{N}_ -]'
        $multiSpacePattern = ' {2,}'
    }

    process {
        try {
            # Schritt 1: Unerlaubte Zeichen entfernen.
            $clean = [System.Text.RegularExpressions.Regex]::Replace($Value, $allowedPattern, '')

            # Schritt 1a: Unterstriche in Bindestriche umwandeln.
            if ($clean.Contains('_')) {
                $clean = $clean -replace '_', '-'
            }

            # Schritt 2: Alle Whitespaces außer normalem Space wurden entfernt; CR/LF/Tab etc. verschwinden hiermit automatisch.

            if ($CollapseSpaces) {
                $clean = [System.Text.RegularExpressions.Regex]::Replace($clean, $multiSpacePattern, ' ')
            }

            # Schritt 3: Führende und nachfolgende Spaces optional trimmen (beibehalten sinnvoll? -> Wir behalten sie NICHT)
            $clean = $clean.Trim()

            return $clean
        }
        catch {
            Write-Error "Fehler beim Filtern des Strings: $($_.Exception.Message)"
            return ''
        }
    }
}
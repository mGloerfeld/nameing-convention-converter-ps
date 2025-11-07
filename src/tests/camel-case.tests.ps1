
BeforeAll {
    # Import business module (explicit path, robust)
    $camelModule = Join-Path (Split-Path $PSScriptRoot -Parent) 'submodules\CamelCase\ConvertTo-CamelCase.psm1'
    if (Test-Path $camelModule) {
        Import-Module -Name $camelModule -Force -ErrorAction Stop
    }
    else {
        Throw "CamelCase Modulpfad nicht gefunden: $camelModule"
    }
}
 
# | Zeichen | Unicode               | Beschreibung          |
# | ------- | --------------------- | ----------------------|
# | U+2002  | En Space              |                       |
# | U+2003  | Em Space              |                       |
# | U+2007  | Figure Space          |                       |
# | U+202F  | Narrow No-Break Space |                       |
# | U+2000  | Punctuation Space     |                       |
# | U+2001  | Em Quad               |                       |
# | U+2009  | Thin Space            |                       |
# | U+200A  | Hair Space            |                       |
# | ​        | U+200B                | Zero Width Space      |
# | ⁠        | U+2060                | Word Joiner           |

Describe 'ConvertTo-CamelCase' {

    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = "Hello world"; expected = 'helloWorld' }
            @{ value = " Hello heros from PowerShell !     ​⁠"; expected = 'helloHerosFromPowerShell' }
            @{ value = "Multiple★§™✓—∆•¶†‡space©®¥€£segments∞≠≡±×÷"; expected = 'multipleSpaceSegments' }
            @{ value = 'SINGLE'; expected = 'single' }
        ) {
            ConvertTo-CamelCase -Value $value -PreserveAcronyms -Invariant | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline of words' {
            'Hello world from pipeline' | ConvertTo-CamelCase | Should -Be 'helloWorldFromPipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            { ConvertTo-CamelCase '' } | Should -Throw
 
        }
        It 'Unicode umlauts kept' {
            'Größe ändern' | ConvertTo-CamelCase | Should -Be 'größeÄndern'
        }
        It 'Empty trimmed content returns empty string' {
            { ConvertTo-CamelCase  ($null -as [string]) } | Should -Throw
        }
    }

    Context 'Invariant and culture' {
        It 'Invariant switch produces lower invariant start' {
            'İstanbul test' | ConvertTo-CamelCase -Invariant | Should -Match '^i'  # Turkish dotted I scenario
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            'Use NASA data' | ConvertTo-CamelCase -PreserveAcronyms | Should -Be 'useNASAData'
        }
        It 'Normalizes acronym when not switched' {
            'Use NASA data' | ConvertTo-CamelCase | Should -Be 'useNasaData'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-CamelCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
        ($cmd.Parameters.Keys) | Should -Contain 'KeepSpecialChars'
    }
}
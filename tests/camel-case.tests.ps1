
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-CamelCase' {

    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world'; expected = 'helloWorld' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'helloHerosFromPowerShell' }
            @{ value = 'Multiple   space   segments'; expected = 'multipleSpaceSegments' }
            @{ value = 'SINGLE'; expected = 'single' }
        ) {
            ConvertTo-CamelCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline of words' {
            'Hello world from pipeline' | ConvertTo-CamelCase | Should -Be 'helloWorldFromPipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-CamelCase | Should -Be ''
        }
        It 'Unicode umlauts kept' {
            ConvertTo-CamelCase 'Größe ändern' | Should -Be 'größeÄndern'
        }
    }

    Context 'Invariant and culture' {
        It 'Invariant switch produces lower invariant start' {
            ConvertTo-CamelCase 'İstanbul test' -Invariant | Should -Match '^i'  # Turkish dotted I scenario
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            ConvertTo-CamelCase 'Use NASA data' -PreserveAcronyms | Should -Be 'useNASAData'
        }
        It 'Normalizes acronym when not switched' {
            ConvertTo-CamelCase 'Use NASA data' | Should -Be 'useNasaData'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-CamelCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
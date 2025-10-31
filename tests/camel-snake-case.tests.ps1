
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1','.psm1')
    
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" +  $file ))


  
}

Describe 'ConvertTo-CamelSnakeCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!';                       expected = 'hello_World' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'hello_Heros_From_PowerShell' }
            @{ value = 'Multiple   space   segments';       expected = 'multiple_Space_Segments' }
            @{ value = 'SINGLE';                            expected = 'single' }
        ) {
            ConvertTo-CamelSnakeCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline of words' {
            'Hello world from pipeline' | ConvertTo-CamelSnakeCase | Should -Be 'hello_World_From_Pipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-CamelSnakeCase | Should -Be ''
        }
        It 'Unicode umlauts kept' {
            ConvertTo-CamelSnakeCase 'Größe ändern' | Should -Be 'größe_Ändern'
        }
    }

    Context 'Invariant and culture' {
        It 'Invariant switch lowercases start invariantly' {
            ConvertTo-CamelSnakeCase 'İstanbul test' -Invariant | Should -Match '^i'
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            ConvertTo-CamelSnakeCase 'Use NASA data' -PreserveAcronyms | Should -Be 'use_NASA_Data'
        }
        It 'Normalizes acronym when not switched' {
            ConvertTo-CamelSnakeCase 'Use NASA data' | Should -Be 'use_Nasa_Data'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-CamelSnakeCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
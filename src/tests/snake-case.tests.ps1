
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-SnakeCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'hello_world' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'hello_heros_from_powershell' }
            @{ value = 'Multiple   space   segments'; expected = 'multiple_space_segments' }
            @{ value = 'SINGLE'; expected = 'single' }
        ) {
            ConvertTo-SnakeCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvertTo-SnakeCase | Should -Be 'hello_world_from_pipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-SnakeCase | Should -Be ''
        }
        It 'Unicode umlauts kept and lowercased' {
            ConvertTo-SnakeCase 'Größe ändern' | Should -Be 'größe_ändern'
        }
        It 'Idempotent for already snake_case input' {
            ConvertTo-SnakeCase 'already_snake_case_value' | Should -Be 'already_snake_case_value'
        }
        It 'Removes punctuation and splits correctly' {
            ConvertTo-SnakeCase 'Hello, world; test!' | Should -Be 'hello_world_test'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch lowercases Turkish İ consistently' {
            ConvertTo-SnakeCase 'İstanbul Test' -Invariant | Should -Match '^i'
        }
    }

    Context 'Numeric & acronym handling' {
        It 'Preserves numbers in output' {
            ConvertTo-SnakeCase 'Version 2 of API 3' | Should -Be 'version_2_of_api_3'
        }
        It 'Converts acronym casing to lower' {
            ConvertTo-SnakeCase 'NASA data set 2025' | Should -Be 'nasa_data_set_2025'
        }
    }

    Context 'Multilingual characters' {
        It 'Keeps Greek and Cyrillic letters' {
            ConvertTo-SnakeCase 'Über Größe – тест Δοκιμή' | Should -Be 'über_größe_тест_δοκιμή'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-SnakeCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }

    It 'Returns a string type' {
        (ConvertTo-SnakeCase 'Hello world') | Should -BeOfType 'System.String'
    }
}
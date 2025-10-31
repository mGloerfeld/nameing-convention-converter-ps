
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1','.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" +  $file ))
}

Describe 'ConvertTo-ScreamingSnakeCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!';                       expected = 'HELLO_WORLD' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLO_HEROS_FROM_POWERSHELL' }
            @{ value = 'Multiple   space   segments';       expected = 'MULTIPLE_SPACE_SEGMENTS' }
            @{ value = 'SINGLE';                            expected = 'SINGLE' }
        ) {
            ConvertTo-ScreamingSnakeCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvertTo-ScreamingSnakeCase | Should -Be 'HELLO_WORLD_FROM_PIPELINE'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-ScreamingSnakeCase | Should -Be ''
        }
        It 'Unicode umlauts uppercased' {
            ConvertTo-ScreamingSnakeCase 'größe ändern' | Should -Be 'GRÖSSE_ÄNDERN'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch uppercases Turkish İ' {
            ConvertTo-ScreamingSnakeCase 'İstanbul test' -Invariant | Should -Match '^İSTANBUL_TEST'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-ScreamingSnakeCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
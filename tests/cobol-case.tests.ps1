
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1','.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" +  $file ))
}

Describe 'ConvertTo-CobolCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!';                       expected = 'HELLO-WORLD' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLO-HEROS-FROM-POWERSHELL' }
            @{ value = 'Multiple   space   segments';       expected = 'MULTIPLE-SPACE-SEGMENTS' }
            @{ value = 'SINGLE';                            expected = 'SINGLE' }
        ) {
            ConvertTo-CobolCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline of words' {
            'Hello world from pipeline' | ConvertTo-CobolCase | Should -Be 'HELLO-WORLD-FROM-PIPELINE'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-CobolCase | Should -Be ''
        }
        It 'Unicode umlauts uppercased' {
            ConvertTo-CobolCase 'Größe ändern' | Should -Be 'GRÖSSE-ÄNDERN'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch handles Turkish İ' {
            ConvertTo-CobolCase 'İstanbul test' -Invariant | Should -Match '^İSTANBUL-TEST'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-CobolCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1','.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" +  $file ))
}

Describe 'ConvertTo-FlatCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!';                       expected = 'helloworld' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'helloherosfrompowershell' }
            @{ value = 'Multiple   space   segments';       expected = 'multiplespacesegments' }
            @{ value = 'SINGLE';                            expected = 'single' }
        ) {
            ConvertTo-FlatCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline of words' {
            'Hello world from pipeline' | ConvertTo-FlatCase | Should -Be 'helloworldfrompipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-FlatCase | Should -Be ''
        }
        It 'Unicode umlauts normalized (kept)' {
            ConvertTo-FlatCase 'Größe ändern' | Should -Be 'größeändern'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch lowercases Turkish İ consistently' {
            ConvertTo-FlatCase 'İstanbul Test' -Invariant | Should -Match '^i'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-FlatCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
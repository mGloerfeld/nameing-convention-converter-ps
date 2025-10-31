
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvetTo-UpperFlatCase (alias) & ConvertTo-UpperFlatCase' {
    Context 'Basic conversions (alias)' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'HELLOWORLD' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLOHEROSFROMPOWERSHELL' }
            @{ value = 'Multiple   space   segments'; expected = 'MULTIPLESPACESEGMENTS' }
            @{ value = 'SINGLE'; expected = 'SINGLE' }
        ) {
            ConvetTo-UpperFlatCase -Value $value | Should -Be $expected
        }
    }

    Context 'Primary function name' {
        It 'Produces same output as alias' {
            ConvertTo-UpperFlatCase 'Hello world!' | Should -Be (ConvetTo-UpperFlatCase 'Hello world!')
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvetTo-UpperFlatCase | Should -Be 'HELLOWORLDFROMPIPELINE'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvetTo-UpperFlatCase | Should -Be ''
        }
        It 'Unicode umlauts uppercased' {
            ConvetTo-UpperFlatCase 'größe ändern' | Should -Be 'GRÖSSEÄNDERN'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch uppercases Turkish İ' {
            ConvetTo-UpperFlatCase 'İstanbul test' -Invariant | Should -Match '^İSTANBULTEST'
        }
    }

    It 'Check function signature (alias)' {
        $cmdAlias = Get-Command ConvetTo-UpperFlatCase
        $cmdAlias | Should -HaveParameter Value -Type String -Mandatory
        ($cmdAlias.Parameters.Keys) | Should -Contain 'Invariant'
    }

    It 'Alias and main command both exist' {
        (Get-Command ConvetTo-UpperFlatCase) | Should -Not -BeNullOrEmpty
        (Get-Command ConvertTo-UpperFlatCase) | Should -Not -BeNullOrEmpty
    }
}
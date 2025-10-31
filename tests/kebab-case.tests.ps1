
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-KebabCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'hello-world' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'hello-heros-from-powershell' }
            @{ value = 'Multiple   space   segments'; expected = 'multiple-space-segments' }
            @{ value = 'SINGLE'; expected = 'single' }
        ) {
            ConvertTo-KebabCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'Hello world from pipeline' | ConvertTo-KebabCase | Should -Be 'hello-world-from-pipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-KebabCase | Should -Be ''
        }
        It 'Unicode umlauts kept and lowercased' {
            ConvertTo-KebabCase 'Größe ändern' | Should -Be 'größe-ändern'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch lowercases Turkish İ consistently' {
            ConvertTo-KebabCase 'İstanbul Test' -Invariant | Should -Match '^i'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-KebabCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
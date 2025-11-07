
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-TrainCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'Hello-World' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'Hello-Heros-From-PowerShell' }
            @{ value = 'Multiple   space   segments'; expected = 'Multiple-Space-Segments' }
            @{ value = 'SINGLE'; expected = 'Single' }
        ) {
            ConvertTo-TrainCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvertTo-TrainCase | Should -Be 'Hello-World-From-Pipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-TrainCase | Should -Be ''
        }
        It 'Unicode umlauts kept capitalized' {
            ConvertTo-TrainCase 'größe ändern' | Should -Be 'Größe-Ändern'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch capitalizes Turkish İstanbul' {
            ConvertTo-TrainCase 'istanbul test' -Invariant | Should -Match '^Istanbul-Test'
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            ConvertTo-TrainCase 'use NASA data' -PreserveAcronyms | Should -Be 'Use-NASA-Data'
        }
        It 'Normalizes acronym when not switched' {
            ConvertTo-TrainCase 'use NASA data' | Should -Be 'Use-Nasa-Data'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-TrainCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
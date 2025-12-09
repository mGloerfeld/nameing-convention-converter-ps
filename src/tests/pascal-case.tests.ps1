
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-PascalCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'HelloWorld' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'HelloHerosFromPowerShell' }
            @{ value = 'Multiple   space   segments'; expected = 'MultipleSpaceSegments' }
            @{ value = 'SINGLE'; expected = 'Single' }
        ) {
            ConvertTo-PascalCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvertTo-PascalCase | Should -Be 'HelloWorldFromPipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-PascalCase | Should -Be ''
        }
        It 'Unicode umlauts kept capitalized' {
            ConvertTo-PascalCase 'größe ändern' | Should -Be 'GrößeÄndern'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch capitalizes Turkish İ' {
            ConvertTo-PascalCase 'istanbul test' -Invariant | Should -Match '^IstanbulTest'
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            ConvertTo-PascalCase 'use NASA data' -PreserveAcronyms | Should -Be 'UseNASAData'
        }
        It 'Normalizes acronym when not switched' {
            ConvertTo-PascalCase 'use NASA data' | Should -Be 'UseNasaData'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-PascalCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
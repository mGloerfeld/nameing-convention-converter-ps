
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
}

Describe 'ConvertTo-PascalSnakeCase' {
    Context 'Basic conversions' {
        It 'Returns <expected> (<value>)' -ForEach @(
            @{ value = 'Hello world!'; expected = 'Hello_World' }
            @{ value = "  Hello	heros from powerShell !  "; expected = 'Hello_Heros_From_PowerShell' }
            @{ value = 'Multiple   space   segments'; expected = 'Multiple_Space_Segments' }
            @{ value = 'SINGLE'; expected = 'Single' }
        ) {
            ConvertTo-PascalSnakeCase -Value $value | Should -Be $expected
        }
    }

    Context 'Pipeline input' {
        It 'Handles pipeline words' {
            'hello world from pipeline' | ConvertTo-PascalSnakeCase | Should -Be 'Hello_World_From_Pipeline'
        }
    }

    Context 'Edge cases' {
        It 'Empty trimmed content returns empty string' {
            ($null -as [string]) | ConvertTo-PascalSnakeCase | Should -Be ''
        }
        It 'Unicode umlauts kept capitalized' {
            ConvertTo-PascalSnakeCase 'größe ändern' | Should -Be 'Größe_Ändern'
        }
    }

    Context 'Invariant switch' {
        It 'Invariant switch capitalizes Turkish İstanbul' {
            ConvertTo-PascalSnakeCase 'istanbul test' -Invariant | Should -Match '^Istanbul_Test'
        }
    }

    Context 'Preserve acronyms' {
        It 'Preserves acronym when switched' {
            ConvertTo-PascalSnakeCase 'use NASA data' -PreserveAcronyms | Should -Be 'Use_NASA_Data'
        }
        It 'Normalizes acronym when not switched' {
            ConvertTo-PascalSnakeCase 'use NASA data' | Should -Be 'Use_Nasa_Data'
        }
    }

    It 'Check function signature' {
        $cmd = Get-Command ConvertTo-PascalSnakeCase
        $cmd | Should -HaveParameter Value -Type String -Mandatory
        ($cmd.Parameters.Keys) | Should -Contain 'PreserveAcronyms'
        ($cmd.Parameters.Keys) | Should -Contain 'Invariant'
    }
}
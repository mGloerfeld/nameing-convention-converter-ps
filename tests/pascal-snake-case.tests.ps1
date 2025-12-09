
BeforeAll { 
    # Import the PascalSnakeCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\PascalSnakeCase\ConvertTo-PascalSnakeCase.psm1")
}

Describe 'Tests for ConvertTo-PascalSnakeCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'Hello_World' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'Hello_Heros_From_Powershell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-PascalSnakeCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-PascalSnakeCase | Should -HaveParameter value -Type String -Mandatory
    }
}
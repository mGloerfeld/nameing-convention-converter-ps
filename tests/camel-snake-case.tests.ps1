
BeforeAll { 
    # Import the CamelSnakeCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\CamelSnakeCase\ConvertTo-CamelSnakeCase.psm1")
}

Describe 'Tests for ConvertTo-CamelSnakeCase' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'hello_World' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'hello_Heros_From_PowerShell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-CamelSnakeCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-CamelSnakeCase | Should -HaveParameter value -Type String -Mandatory
    }
}
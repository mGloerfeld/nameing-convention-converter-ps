
BeforeAll { 
    # Import the CamelCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\CamelCase\ConvertTo-CamelCase.psm1")
}

C:\source\repos\nameing-convention-converter-ps\src\submodules\CamelCase\ConvertTo-CamelCase.psm1

Describe 'Tests for ConvertTo-CamelCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world"; expected = 'helloWorld' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'helloHerosFromPowerShell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-CamelCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-CamelCase | Should -HaveParameter value -Type String -Mandatory
    }
}
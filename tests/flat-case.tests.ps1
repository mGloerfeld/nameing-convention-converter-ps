
BeforeAll { 
    # Import the FlatCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\FlatCase\ConvertTo-FlatCase.psm1")
}

Describe 'Tests for ConvertTo-FlatCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'helloworld' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'helloherosfrompowershell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-FlatCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-FlatCase | Should -HaveParameter value -Type String -Mandatory
    }
}
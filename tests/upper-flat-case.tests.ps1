
BeforeAll { 
    # Import the UpperFlatCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\UpperFlatCase\ConvertTo-UpperFlatCase.psm1")
}

Describe 'Tests for ConvertTo-UpperFlatCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'HELLOWORLD' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLOHEROSFROMPOWERSHELL' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-UpperFlatCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-UpperFlatCase | Should -HaveParameter value -Type String -Mandatory
    }
}

 

BeforeAll { 
    # Import the CobolCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\CobolCase\ConvertTo-CobolCase.psm1")
}

Describe 'Tests for ConvertTo-CobolCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'HELLO-WORLD' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLO-HEROS-FROM-POWERSHELL' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-CobolCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-CobolCase | Should -HaveParameter value -Type String -Mandatory
    }
}
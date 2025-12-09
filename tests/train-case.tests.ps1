
BeforeAll { 
    # Import the TrainCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\TrainCase\ConvertTo-TrainCase.psm1")
}

Describe 'Tests for ConvertTo-TrainCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'Hello-World' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'Hello-Heros-From-Powershell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-TrainCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-TrainCase | Should -HaveParameter value -Type String -Mandatory
    }
}
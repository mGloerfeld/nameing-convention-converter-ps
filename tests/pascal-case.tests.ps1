
BeforeAll { 
    # Import the PascalCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\PascalCase\ConvertTo-PascalCase.psm1")
}

Describe 'Tests for ConvertTo-PascalCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'HelloWorld' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'HelloHerosFromPowerShell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-PascalCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-PascalCase | Should -HaveParameter value -Type String -Mandatory
    }
}
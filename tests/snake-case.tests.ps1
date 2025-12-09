
BeforeAll { 
    # Import the SnakeCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\SnakeCase\ConvertTo-SnakeCase.psm1")
}

Describe 'Tests for ConvertTo-SnakeCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'hello_world' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'hello_heros_from_powershell' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-SnakeCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-SnakeCase | Should -HaveParameter value -Type String -Mandatory
    }
}
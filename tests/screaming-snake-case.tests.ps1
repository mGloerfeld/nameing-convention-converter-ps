
BeforeAll { 
    # Import the ScreamingSnakeCase module
    Import-Module $(Join-Path -Path $(Get-Location) -ChildPath "src\modules\ScreamingSnakeCase\ConvertTo-ScreamingSnakeCase.psm1")
}

Describe 'Tests for ConvertTo-ScreamingSnakeCase.' {

    # $ShouldParams = @{ Throw = $true; ExpectedMessage = "Cannot validate argument on parameter 'OutDir'. OutDir must be a folder path, not a file."; ExceptionType   = ([System.Management.Automation.ParameterBindingException])    }

    It "Returns <expected> (<value>)" -ForEach @(
        @{ value = "Hello world!"; expected = 'HELLO_WORLD' }
        @{ value = "  Hello	heros from powerShell !  "; expected = 'HELLO_HEROS_FROM_POWERSHELL' }
        # @{ value = " 	 ";                              expected = "" }
    ) {
        ConvertTo-ScreamingSnakeCase $value | Should -Be $expected
    }

    It "Check function signatur" {
        Get-Command ConvertTo-ScreamingSnakeCase | Should -HaveParameter value -Type String -Mandatory
    }
}
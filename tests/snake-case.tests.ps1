
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1', '.psm1')
 
    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" + $file ))
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
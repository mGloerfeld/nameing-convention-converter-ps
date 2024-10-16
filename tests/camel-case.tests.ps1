
BeforeAll { 
    # Get correct file name 
    $file = $(Split-Path $PSCommandPath -leaf).Replace('.tests.ps1','.psm1')

    # Import buisness module 
    Import-Module  $(Join-Path -Path $(Get-Location) -ChildPath $("/src/lib/" +  $file ))
}

Describe 'Tests for ConvertTo-CamelCase.' {

    It "Returns <expected> (<value>)" -ForEach @(
        # @{ value = "Hello world!";                       expected = 'helloWorld!' }
        # @{ value = "  Hello	heros from powerShell !  ";  expected = 'helloHerosFromPowerShell!' }
         @{ value = "";                                   expected = "" }
         @{ value = $null;                                expected = $null }
        # @{ value = " 	 ";                              expected = "" }
        ) {
             ConvertTo-CamelCase $value | Should -Be $expected
        }
}
    # It "Converts an ordinary string in camelcase notation and cleans white spaces." {
    #     $cameCase = ConvertTo-CamelCase "  Hello	world here is powershell !  "
    #     $cameCase | Should -Be "HelloWorldHereIsPowershell!"
    # }

    # It "Deal with $null as value." {
    #     $cameCase = ConvertTo-CamelCase $null
    #     $cameCase | Should -Be ""
    # }

    # It "Deal with emtpy string as value." {
    #     $cameCase = ConvertTo-CamelCase ""
    #     $cameCase | Should -Be ""
    # }

    # It "Deal with on space as value." {
    #     $cameCase = ConvertTo-CamelCase " "
    #     $cameCase | Should -Be " "
    # }

    # It "Deal with many whitespaces." {
    #     $cameCase = ConvertTo-CamelCase " 	 "
    #     $cameCase | Should -Be " 	 "
    # }

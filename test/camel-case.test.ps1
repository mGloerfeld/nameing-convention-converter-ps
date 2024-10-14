Install-Module -Name Pester -Force -SkipPublisherCheck
Import-Module "../src/lib/camel-case.psm1" -Force
  
BeforeAll { 
}

# Pester tests
Describe 'Tests for ConvertTo-CamelCase.' {
  
    It "Convert an ordinary string in camelcase notation." {
        $cameCase = ConvertTo-CamelCase "Hello world!"
        $cameCase | Should -Be "HelloWorld!"
    }

    It "Converts an ordinary string in camelcase notation and cleans white spaces." {
        $cameCase = ConvertTo-CamelCase "  Hello	world here is powershell !  "
        $cameCase | Should -Be "HelloWorldHereIsPowershell!"
    }

    It "Deal with $null as value." {
        $cameCase = ConvertTo-CamelCase $null
        $cameCase | Should -Be ""
    }

    It "Deal with emtpy string as value." {
        $cameCase = ConvertTo-CamelCase ""
        $cameCase | Should -Be ""
    }

    It "Deal with on space as value." {
        $cameCase = ConvertTo-CamelCase " "
        $cameCase | Should -Be " "
    }

    It "Deal with many whitespaces." {
        $cameCase = ConvertTo-CamelCase " 	 "
        $cameCase | Should -Be " 	 "
    }
}
Install-Module -Name Pester -Force -SkipPublisherCheck
Import-Module "../src/lib/snake-case.psm1" -Force
  
BeforeAll { 
}

# Pester tests
Describe 'Tests for ConvertTo-KebabCase.' {
  
    It "Convert an ordinary string in kebabcase notation." {
        $cameCase = ConvertTo-KebabCase "Hello world!"
        $cameCase | Should -Be "Hello-world!"
    }

    It "Converts an ordinary string in kebabcase notation and cleans white spaces." {
        $cameCase = ConvertTo-KebabCase "   Hello	world here is powershell!  "
        $cameCase | Should -Be "hello-world-here-is-powershell!"
    }

    It "Deal with $null as value." {
        $cameCase = ConvertTo-KebabCase $null
        $cameCase | Should -Be ""
    }

    It "Deal with emtpy string as value." {
        $cameCase = ConvertTo-KebabCase ""
        $cameCase | Should -Be ""
    }

    It "Deal with on space as value." {
        $cameCase = ConvertTo-KebabCase " "
        $cameCase | Should -Be " "
    }

    It "Deal with many whitespaces." {
        $cameCase = ConvertTo-KebabCase " 	 "
        $cameCase | Should -Be " 	 "
    }
}
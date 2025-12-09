
# Test suite for ConvertTo-CamelCase function
# This file contains comprehensive tests for the camelCase conversion functionality
# including edge cases, parameter validation, pipeline support, and performance tests

BeforeAll { 
    # Import the CamelCase module - adjust path since we're in src\tests
    $modulePath = Join-Path -Path (Get-Location) -ChildPath "src\modules\CamelCase\ConvertTo-CamelCase.psm1"
    Write-Host "Attempting to import module from: $modulePath"
    Import-Module $modulePath -Force
}
 
AfterAll {
    # Clean up imported modules to avoid conflicts with other tests
    Remove-Module ConvertTo-CamelCase -ErrorAction SilentlyContinue
}

Describe 'ConvertTo-CamelCase' {

    # Tests basic camelCase conversion scenarios with different input formats
    Context 'Basic conversion tests' {
        It "Converts '<TestInput>' to '<Expected>'" -ForEach @(
            @{ TestInput = "Hello world"; Expected = 'helloWorld' }  # Simple two-word conversion
            @{ TestInput = "test string"; Expected = 'testString' }  # Lowercase input
            @{ TestInput = "my_variable_name"; Expected = 'myVariableName' }  # Underscore-separated words
            @{ TestInput = "kebab-case-string"; Expected = 'kebabCaseString' }  # Hyphen-separated words
            @{ TestInput = "PascalCaseString"; Expected = 'pascalCaseString' }  # PascalCase to camelCase conversion
            @{ TestInput = "SCREAMING_SNAKE_CASE"; Expected = 'screamingSnakeCase' }  # All caps with underscores
            @{ TestInput = "  Hello	heroes from powerShell !  "; Expected = 'helloHeroesFromPowerShell' }  # Mixed whitespace and special characters
        ) {
            $result = ConvertTo-CamelCase $TestInput
            $result | Should -Be $Expected
        }
    }

    # Tests edge cases and boundary conditions that could cause issues
    Context 'Edge cases' {
        It "Handles empty string" {
            # Empty string input should return empty string
            $result = ConvertTo-CamelCase ""
            $result | Should -Be ""
        }

        It "Handles whitespace-only string" {
            # String with only whitespace should return empty string
            $result = ConvertTo-CamelCase "   "
            $result | Should -Be ""
        }

        It "Handles single word" {
            # Single word should remain lowercase (camelCase first word rule)
            $result = ConvertTo-CamelCase "word"
            $result | Should -Be "word"
        }

        It "Handles single character" {
            # Single character should be converted to lowercase
            $result = ConvertTo-CamelCase "A"
            $result | Should -Be "a"
        }

        It "Handles numbers in string" {
            # Numbers should be preserved in their original positions
            $result = ConvertTo-CamelCase "test123_string456"
            $result | Should -Be "test123String456"
        }

        It "Handles mixed case with numbers" {
            # Complex case mixing uppercase letters and numbers
            $result = ConvertTo-CamelCase "HTML5Parser"
            $result | Should -Be "hTML5Parser"
        }
    }

    # Tests handling of various special characters and word separators
    Context 'Special characters and separators' {
        It "Removes special characters '<TestInput>'" -ForEach @(
            @{ TestInput = "hello@world#test!"; Expected = 'helloWorldTest' }  # Various punctuation marks
            @{ TestInput = "test-with-dashes"; Expected = 'testWithDashes' }  # Hyphen/dash separators
            @{ TestInput = "test_with_underscores"; Expected = 'testWithUnderscores' }  # Underscore separators
            @{ TestInput = "test.with.dots"; Expected = 'testWithDots' }  # Period/dot separators
            @{ TestInput = "test with spaces"; Expected = 'testWithSpaces' }  # Space separators
            @{ TestInput = "test	with	tabs"; Expected = 'testWithTabs' }  # Tab character separators
        ) {
            $result = ConvertTo-CamelCase $TestInput
            $result | Should -Be $Expected
        }
    }

    # Tests PowerShell pipeline functionality and multiple input processing
    Context 'Pipeline support' {
        It "Supports pipeline input" {
            # Function should accept input from pipeline
            $result = "hello world" | ConvertTo-CamelCase
            $result | Should -Be "helloWorld"
        }

        It "Processes multiple pipeline inputs" {
            # Function should process each pipeline input separately
            $inputs = @("hello world", "test string", "another example")
            $results = $inputs | ConvertTo-CamelCase
            $results | Should -HaveCount 3
            $results[0] | Should -Be "helloWorld"
            $results[1] | Should -Be "testString" 
            $results[2] | Should -Be "anotherExample"
        }
    }

  
    # Tests the PreserveAcronyms switch parameter behavior
    Context 'PreserveAcronyms parameter' {
        It "Preserves acronyms when switch is used" {
            # With -PreserveAcronyms, uppercase words should stay uppercase
            $result = ConvertTo-CamelCase "API response handler" -PreserveAcronyms
            $result | Should -Be "APIResponseHandler"
        }

        It "Does not preserve acronyms by default" {
            # Without -PreserveAcronyms, all words follow standard camelCase rules
            $result = ConvertTo-CamelCase "API response handler"
            $result | Should -Be "apiResponseHandler"
        }

        It "Preserves multiple acronyms" {
            # Multiple acronyms in sequence should all be preserved
            $result = ConvertTo-CamelCase "XML HTTP API request" -PreserveAcronyms
            $result | Should -Be "XMLHTTPAPIRequest"
        }
    }

    # Tests the Invariant culture parameter for consistent cross-locale behavior
    Context 'Invariant culture parameter' {
        It "Uses invariant culture when specified" {
            # Invariant culture ensures consistent results regardless of system locale
            $result = ConvertTo-CamelCase "Müller König" -Invariant
            $result | Should -Be "müllerKönig"
        }

        It "Handles Turkish i correctly with invariant culture" {
            # Turkish locale has special 'i' handling - invariant avoids locale-specific issues
            $result = ConvertTo-CamelCase "Istanbul Turkey" -Invariant
            $result | Should -Be "istanbulTurkey"
        }
    }

    # Tests Unicode and international character support
    Context 'Unicode and international characters' {
        It "Handles unicode characters '<TestInput>'" -ForEach @(
            @{ TestInput = "héllo wörld"; Expected = 'hélloWörld' }  # Latin characters with diacritics
            @{ TestInput = "café français"; Expected = 'caféFrançais' }  # French accented characters
            @{ TestInput = "москва россия"; Expected = 'москваРоссия' }  # Cyrillic script (Russian)
            @{ TestInput = "东京 日本"; Expected = '东京日本' }  # CJK characters (Chinese/Japanese)
        ) {
            $result = ConvertTo-CamelCase $TestInput
            $result | Should -Be $Expected
        }
    }

    # Tests performance with large inputs and stress conditions
    Context 'Performance and stress testing' {
        It "Handles very long strings" {
            # Test performance with very large input string (4000+ characters)
            $longString = "word " * 1000  # Creates 1000 repetitions of "word "
            $result = ConvertTo-CamelCase $longString.Trim()
            $result | Should -Match "^word(Word)*$"  # Should follow camelCase pattern
            $result.Length | Should -Be 4000  # word + 999 * Word = 4 + 999*4 = 4000
        }

        It "Handles strings with many separators" {
            # Test with complex mix of separators and special characters
            $separatorString = "a-b_c.d e!f@g#h$i%j"  # Multiple separator types
            $result = ConvertTo-CamelCase $separatorString
            $result | Should -Be "aBCdEfghj"  # Only alphanumeric characters preserved
        }
    }
}
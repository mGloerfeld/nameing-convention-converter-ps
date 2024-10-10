# ps-string-converter

PowerShell modules to convert strings.

# Template

<#
.Synopsis
Short description
.DESCRIPTION
Long description
.EXAMPLE
ConvertTo-KebabCase("Unified Canadian Aboriginal Syllabics")
.EXAMPLE
Another example of how to use this cmdlet
.INPUTS
Any string like 'Unified Canadian Aboriginal Syllabics'
.OUTPUTS
An converted string like 'unified-canadian-aboriginal-syllabics'
.NOTES
Removes all leading, closing and double whitespaces.
.COMPONENT
The component this cmdlet belongs to
.ROLE
The role this cmdlet belongs to
.FUNCTIONALITY
The functionality that best describes this cmdlet
#>

# Set-ExecutionPolicy

Policy automatically resets if you close the ps window.
Policy is only active in this ps instance.
´Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process´

# Import Modules

´Get-Module´
´Import-Module "./string-converter.psd1" -Force´

´Remove-Module ps-string-converter´

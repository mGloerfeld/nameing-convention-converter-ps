<#
.Synopsis
   Converts text into TrainCase. 
.DESCRIPTION
   Converts any text into TrainCase notation. Unnecessary spaces are filtered out.
.EXAMPLE
   ConvertTo-TrainCase "Hello world!" 
.INPUTS
   Any string like 'Hello world!'.
.OUTPUTS
   An converted string like 'HelloWorld!'
.NOTES
   Removes all leading, closing and double whitespaces.
#>
function ConvertTo-TrainCase {
    param (
        [string]$Text
    )

    if ([string]::IsNullOrEmpty($Text) -or [string]::IsNullOrWhiteSpace($Text)) {
        return $Text
    }

    # Remove all leading, colseing and multiple whitespaces in text. 
    $Text = $Text -replace '(\s+)',' '
    $Parts = $Text.Trim().ToLower().Split(" ");

    return [string]::Join("-", $Parts);      
}

Export-ModuleMember -Function ConvertTo-TrainCase
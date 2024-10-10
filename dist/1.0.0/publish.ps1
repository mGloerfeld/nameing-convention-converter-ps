$parameters = @{
    Path        = 'C:\sources\ps-string-converter\src\string-converter.psd1'
 
    LicenseUri  = 'http://contoso.com/license'
    Tag         = "PSMODULE",'string converter','convert', 'kebab-case'
    ReleaseNote = 'Updated the ActiveDirectory DSC Resources to support adding users.'
}
Publish-Module @parameters

 
[CmdletBinding()]
param (
    $ARMTTKModuleDirectory = "D:\temp\arm-ttk-latest",
    $ARMTTKResultsDirectory = "D:\temp",
    $TemplatesToScanDirectory = ".\templates"
)

Import-Module "$ARMTTKModuleDirectory\arm-ttk\arm-ttk.psd1"
Get-Module
$resultsDir = New-Item -Path $ARMTTKResultsDirectory -Name 'arm-ttk-results' -ItemType Directory -Force
$templatesHaveErrors = $false
$templateFiles = Get-ChildItem -Path "$TemplatesToScanDirectory" -Filter *.json
foreach ($file in $templateFiles) {
    $testOutput = Test-AzTemplate -TemplatePath $templateFiles[0].FullName
    $testOutput | Select-Object -Property Name,Group,Passed,Errors | Format-Table -Wrap | Out-File -FilePath "$($resultsDir.FullName)\$($file.name)_armttk_results.txt"
    if($testOutput.Errors) { $templatesHaveErrors = $true }
}
if ($templatesHaveErrors) {
    Write-Warning 'Some templates failed the ARM-TTK check'
} else {
    Write-Host "##vso[task.setvariable variable=result.best.practice]$true"
}

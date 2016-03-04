[cmdletbinding()]
param(
    
)

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | %{ Write-Verbose "$_ = $($PSBoundParameters[$_])" }

Write-Verbose "Importing modules"
Import-Module -DisableNameChecking "$PSScriptRoot/vsts-extension-shared.psm1"

Write-Debug "Setting output variable '$($packageOptions.OutputVariable)' to '$($output.packaged)'"
Write-Host "##vso[task.setvariable variable=$($packageOptions.OutputVariable);]$($output.packaged)"

Write-Host "##vso[task.complete result=Succeeded;]DONE"
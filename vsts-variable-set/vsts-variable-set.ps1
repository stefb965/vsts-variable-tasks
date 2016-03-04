[cmdletbinding()]
param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$true)]
    $VariableName,
    [Parameter(Mandatory=$false)]
    $Value = ""
)

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | %{ Write-Verbose "$_ = $($PSBoundParameters[$_])" }

Write-Output "Setting '$Variable' to '$newValue'."
Write-Host "##vso[task.setvariable variable=$($Variable);]$newValue"

Write-Host "##vso[task.complete result=Succeeded;]DONE"
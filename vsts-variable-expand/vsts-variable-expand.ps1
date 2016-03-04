[cmdletbinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string] $VariableNames,
    [ValidateSet("true", "false", "1", "0")]
    [string] $MaxDepth = 5
)

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | %{ Write-Verbose "$_ = $($PSBoundParameters[$_])" }

Write-Verbose "Importing modules"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

function Expand-Variable{
    param
    (
        [string] $Variable
    )
    begin
    {
        $value = Get-TaskVariable $distributedTaskContext $Variable
    }   
    process
    {
        $newValue = $value
        do 
        {
            $value = [Microsoft.TeamFoundation.DistributedTask.Agent.Common.ContextExtensions]::ExpandVariables($distributedTaskContext, $newValue)
        } while ($value -ne $newValue)
    }
    end
    {
        return $value
    }
}

$Variables = ($VariableNames -split "`r?`n|;|,")

for ($i = 0; $i -lt $MaxDepth; $i++)
{
    foreach ($Variable in $Variables)
    {
        $Variable = $Variable.Trim()
        if ($Variable -ne "")
        {
            $currentValue = Get-TaskVariable $distributedTaskContext $Variable
            $newValue = Expand-Variable $Vaiable

            if ($currentValue -cne $newValue)
            {
                Write-Output "Setting '$Variable' to '$newValue'."
                Write-Host "##vso[task.setvariable variable=$($Variable);]$newValue"
            }
        }
    }
}

Write-Host "##vso[task.complete result=Succeeded;]DONE"
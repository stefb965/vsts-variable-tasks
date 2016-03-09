[cmdletbinding()]
param(
    [Parameter(Mandatory=$true)]
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
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Variable
    )
    begin
    {
        $value = Get-TaskVariable $distributedTaskContext $Variable
    }   
    process
    {
        do 
        {
            $newValue = $value
            $value = [Microsoft.TeamFoundation.DistributedTask.Agent.Common.ContextExtensions]::ExpandVariables($distributedTaskContext, $newValue)
        } 
        while ($value -ne $newValue)
    }
    end
    {
        return $value
    }
}

function Get-VariableNames{
    param
    (
        [switch] $safe = $false
    )
    begin
    {
        Write-Debug "Entering: Get-Variables"
        $variableService = $distributedTaskContext.GetType().GetMethod("GetService").MakeGenericMethod([Microsoft.TeamFoundation.DistributedTask.Agent.Interfaces.IVariableService]).Invoke($distributedTaskContext)
        $dictionary = @{}

    }
    process
    {
        if ($safe.IsPresent)
        {
            $variables = $variableService.MergeSafeVariables($dictionary)
        }
        else
        {
            $variables = $variableService.MergeVariables($dictionary)
        }
    }
    end
    {
        Write-Debug "Leaving: Get-Variables"
        return $variables.Keys
    }
}

function Expand-Variables
{
    param
    {
        [array] $variables = @()
    }
    begin
    {
        Write-Debug "Entering: Expand-Variables"
    }
    process
    {
        for ($i = 0; $i -lt $MaxDepth; $i++)
        {
            foreach ($Variable in $Variables)
            {
                $Variable = $Variable.Trim()

                if ($Variable -eq "*")
                {
                    Write-Output "Expanding all variables."
                    Expand-Variables -variables (Get-Variables -safe)
                }
                elseif ($Variable -ne "")
                {
                    $currentValue = Get-TaskVariable $distributedTaskContext $Variable
                    $newValue = Expand-Variable $Variable

                    if ($currentValue -cne $newValue)
                    {
                        Write-Output "Setting '$Variable' to '$newValue'."
                        Write-Host "##vso[task.setvariable variable=$($Variable);]$newValue"
                    }
                }
            }
        }
    }
    end
    {
        Write-Debug "Leaving: Expand-Variables"
    }
}

$Variables = ($VariableNames -split "`r?`n|;|,")

Expand-Variables $Variables

Write-Host "##vso[task.complete result=Succeeded;]DONE"
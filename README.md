# Description

This Extension contains a slowly growing collection of tasks that help you manipulate and (soon) validate the values of build variables.

# Expand Variables
Have you ever wanted to use the value from one variable in another variable? Unfortunately, that's not possible with the standard Variables screen.

| Variable             | Value                                                        |
| -------------------- | ------------------------------------------------------------ |
| Build.DropLocation   | \\\\share\drops\$(Build.DefinitionName)\$(Build.BuildNumber) |

Will simply send the literal text to the tasks in your workflow.

Add the Expand Variable(s) task to the top of your build steps and it will take care of the expansion for you. It even supportes multiple levels of nested variables!

> **Expand variable: 'Build.DropLocation'**
> 
> * *Variablename(s)*: `Build.DropLocation`

Will expand your drop location variable to:

| Variable             | Value                                                        |
| -------------------- | ------------------------------------------------------------ |
| Build.DropLocation   | \\\\share\drops\My Definition\My Definition_1.2.123          |

And to make your life easier it now supports simply expanding all your variables!

> **Expand variable: '*'**
> 
> * *Variablename(s)*: `*`


# Set Variable
Have you ever wanted to change the value of a variable between multiple build steps? Simply add the **Set Variable** task to your workflow and tell it which value you want to assign to which variable.

You can use the value of other build variables to setup the value.

> **Set: 'Build.DropLocation' to `\\share\drops\$(Build.DefinitionName)\$(Build.BuildNumber)'** 
> 
> * *Variablename*: `Build.DropLocation`
> * *Value*: `\\share\drops\$(Build.DefinitionName)\$(Build.BuildNumber)`

# Preview Notice

These tasks are currently in preview.

# Documentation

Please check the [Wiki](https://github.com/jessehouwing/vsts-variable-tasks/wiki).
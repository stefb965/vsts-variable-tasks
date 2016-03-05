# Description

Have you ever wanted to nest Variables? Unfortunately, that's not possible with the standard Variables screen and requires a bit of fairy dust.

| Variable             | Value                                                      |
| -------------------- | ---------------------------------------------------------- |
| Build.DropLocation   | \\share\drops\$(Build.DefinitionName)\$(Build.BuildNumber) |

Will simply send the literal text to the tasks in your workflow.

In comes the fairy dust :).

Just add the Expand variable task to your workflow and tell it to expand your variable:

> **Expand variable: 'Build.DropLocation'**
> 
> * *Variablename(s)*: `Build.DropLocation`

Supported operations:

 * Set variable
 * Expand variable

# Preview Notice

These tasks are currently in preview.

# Documentation

Please check the [Wiki](https://github.com/jessehouwing/vsts-variable-tasks/wiki).
# Description

Have you ever wanted to nest Variables? Unfortunately, that's not possible with the standard Variables screen.

| **Variable**         | **Value**                                                  |
| -------------------- | ---------------------------------------------------------- |
| Build.DropLocation   | \\share\drops\$(Build.DefinitionName)\$(Build.BuildNumber) |


But now you can!

Just add the Expand variable task to your workflow and tell it to expand your variable:

**Expand variable: 'Build.DropLocation'**

 * *Variablename(s)*: `Build.DropLocation`

Supported operations:

 * Set variable
 * Expand variable

# Preview Notice

These tasks are currently in preview.

# Documentation

Please check the [Wiki](https://github.com/jessehouwing/vsts-variable-tasks/wiki).
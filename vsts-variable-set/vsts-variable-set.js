"use strict";
const tl = require("vsts-task-lib/task");
const variable = tl.getInput("VariableName", true);
const value = tl.getInput("Value");
if (variable.search(/^Build[._]BuildNumber$/i) > 0) {
    tl.command("build.updatebuildnumber", null, value);
    tl._writeLine(`Set buildnumber to: ${value}`);
    tl.setResult(tl.TaskResult.Succeeded, `Set buildnumber to: ${value}`);
}
else {
    tl.setVariable(variable, value);
    tl._writeLine(`Set ${variable} to: ${value}`);
    tl.setResult(tl.TaskResult.Succeeded, `Set ${variable} to: ${value}`);
}

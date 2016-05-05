///<reference path="./typings/main.d.ts" />
import tl = require("vsts-task-lib/task");


const option = tl.getInput("option", true);
const variable = tl.getInput("variableName", true);
let output = "";

switch (option) {
    case "searchReplace":
        output = searchAndReplace();
        break;

    case "encodeString":
        output = encodeString();
        break;

    case "decodeString":
        output = decodeString();
        break;
}

if (variable.search(/^Build[._]BuildNumber$/i) > 0) {
    tl.command("build.updatebuildnumber", null, output);
    tl._writeLine(`Set buildnumber to: ${output}`);
    tl.setResult(tl.TaskResult.Succeeded, `Set buildnumber to: ${output}`);
} else {
    tl.setVariable(variable, output);
    tl._writeLine(`Set ${variable} to: ${output}`);
    tl.setResult(tl.TaskResult.Succeeded, `Set ${variable} to: ${output}`);
}



function searchAndReplace(): string {
    const method = tl.getInput("searchReplace", true);
    const value = tl.getInput("value");
    const search = tl.getInput("searchValue");
    const replacement = tl.getInput("replacementValue");

    if (method === "regex") {
        const regexOptions = tl.getInput("regexOptions", false);
        const searchExpression = new RegExp(search, regexOptions);

        return value.replace(searchExpression, replacement);
    } else {
        return value.replace(search, replacement);
    }
}

function encodeString(): string {
    const method = tl.getInput("encodeString", true);
    const value = tl.getInput("value");

    switch (method) {
        case "uri":
            return encodeURI(value);
        case "base64":
            const buffer = new Buffer(value);
            return buffer.toString("base64");
        case "slashes":
            return JSON.stringify(value).slice(1, -1);
    }

    return "NOT IMPLEMENTED";
}

function decodeString(): string {
    const method = tl.getInput("encodeString", true);
    const value = tl.getInput("value");

    switch (method) {
        case "uri":
            return decodeURI(value);
        case "base64":
            const buffer = new Buffer(value, "base64");
            return buffer.toString();
        case "slashes":
            return JSON.parse(`"${value}"`).toString();
    }

    return "NOT IMPLEMENTED";
}
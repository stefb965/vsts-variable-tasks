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

    if (method === "basic") {
        return value.replace(search, replacement);
    } else {
        const regexOptions = tl.getInput("regexOptions", false);
        let searchExpression: RegExp;

        if (regexOptions) {
            searchExpression = new RegExp(search, regexOptions);
        } else {
            searchExpression = new RegExp(search);
        }

        if (method === "match") {
            const result = value.match(searchExpression);
            if (!result || result.length === 0) {
                tl.warning("Found no matches");
                return "";
            } else {
                if (result.length > 1) {
                    tl.warning("Found multiple matches, setting the first");
                }
                return result[0];
            }
        }
        if (method === "regex") {
            return value.replace(searchExpression, replacement);
        }
    }
    return value;
}

function encodeString(): string {
    const method = tl.getInput("encodeString", true);
    const value = tl.getInput("value");

    switch (method) {
        case "uri":
            return encodeURI(value);
        case "uriComponent":
            return encodeURIComponent(value);
        case "base64":
            const buffer = new Buffer(value);
            return buffer.toString("base64");
        case "slashes":
            return addSlashes(value);
    }

    return "NOT IMPLEMENTED";
}

function decodeString(): string {
    const method = tl.getInput("encodeString", true);
    const value = tl.getInput("value");

    switch (method) {
        case "uri":
            return decodeURI(value);
        case "uriComponent":
            return decodeURIComponent(value);
        case "base64":
            const buffer = new Buffer(value, "base64");
            return buffer.toString();
        case "slashes":
            return stripSlashes(value);
    }

    return "NOT IMPLEMENTED";
}

function stripSlashes(str : string) : string {
    return str.replace(/\\(.?)/g, (s, n1) => {
        switch (n1) {
            case "\\":
                return "\\";
            case "0":
                return "\u0000";
            case "":
                return "";
            default:
                return n1;
        }
    });
}

function addSlashes(str : string) : string {
    return str.replace(/[\\"']/g, "\\$&")
              .replace(/\u0000/g, "\\0");
}
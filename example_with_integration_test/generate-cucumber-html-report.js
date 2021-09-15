var fs = require("fs");
var reporter = require('cucumber-html-reporter');
const reportRootDir = 'integration_test/gherkin/reports/'
const jsonReportPath = `${reportRootDir}json_report.json`;
const htmlReportPath = `${reportRootDir}cucumber_report.html`;
const reportFile = fs.readFileSync(`${reportRootDir}integration_response_data.json`);
const jsonReport = JSON.parse(JSON.parse(reportFile).gherkin_reports)[0];
fs.writeFileSync(jsonReportPath, JSON.stringify(jsonReport));

var options = {
    theme: 'bootstrap',
    jsonFile: jsonReportPath,
    output: htmlReportPath,
    reportSuiteAsScenarios: true,
    launchReport: false,
};

reporter.generate(options);
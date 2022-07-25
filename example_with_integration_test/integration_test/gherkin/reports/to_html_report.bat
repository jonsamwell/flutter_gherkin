call npm init -y

call npm install --save-dev cucumber-html-reporter

node -e "require('cucumber-html-reporter').generate({theme: 'bootstrap', jsonFile: '{REPORT_NAME}.json', output: 'report.html', reportSuiteAsScenarios: true, launchReport: false});"
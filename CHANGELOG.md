## [1.1.6-rc.2] - 18/12/2019
* Fixed analyzer issue

## [1.1.6-rc.1] - 18/12/2019
* FlutterDriverReporter - Update to fix the breaking change in the way flutter_driver logs messages (https://github.com/flutter/flutter/pull/45945 - currently in the dev and above branches) 

## [1.1.5+1] - 18/12/2019
* Migrated example to AndroidX

## [1.1.5] - 05/12/2019
* Updated to latest Gherkin library (see https://github.com/jonsamwell/dart_gherkin/blob/master/CHANGELOG.md#115---05122019)

## [1.1.4] - 27/09/2019
* Added configuration parameter `flutterBuildTimeout` to allow setting the app build wait timeout.  Slower machines may need longer to build and start the Flutter app under test.
* Now logging the flutter driver command used when the configuration setting `logFlutterProcessOutput` is true
* Verbose logging for the underlying Flutter process can be enabled via the configuration setting `verboseFlutterProcessLogs`
* Added `waitUntil` helper method to the `FlutterDriverUtils` class that waits until a certain provided condition is true

## [1.1.3] - 25/09/2019
* Added Flutter driver reporter - the Flutter Driver logs all messages (even non-error ones) to stderr and will cause the process to be marked as failed by a CI server becuase of this.  So this reporter redirects the messages to the appropiate output stream (stdout / stderr).
* FlutterWorld - added missing `super.dispose()` call

## [1.1.2] - 22/09/2019
* Fixed lint warnings

## [1.1.1] - 22/09/2019
* Updated to latest Gherkin library
* Ensured Gradle build warnings do not output to `stderr` and cause tests runs to fail just because of build warnings

## [1.1.0] - 20/09/2019
* Updated to latest Gherkin lib which implements langauges - features can now be written in different languages / dialects! See https://cucumber.io/docs/gherkin/reference/#overview for supported dialects.
* Ensured the hook to take a screenshot `AttachScreenshotOnFailedStepHook` works for steps that error or timeout as well as fail.
* Fix missing await in `FlutterDriverUtils` when getting text of a widget.

## [1.0.12] - 18/09/2019
* Relaxed package constraints to accomodate older versions of Flutter

## [1.0.11] - 18/09/2019
* Fixed package constraints so older versions of Flutter are compatible

## [1.0.10] - 18/09/2019
* {string} placeholder variables can now contain whitespace characters [\n\r\t ]
* Tags are now inherited by children if requried (see https://cucumber.io/docs/cucumber/api/#tag-inheritance)
* JSON reporter now adheres to the cucumber json reporter spec, I had to update the way tags and exceptions are handled

## [1.0.9] - 03/09/2019
* Added ability to define the working directory for the app to run the tests against

## [1.0.8] - 25/08/2019
* Updated to latest dart_gherkin lib which now has support for 'Scenerio Outline' and 'Example' blocks

## [1.0.7] - 23/08/2019
* Updated to latest dart_gherkin lib

## [1.0.6] - 21/08/2019
* Added support to restart app during test ```world.restartApp();```

## [1.0.5] - 11/07/2019
* Updated to latest dart_gherkin lib

## [1.0.4] - 21/06/2019
* Fixed analysis suggestions

## [1.0.3] - 21/06/2019
* Added ability to include a hook (see `AttachScreenshotOnFailedStepHook`) that takes a screenshot after a failed step. If using the json reporter it include the screenshot in the report that can then be used to generate a HTML report.
* Updated to latest dart_gherkin lib

## [1.0.2] - 05/06/2019
* Fixed analysis suggestions

## [1.0.1] - 05/06/2019
* Fixed dependency conflicts

## [1.0.0] - 05/06/2019
* Huge speed improvement when running tests by hot reloading (which clears the state) rather than restarting the app
* Added flag to determine if the application should be built prior to running tests
* Merged PR which allows for build flavor and device id to be specified thanks to @iqbalmineraltown for the PR
* Updated to latest v1 dart_gherkin lib

## [0.0.14] - 23/04/2019
* Updated to rely on the abstracted Gherkin library 'https://github.com/jonsamwell/dart_gherkin' which now includes a JsonReporter
* Updated docs

## [0.0.13] - 07/03/2019
* StepStartedMessage created which includes a table parameter that reporters receive when step is started thanks to @Holloweye for the PR

## [0.0.12] - 06/02/2019
* Fixed package analysis error

## [0.0.11] - 06/02/2019

* Fixes issue with table parameters not being given to step
* Added news hook that is called after the world for a scenario is created

## [0.0.10] - 01/11/2018

* Ensured summary reporter reports failure reason
* Ensured well known Flutter step actions timeout before their parent step

## [0.0.9] - 01/11/2018

* Updated example of custom parameters and how to use them

## [0.0.8] - 01/11/2018

* Updated feature file glob pattern in readme examples

## [0.0.7] - 01/11/2018

* Added a test run summary reporter `TestRunSummaryReporter` that logs an aggregated summary of the test run once all tests have run.
* Fixed up glob issue in example project

## [0.0.6] - 31/10/2018

* Added quick start steps in the example app readme

## [0.0.5] - 29/10/2018

* Sorted out formatting of pre-defined steps

## [0.0.4] - 29/10/2018

* Added more tests around `FlutterTestConfiguration` to ensure pre-defined steps are always added

## [0.0.3] - 29/10/2018

* Added more pre-defined flutter step definitions
* Added more Flutter driver util methods to abstract common functionality like entering text into a control and tapping a button.

## [0.0.2] - 29/10/2018

* Fixed up dependencies

## [0.0.1] - 29/10/2018

* Initial working release

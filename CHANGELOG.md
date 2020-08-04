## [1.1.8+6] - 05/08/2020
- Upgraded to latest Gherkin library version which fixes issues with non-alpha-numeric characters in multiline strings and comments https://github.com/jonsamwell/dart_gherkin/issues/14 https://github.com/jonsamwell/dart_gherkin/issues/15 https://github.com/jonsamwell/dart_gherkin/issues/16


## [1.1.8+5] - 03/08/2020
* Ensure all well known steps are exposed (Thanks to @tshedor for the PR!)

## [1.1.8+4] - 26/07/2020
* Fixes #76

## [1.1.8+3] - 19/07/2020
* Updated Gherkin library version to allow for function step implementations; updated docs to match.
* Add steps `SiblingContainsText`, `SwipeOnKey`, `SwipeOnText`, `TapTextWithinWidget`, `TapWidgetOfType`, `TapWidgetOfTypeWithin`, `TapWidgetWithText`, `TextExists`, `TextExistsWithin`, `WaitUntilKeyExists`, and `WaitUntilTypeExists`. Thanks to @tshedor for the PR!

## [1.1.8+2] - 11/05/2020

* Fixed issue where the connection attempt of Flutter driver would not retry before throwing a connection error.  This was causing an error on some machines trying to connect to an Android emulator (x86 & x86_64) that runs the googleapis (see https://github.com/flutter/flutter/issues/42433)
* Added a before `onBeforeFlutterDriverConnect` and after `onAfterFlutterDriverConnect` Flutter driver connection method property to the test configuration `FlutterTestConfiguration` to enable custom logic before and after a driver connection attempt.
* Updated Gherkin library version to sort issue with JSON reporter throwing error when an exception is logged before any steps have run

## [1.1.8+1] - 09/05/2020

* Updated Gherkin library version to sort issue with JSON reporter throwing error when an exception is logged before any feature have run

## [1.1.8] - 08/05/2020

* Updated library to work with the new way the Flutter stable branch manages logging for Flutter driver
* Added the ability to test against an already running app; enabling you to debug a running application while it has tests executed against it.  Setting the configuration property `runningAppProtocolEndpointUri` to the service protocol endpoint (found in stdout when an app has `--verbose` logging turned on) will ensure that the existing app is connected to rather than starting a new instance of the app.  NOTE: ensure the app you are trying to connect to calls `enableFlutterDriverExtension()` when it starts up otherwise the Flutter Driver will not be able to connect to it.
* **BREAKING CHANGE** Fixed spelling mistake of `targetAppWorkingDirectory` & `flutterDriverMaxConnectionAttempts` in `FlutterTestConfiguration`
* **BREAKING CHANGE** reverse order of `driver` and `finder` in `FlutterDriverUtils#isPresent` . This makes this method's arguments more consistent with all other instance methods in the class by including `driver` first.
* `expect` the presence of `ThenExpectWidgetToBePresent` . If the widget was not present, the method would simply timeout and not report an error for the step.

## [1.1.7+6] - 04/03/2020

* Updated to latest Gherkin library (see https://github.com/jonsamwell/dart_gherkin/blob/master/CHANGELOG.md#117---04032020) - this includes a breaking change to the `Hook` interface that will need to be updated if any of the `Scenario` level methods are implemented
* Ensured the well known step `I tap the ".." button` scroll the element into view first

## [1.1.7+5] - 03/02/2020

* Updated to latest Gherkin library (see https://github.com/jonsamwell/dart_gherkin/blob/master/CHANGELOG.md#1164---03022020)

## [1.1.7+4] - 31/01/2020

* Update check to determine if any devices are connected to run tests against
* When the flag `verboseFlutterProcessLogs` was true Flutter driver was preemptively connecting to the app when it was not ready

## [1.1.7+3] - 08/01/2020

* Added retry logic to the Flutter driver connect call to handle the seemingly random connection failures
* Ensured `AttachScreenshotOnFailedStepHook` cannot throw an unhandled exception causing the test run to stop
* Added new well known step `When I tap the back button` which finds and taps the default page back button
* Added a new well known step `Then I expect the widget 'notification' to be present within 2 seconds` which expects a widget with a given key to be present within n seconds
* Updated Gherkin library version

## [1.1.7+2] - 07/01/2020

* Increased the Flutter driver reconnection delay to try and overcome some driver to app connection issues on slower machines

## [1.1.7+1] - 07/01/2020

* Ensured when the Flutter driver is closed it cannot throw an unhandled exception causing the test run the stop
* Updated Gherkin library version

## [1.1.7] - 06/01/2020

* `WhenFillFieldStep` Ensure widget is scrolled into view before setting it's value
* Fixed lint warnings

## [1.1.5+2] - 19/12/2019

* When more than one connected device is present the device to run against was unknown causing a failure, now a message is logged saying the --device-id argument needs to be set
* Fixed issue where deprecated api warnings when build a flutter app were written to the stderr stream

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

* Added Flutter driver reporter - the Flutter Driver logs all messages (even non-error ones) to stderr and will cause the process to be marked as failed by a CI server because of this.  So this reporter redirects the messages to the appropriate output stream (stdout / stderr).
* FlutterWorld - added missing `super.dispose()` call

## [1.1.2] - 22/09/2019

* Fixed lint warnings

## [1.1.1] - 22/09/2019

* Updated to latest Gherkin library
* Ensured Gradle build warnings do not output to `stderr` and cause tests runs to fail just because of build warnings

## [1.1.0] - 20/09/2019

* Updated to latest Gherkin lib which implements languages - features can now be written in different languages / dialects! See https://cucumber.io/docs/gherkin/reference/#overview for supported dialects.
* Ensured the hook to take a screenshot `AttachScreenshotOnFailedStepHook` works for steps that error or timeout as well as fail.
* Fix missing await in `FlutterDriverUtils` when getting text of a widget.

## [1.0.12] - 18/09/2019

* Relaxed package constraints to accommodate older versions of Flutter

## [1.0.11] - 18/09/2019

* Fixed package constraints so older versions of Flutter are compatible

## [1.0.10] - 18/09/2019

* {string} placeholder variables can now contain whitespace characters [\n\r\t ]
* Tags are now inherited by children if required (see https://cucumber.io/docs/cucumber/api/#tag-inheritance)
* JSON reporter now adheres to the cucumber json reporter spec, I had to update the way tags and exceptions are handled

## [1.0.9] - 03/09/2019

* Added ability to define the working directory for the app to run the tests against

## [1.0.8] - 25/08/2019

* Updated to latest dart_gherkin lib which now has support for 'Scenario Outline' and 'Example' blocks

## [1.0.7] - 23/08/2019

* Updated to latest dart_gherkin lib

## [1.0.6] - 21/08/2019

* Added support to restart app during test `` `world.restartApp();` ``

## [1.0.5] - 11/07/2019

* Updated to latest dart_gherkin lib

## [1.0.4] - 21/06/2019

* Fixed analysis suggestions

## [1.0.3] - 21/06/2019

* Added ability to include a hook (see `AttachScreenshotOnFailedStepHook` ) that takes a screenshot after a failed step. If using the json reporter it include the screenshot in the report that can then be used to generate a HTML report.
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

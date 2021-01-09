## [1.2.0] - 07/01/2021
# BREAKING CHANGES

In order to progress this library and add support for the new integration_test package various things have had to be changed to enable this will still supporting Flutter Driver.  The big of which is removing Flutter Driver instance from the `FlutterWorld` instance in favour of an adapter approach whereby driving of the app (whether that is via `flutter_driver` or `WidgetTester`) becomes agnostic see `https://github.com/jonsamwell/flutter_gherkin/blob/f1fb2d4a632362629f5d1a196a0c055f858ad1d7/lib/src/flutter/adapters/app_driver_adapter.dart`.

- `FlutterDriverUtils` has been removed, use `world.appDriver` instead.  You can still access the raw driver if needed via `world.appDriver.rawDriver`
- If you are using a custom world object and still want to use Flutter Driver it will need to extend `FlutterDriverWorld` instead of `FlutterWorld`

The change to use the `integration_test` package is a fundamentally different approach.  Where using the `flutter_driver` implementation your app is launch in a different process and then controlled by remote RPC calls from the flutter driver again in a different process.  Using the new `integration_test` package your tests surround your app and become the app themselves.  This removes the need for RPC communication from an external process into the app as well as giving you access to the internal state of your app.  This is an altogether better approach, one that is quicker, more maintainable scalable to device testing labs.  However, it brings with it, its own set of challenges when trying to make this library work with it.  Traditionally this library has evaluated the Gherkin feature files at run time, then used that evaluation to invoke actions against the app under test.  However, as the tests need to surround the app in the `integration_test` view of the world the Gherkin tests need to be generated at development time so they can be complied in to a test app.  Much like `json_serializable` creates classes that are able to work with json data.

### Steps to get going

1. Add the following `dev_dependencies` to your app's `pubspec.yaml` file
  - integration_test
  - build_runner
  - flutter_gherkin
2. Add the following `build.yaml` to the root of your project. This file allows the dart code generator to target files outside of your application's `lib` folder
  ```
  targets:
  $default:
    sources:
      - lib/**
      - pubspec.*
      - $package$
      # Allows the code generator to target files outside of the lib folder
      - integration_test/**.dart
  ```
3. Add the following file (and folder) `example_with_integration_test\test_driver\integration_test_driver.dart`.  This file is the entry point to run your tests.  See `https://flutter.dev/docs/testing/integration-tests` for more information.
   ```
    import 'package:integration_test/integration_test_driver.dart'
        as integration_test_driver;

    Future<void> main() {
      // The Gherkin report data send back to this runner by the app after
      // the tests have run will be saved to this directory
      integration_test_driver.testOutputsDirectory = 'integration_test/gherkin_reports';

      return integration_test_driver.integrationDriver(
        timeout: Duration(minutes: 90),
      );
    }
   ```
4. Create a folder call `integration_test` this will eventually contain all your Gherkin feature files and the generated test files.
5. Add the following file (and folder) `integration_test\feature\counter.feature` with the following below contents.  This is a basic feature file that will be transform in to a test file that can run a test against the sample app.
    ```
    Feature: Counter

    Scenario: User can increment the counter
      Given I expect the "counter" to be "0"
      When I tap the "increment" button
      Then I expect the "counter" to be "1"
    ```
6. Add the following file (and folder) `integration_test\gherkin_suite_test.dart`.  Notice the attribute `@GherkinTestSuite()` this indicates to the code generator to create a partial file for this file with the generated Gherkin tests in `part 'gherkin_suite_test.g.dart';`.  Don't worry about the initial errors as this will disappear when the tests are generated.
```dart
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

// The application under test.
import 'package:example_with_integration_test/main.dart' as app;

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite()
void main() {
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([])
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),,
        JsonReporter(
          writeReport: (_, __) => Future<void>.value(),
        ),
      ],
    app.main,
  );
}
```
7. We now need to generate the test by running the builder command from the command line in the root of your project.  Much like `json_serializable` this will create a `.g.dart` part file that will contain the Gherkin tests in code format which are able to via using the `integration_test` package.
    ```
    flutter pub run build_runner build
    ```
8. The errors in the `integration_test\gherkin_suite_test.dart` file should have not gone away and it you look in `integration_test\gherkin_suite_test.g.dart` you will see the coded version of the Gherkin tests described in the feature file `integration_test\feature\counter.feature`.
9. We can now run the test using the below command from the root of your project.
    ```
    flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/gherkin_suite_test.dart
    ```
10. You can debug the tests by adding a breakpoint to line 12 in `integration_test\gherkin_suite_test.dart` and adding the below to your `.vscode\launch.json` file:
```json
{
  "name": "Debug integration_test",
  "program": "test_driver/integration_test_driver.dart",
  "cwd": "example_with_integration_test/",
  "request": "launch",
  "type": "dart",
  "args": [
    "--target=integration_test/gherkin_suite_test.dart",
  ],
}
```
11. Custom world need to extend `FlutterWorld` note `FlutterDriverWorld`.
12. If you change any of the feature files you will need to regenerate the tests using the below command
  ```
  flutter pub run build_runner build
  ```


## [1.1.9] - 24/11/2020
* Fixes #93 & #92 - Error waiting for no transient callbacks from Flutter driver
* Added option to leave Flutter app under test running when the tests finish see `keepAppRunningAfterTests` configuration property
* Added the ability to have multiple example blocks with tags per scenario outline

## [1.1.8+9] - 20/09/2020

* Fixes #84 - pre-defined `present within N seconds` is limited by system timeout (thanks @doubleo2)
* Added build mode to enable profile build and performance profiling (thanks @lsuhov)
* Updated to latest dart_gherkin library which fixes access to the default step timeout see #81


## [1.1.8+8] - 11/08/2020

* Added well know steps and a driver helper method to long press a widget (fixed issue and documentation)

``` 
When I long press "controlKey" button

When I long press "controlKey" icon for 1500 milliseconds
```

## [1.1.8+7] - 11/08/2020

* Added well know steps and a driver helper method to long press a widget 

``` 
When I long press "controlKey" button

When I long press "controlKey" icon for 1500 milliseconds
```

## [1.1.8+6] - 05/08/2020

* Upgraded to latest Gherkin library version which fixes issues with non-alpha-numeric characters in multiline strings and comments https://github.com/jonsamwell/dart_gherkin/issues/14 https://github.com/jonsamwell/dart_gherkin/issues/15 https://github.com/jonsamwell/dart_gherkin/issues/16

## [1.1.8+5] - 03/08/2020

* Ensure all well known steps are exposed (Thanks to @tshedor for the PR!)

## [1.1.8+4] - 26/07/2020

* Fixes #76

## [1.1.8+3] - 19/07/2020

* Updated Gherkin library version to allow for function step implementations; updated docs to match.
* Add steps `SiblingContainsText` , `SwipeOnKey` , `SwipeOnText` , `TapTextWithinWidget` , `TapWidgetOfType` , `TapWidgetOfTypeWithin` , `TapWidgetWithText` , `TextExists` , `TextExistsWithin` , `WaitUntilKeyExists` , and `WaitUntilTypeExists` . Thanks to @tshedor for the PR!

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

* Added support to restart app during test ` ` ` world.restartApp(); ` ` `

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

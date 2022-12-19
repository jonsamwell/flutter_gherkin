<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

# flutter_gherkin

A fully featured Gherkin parser and test runner.  Works with Flutter and Dart 2.

This implementation of the Gherkin tries to follow as closely as possible other implementations of Gherkin and specifically [Cucumber](https://docs.cucumber.io/cucumber/) in it's various forms.

Available as a Dart package https://pub.dartlang.org/packages/flutter_gherkin

```dart
  # Comment
  Feature: Addition

    @tag
    Scenario: 1 + 0
      Given I start with 1
      When I add 0
      Then I end up with 1

    Scenario: 1 + 1
      Given I start with 1
      When I add 1
      Then I end up with 2
```

## integration_test package support

NOTE: This library now favours using the `integration_test` package and code generation over `flutter_driver` and runtime interpretation and as such the `flutter_driver` implementations will eventually be deprecated.


### Steps to get going

1. Add the following `dev_dependencies` to your app's `pubspec.yaml` file
  - integration_test
  - build_runner
  - flutter_gherkin
2. Add the following `build.yaml` to the root of your project. This file allows the dart code generator to target files outside of your application's `lib` folder
```yaml
targets:
  $default:
    sources:
      - lib/**
      - pubspec.*
      - $package$
      # Allows the code generator to target files outside of the lib folder
      - integration_test/**.dart
```
3. Add the following file (and folder) `\test_driver\integration_test_driver.dart`.  This file is the entry point to run your tests.
If you want ot use the flutter test command approach, you will not need this file (and be unused when it is created).
See `https://flutter.dev/docs/testing/integration-tests` for more information.
```dart
import 'package:integration_test/integration_test_driver.dart' as integration_test_driver;

Future<void> main() {
  // The Gherkin report data send back to this runner by the app after
  // the tests have run will be saved to this directory
  integration_test_driver.testOutputsDirectory = 'integration_test/gherkin/reports';

  return integration_test_driver.integrationDriver(
    timeout: Duration(minutes: 90),
  );
}
```
4. Create a folder call `integration_test` this will eventually contain all your Gherkin feature files and the generated test files.
5. Add the following file (and folder) `integration_test\features\counter.feature` with the following below contents.  This is a basic feature file that will be transform in to a test file that can run a test against the sample app.
```
Feature: Counter

Scenario: User can increment the counter
  Given I expect the "counter" to be "0"
  When I tap the "increment" button
  Then I expect the "counter" to be "1"
```
6. Add the following file (and folder) `integration_test\gherkin_suite_test.dart`.  Notice the attribute `@GherkinTestSuite()` this indicates to the code generator to create a partial file for this file with the generated Gherkin tests in `part 'gherkin_suite_test.g.dart';`.  Don't worry about the initial errors as this will disappear when the tests are generated.
```dart
import 'package:flutter_gherkin/flutter_gherkin.dart'; // notice new import name
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

// The application under test.
import 'package:example_with_integration_test/main.dart' as app;

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite(
    featurePaths: <String>['integration_test/features/**.feature'],
    executionOrder: ExecutionOrder.sequential)
Future<void> main() async {
  
  var configuration = FlutterTestConfiguration(
    reporters: [
      TestRunSummaryReporter(),
      JsonReporter(
        writeReport: (_, __) => Future<void>.value(),
      ),
    ],
  );

  await executeTestSuite(
      configuration: configuration,
      appMainFunction: (World world) async => app.main(),
  );
}
```
7. We now need to generate the test by running the builder command from the command line in the root of your project.  Much like `json_serializable` this will create a `.g.dart` part file that will contain the Gherkin tests in code format which are able to via using the `integration_test` package.
```
flutter pub run build_runner build
```
8. The errors in the `integration_test\gherkin_suite_test.dart` file should have not gone away and it you look in `integration_test\gherkin_suite_test.g.dart` you will see the coded version of the Gherkin tests described in the feature file `integration_test\features\counter.feature`.
9. We can now run the test using the below command from the root of your project.
```
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/gherkin_suite_test.dart
```

If you do not want to use the flutter drive command, but the flutter test command you need to change some aspects.
It is REQUIRED that in `integration_test\gherkin_suite_test.dart` the executeTestSuite is awaited.
And then you can run your test command:
```
flutter test integration_test/gherkin_suite_test.dart
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
12. If you change any of the feature files you will need to re-generate the tests using the below command
```
# you might need to run the clean command first if you have just changed feature files
flutter pub run build_runner clean

flutter pub run build_runner build
```
## Note - Package upgrades
This package will soon have a major release to support null-safety and then another major release to support running tests using the integration_test package and `WidgetTester`.  We will still maintain compatibility for running tests using flutter_driver and do our best so that switching over to using the integration_test package will be seamless.  For this to happen we have had to refactor large chunks of the code base so unfortunately there will be some unavoidable breaking changes.

## Table of Contents

<!-- TOC -->

* [Getting Started](#getting-started)
  + [Configuration](#configuration)
    - [features](#features)
    - [tagExpression](#tagexpression)
    - [order](#order)
    - [stepDefinitions](#stepdefinitions)
    - [defaultLanguage](#defaultLanguage)
    - [customStepParameterDefinitions](#customstepparameterdefinitions)
    - [hooks](#hooks)
    - [reporters](#reporters)
    - [createWorld](#createworld)
  + [Flutter specific configuration options](#flutter-specific-configuration-options)
    - [restartAppBetweenScenarios](#restartappbetweenscenarios)
    - [build](#build)
    - [buildFlavor](#buildFlavor)
    - [buildMode](#buildMode)
    - [dartDefineArgs](#dartDefineArgs)
    - [flutterBuildTimeout](#flutterBuildTimeout)
    - [logFlutterProcessOutput](#logFlutterProcessOutput)
    - [targetDeviceId](#targetDeviceId)
    - [targetAppPath](#targetapppath)
    - [runningAppProtocolEndpointUri](#runningAppProtocolEndpointUri)
    - [onBeforeFlutterDriverConnect](#onBeforeFlutterDriverConnect)
    - [onAfterFlutterDriverConnect](#onAfterFlutterDriverConnect)
    - [flutterDriverMaxConnectionAttempts](#flutterDriverMaxConnectionAttempts)
    - [flutterDriverReconnectionDelay](#flutterDriverReconnectionDelay)
* [Features Files](#features-files)
  + [Steps Definitions](#steps-definitions)
    - [Given](#given)
    - [Then](#then)
    - [Expects Assertions](#expects-assertions)
    - [Step Timeout](#step-timeout)
    - [Multiline Strings](#multiline-strings)
    - [Data tables](#data-tables)
    - [Well known step parameters](#well-known-step-parameters)
    - [Pluralization](#pluralization)
    - [Custom Parameters](#custom-parameters)
    - [World Context (per test scenario shared state)](#world-context-per-test-scenario-shared-state)
    - [Assertions](#assertions)
  + [Tags](#tags)
  + [Languages](#languages)
* [Hooks](#hooks)
* [Attachments](#attachments)
  + [Screenshot on step failure](#screenshot)
* [Reporting](#reporting)
* [Flutter](#flutter)
  + [Restarting the app before each test](#restarting-the-app-before-each-test)
    - [Flutter World](#flutter-world)
  + [Pre-defined Steps](#pre-defined-steps)
    - [Flutter Driver Utilities](#flutter-driver-utilities)
  + [Debugging](#debugging)
    - [Debugging the app under test](#debugging-the-app-under-test)

<!-- /TOC -->

## Getting Started

See <https://docs.cucumber.io/gherkin/> for information on the Gherkin syntax and Behaviour Driven Development (BDD).  

See [example readme](example/README.md) for a quick start guide to running the example features and app.

The first step is to create a version of your app that has flutter driver enabled so that it can be automated.  A good guide how to do this is show [here](https://flutter.io/cookbook/testing/integration-test-introduction/#4-instrument-the-app).  However in short, create a folder called `test_driver` and within that create a file called `app.dart` and paste in the below code.

``` dart
import '../lib/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  runApp(MyApp());
}
```

All this code does is enable the Flutter driver extension which is required to be able to automate the app and then runs your application.

To get started with BDD in Flutter the first step is to write a feature file and a test scenario within that.

First create a folder called `test_driver` (this is inline with the current integration test as we will need to use the Flutter driver to automate the app).  Within the folder create a folder called `features` , then create a file called `counter.feature` .

``` dart
Feature: Counter
  The counter should be incremented when the button is pressed.

  Scenario: Counter increases when the button is pressed
    Given I expect the "counter" to be "0"
    When I tap the "increment" button 10 times
    Then I expect the "counter" to be "10"
```

Now we have created a scenario we need to implement the steps within.  Steps are just classes that extends from the base step definition class or any of its variations `Given` , `Then` , `When` , `And` , `But` .

Granted the example is a little contrived but is serves to illustrate the process.

This library has a couple of built in step definitions for convenience.  The first step uses the built in step, however the second step `When I tap the "increment" button 10 times` is a custom step and has to be implemented.  To implement a step we have to create a simple step definition class.

``` dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapButtonNTimesStep() {
  return when2<String, int, FlutterWorld>(
    'I tap the {string} button {int} times',
    (key, count, context) async {
      final locator = find.byValueKey(key);
      for (var i = 0; i < count; i += 1) {
        await FlutterDriverUtils.tap(context.world.driver, locator);
      }
    },
  );
}
```

As you can see the `when2` method is invoked specifying two input parameters.  The third type `FlutterWorld` is a special world context object that allow access from the context object to the Flutter driver that allows you to interact with your app.  If you did not need a custom world object or strongly typed parameters you can omit the type arguments completely.

The input parameters are retrieved via the pattern regex from well know parameter types `{string}` and `{int}` [explained below](#well-known-step-parameters).  They are just special syntax to indicate you are expecting a string and an integer at those points in the step text.  Therefore, when the step to execute is `When I tap the "increment" button 10 times` the parameters "increment" and 10 will be passed into the step as the correct types.  Note that in the pattern you can use any regex capture group to indicate any input parameter.  For example the regex ` `  ` RegExp(r"When I tap the {string} (button|icon) {int} times") `  ` ` indicates 3 parameters and would match to either of the below step text.

``` dart
When I tap the "increment" button 10 times    // passes 3 parameters "increment", "button" & 10
When I tap the "plus" icon 2 times       // passes 3 parameters "plus", "icon" & 2
```

It is worth noting that this library *does not* rely on mirrors (reflection) for many reasons but most prominently for ease of maintenance and to fall inline with the principles of Flutter not allowing reflection.  All in all this make for a much easier to understand and maintain code base as well as much easier debugging for the user.  The downside is that we have to be slightly more explicit by providing instances of custom code such as step definition, hook, reporters and custom parameters.

Now that we have a testable app, a feature file and a custom step definition we need to create a class that will call this library and actually run the tests.  Create a file called `app_test.dart` and put the below code in.

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..hooks = [HookExample()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..customStepParameterDefinitions = [ColourParameter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  return GherkinRunner().execute(config);
}
```

This code simple creates a configuration object and calls this library which will then promptly parse your feature files and run the tests.  The configuration file is important and explained in further detail below.  However, all that is happening is a `RegExp` is provide which specifies the path to one or more feature files, it sets the reporters to the `ProgressReporter` report which prints the result of scenarios and steps to the standard output (console).  The `TestRunSummaryReporter` prints a summary of the run once all tests have been executed.  Finally it specifies the path to the testable app created above `test_driver/app.dart` .  This is important as it instructions the library which app to run the tests against.

Finally to actually run the tests run the below on the command line:

``` bash
dart test_driver/app_test.dart
```

To debug tests see [Debugging](#debugging).

*Note*: You might need to ensure dart is accessible by adding it to your path variable.

### Configuration

The configuration is an important piece of the puzzle in this library as it specifies not only what to run but classes to run against in the form of steps, hooks and reporters.  Unlike other implementation this library does not rely on reflection so need to be explicitly told classes to use.

The parameters below can be specified in your configuration file:

#### features

*Required*

An iterable of `Pattern` that specify the location(s) of `*.feature` files to run.  See <https://api.dart.dev/stable/2.12.4/dart-core/Pattern-class.html>

#### tagExpression

Defaults to `null` .

An infix boolean expression which defines the features and scenarios to run based of their tags. See [Tags](#tags).

#### order

Defaults to `ExecutionOrder.random`
The order by which scenarios will be run. Running an a random order may highlight any inter-test dependencies that should be fixed.  Running with `ExecutionOrder.sorted` processes the feature files in `filename` order.

#### stepDefinitions

Defaults to `Iterable<StepDefinitionBase>`
Place instances of any custom step definition classes `Given` , `Then` , `When` , `And` , `But` that match to any custom steps defined in your feature files.

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [StdoutReporter()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}
```

#### defaultLanguage

Defaults to `en`
This specifies the default language the feature files are written in.  See https://cucumber.io/docs/gherkin/reference/#overview for supported languages.

Note that this can be overridden in the feature itself by the use of a language block.

``` 
# language: de
Funktionalität: Calculator
  Tests the addition of two numbers

  Szenariogrundriss: Add two numbers
    Gegeben sei the numbers <number_one> and <number_two>
    Wenn they are added
    Dann the expected result is <result>

    Beispiele:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |
```

``` 
# language: fr
Fonctionnalité: Counter
  The counter should be incremented when the button is pressed.

  @smoke
  Scénario: Counter increases when the button is pressed
    Etant donné que I pick the colour red
    Et I expect the "counter" to be "0"
    Quand I tap the "increment" button 10 times
    Alors I expect the "counter" to be "10"
```

#### customStepParameterDefinitions

Defaults to `CustomParameter<dynamic>` .

Place instances of any custom step parameters that you have defined.  These will be matched up to steps when scenarios are run and their result passed to the executable step.  See [Custom Parameters](#custom-parameters).

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';
import 'steps/colour_parameter.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [StdoutReporter()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..customStepParameterDefinitions = [ColourParameter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
```

#### hooks

Hooks are custom bits of code that can be run at certain points with the test run such as before or after a scenario.  Place instances of any custom `Hook` class instance in this collection.  They will then be run at the defined points with the test run.

#### attachments

Attachment are pieces of data you can attach to a running scenario.  This could be simple bits of textual data or even image like a screenshot.  These attachments can then be used by reporters to provide more contextual information.  For example when a step fails some contextual information could be attached to the scenario which is then used by a reporter to display why the step failed.

Attachments would typically be attached via a `Hook` for example `onAfterStep` .

``` dart
import 'package:gherkin/gherkin.dart';

class AttachScreenshotOnFailedStepHook extends Hook {
  /// Run after a step has executed
  @override
  Future<void> onAfterStep(World world, String step, StepResult stepResult) async {
    if (stepResult.result == StepExecutionResult.fail) {
      world.attach('Some info.','text/plain');
      world.attach('{"some", "JSON"}}', 'application/json');
    }
  }
}
```

##### screenshot

To take a screenshot on a step failing you can used the pre-defined hook `AttachScreenshotOnFailedStepHook` and include it in the hook configuration of the tests config.  This hook will take a screenshot and add it as an attachment to the scenario.  If the `JsonReporter` is being used the screenshot will be embedded in the report which can be used to generate a HTML report which will ultimately display the screenshot under the failed step.

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ]
    ..hooks = [HookExample(), AttachScreenshotOnFailedStepHook()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..customStepParameterDefinitions = [ColourParameter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
```

#### reporters

Reporters are classes that are able to report on the status of the test run.  This could be a simple as merely logging scenario result to the console.  There are a number of built-in reporter:

* `StdoutReporter` : Logs all messages from the test run to the standard output (console).
* `ProgressReporter` : Logs the progress of the test run marking each step with a scenario as either passed, skipped or failed.
* `JsonReporter` - creates a JSON file with the results of the test run which can then be used by 'https://www.npmjs.com/package/cucumber-html-reporter.' to create a HTML report.  You can pass in the file path of the json file to be created.

You should provide at least one reporter in the configuration otherwise it'll be hard to know what is going on.

*Note*: Feel free to PR new reporters!

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [StdoutReporter()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..customStepParameterDefinitions = [ColourParameter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
```

#### createWorld

Defaults to `null` .

While it is not recommended so share state between steps within the same scenario we all in fact live in the real world and thus at time may need to share certain information such as login credentials etc for future steps to use.  The world context object is created once per scenario and then destroyed at the end of each scenario.  This configuration property allows you to specify a custom `World` class to create which can then be accessed in your step classes.

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [StdoutReporter()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..createWorld = (TestConfiguration config) async => await createMyWorldInstance(config)
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
    
  return GherkinRunner().execute(config);
}
```

#### logFlutterProcessOutput

Defaults to `false`
If `true` the output from the flutter process is logged to the stdout / stderr streams.  Useful when debugging app build or start failures

#### flutterBuildTimeout

Defaults to `90 seconds`
Specifies the period of time to wait for the Flutter build to complete and the app to be installed and in a state to be tested.  Slower machines may need longer than the default 90 seconds to complete this process.

#### onBeforeFlutterDriverConnect

An async method that is called before an attempt by Flutter driver to connect to the app under test

#### onAfterFlutterDriverConnect

An async method that is called after a successful attempt by Flutter driver to connect to the app under test

#### flutterDriverMaxConnectionAttempts

Defaults to `3`
Specifies the number of Flutter driver connection attempts to a running app before the test is aborted

#### flutterDriverReconnectionDelay

Defaults to `2 seconds`
Specifies the amount of time to wait after a failed Flutter driver connection attempt to the running app

### Flutter specific configuration options

The `FlutterTestConfiguration` will automatically create some default Flutter options such as well know step definitions, the Flutter world context object which provides access to a Flutter driver instance as well as the ability to restart you application under test between scenarios.  Most of the time you should use this configuration object if you are testing Flutter applications.

#### restartAppBetweenScenarios

Defaults to `true` .

To avoid tests starting on an app changed by a previous test it is suggested that the Flutter application under test be restarted between each scenario.  While this will increase the execution time slightly it will limit tests failing because they run against an app changed by a previous test.  Note in more complex application it may also be necessary to use the `AfterScenario` hook to reset the application to a base state a test can run on.  Logging out for example if restarting an application will present a lock screen etc.  This now performs a hot reload of the application which resets the state and drastically reduces the time to run the tests.

#### targetAppPath

Defaults to `lib/test_driver/app.dart`
This should point to the *testable* application that enables the Flutter driver extensions and thus is able to be automated.  This application wil be started when the test run is started and restarted if the `restartAppBetweenScenarios` configuration property is set to true.

#### build

Defaults to `true`
This optional argument lets you specify if the target application should be built prior to running the first test.  This defaults to `true`

#### keepAppRunningAfterTests

Defaults to `false`
This optional argument will keep the Flutter application running when done testing.  This defaults to `false`

#### buildFlavor

Defaults to empty string

This optional argument lets you specify which flutter flavor you want to test against.  Flutter's flavor has similar concept with `Android Build Variants` or `iOS Scheme Configuration` . This [flavoring flutter](https://flutter.dev/docs/deployment/flavors) documentation has complete guide on both flutter and android/ios side.

#### buildMode

Defaults to `BuildMode.Debug`

This optional argument lets you specify which build mode you prefer while compiling your app. Flutter Gherkin supports `--debug` and `--profile` modes. Check [Flutter's build modes](https://flutter.dev/docs/testing/build-modes) documentation for more details.

#### dartDefineArgs

Defaults to `[]`

`--dart-define` args to pass into the build parameters. Include the name and value for each. For example, `--dart-define=MY_VAR="true"` becomes `['MY_VAR="true"']`

#### targetDeviceId

Defaults to empty string

This optional argument lets you specify device target id as `flutter run --device-id` command. To show list of connected devices, run `flutter devices` . If you only have one device connected, no need to provide this argument.

#### runningAppProtocolEndpointUri

An observatory url that the test runner can connect to instead of creating a new running instance of the target application
The url takes the form of `http://127.0.0.1:51540/EM72VtRsUV0=/` and usually printed to stdout in the form `Connecting to service protocol: http://127.0.0.1:51540/EM72VtRsUV0=/`
You will have to add the `--verbose` flag to the command to start your flutter app to see this output and ensure `enableFlutterDriverExtension()` is called by the running app

## Features Files

### Steps Definitions

Step definitions are the coded representation of a textual step in a feature file.  Each step starts with either `Given` , `Then` , `When` , `And` or `But` .  It is worth noting that all steps are actually the same but semantically different.  The keyword is not taken into account when matching a step.  Therefore the two below steps are actually treated the same and will result in the same step definition being invoked.

Note: Step definitions (in this implementation) are allowed up to 5 input parameters.  If you find yourself needing more than this you might want to consider making your step more isolated or using a `Table` parameter.

``` dart
Given there are 6 kangaroos
Then there are 6 kangaroos
```

However, the domain language you choose will influence what keyword works best in each context.  For more information <https://docs.cucumber.io/gherkin/reference/#steps>.

#### Given

`Given` steps are used to describe the initial state of a system.  The execution of a `Given` step will usually put the system into well defined state.

To implement a `Given` step you can inherit from the ` `  ` Given `  ` ` class.

``` dart
Given Bob has logged in
```

Would be implemented like so:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenWellKnownUserIsLoggedIn() {
  return given1(
    RegExp(r'(Bob|Mary|Emma|Jon) has logged in'),
    (wellKnownUsername, context) async {
      // implement your code
    },
  );
}
```

If you need to have more than one Given in a block it is often best to use the additional keywords `And` or `But` .

``` dart
Given Bob has logged in
And opened the dashboard
```

#### Then

`Then` steps are used to describe an expected outcome, or result.  They would typically have an assertion in which can pass or fail.

``` dart
Then I expect 10 apples
```

Would be implemented like so:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric ThenExpectAppleCount() {
  return then1(
    'I expect {int} apple(s)',
    (count, context) async {
      // example code
      final actualCount = await _getActualCount();
      context.expectMatch(actualCount, count);
    },
  );
}
```

#### Expects Assertions

**Caveat**: The `expect` library currently only works within the library's own `test` function blocks; so using it with a `Then` step will cause an error.  Therefore, the `expectMatch` or `expectA` or `this.expect` or `context.expect` methods have been added which mimic the underlying functionality of `except` in that they assert that the give is true.  The `Matcher` within Dart's test library still work and can be used as expected.

#### Step Timeout

By default a step will timeout if it exceed the `defaultTimeout` parameter in the configuration file.  In some cases you want have a step that is longer or shorter running and in the case you can optionally proved a custom timeout to that step.  To do this pass in a `Duration` object in the step's call to `super` .

For example, the below sets the step's timeout to 10 seconds.

``` dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapButtonNTimesStep() {
  return given2<String, int, FlutterWorld>(
    'I tap the {string} button {int} times',
    (key, count, context) async {
      final locator = find.byValueKey(key);
      for (var i = 0; i < count; i += 1) {
        await FlutterDriverUtils.tap(context.world.driver, locator);
      }
    },
  );
}
```

#### Multiline Strings

Multiline strings can follow a step and will be give to the step it proceeds as the final argument.  To denote a multiline string the pre and postfix can either be third double or single quotes `""" ... """` or `''' ... '''` .

For example:

``` dart
Given I provide the following "review" comment
"""
Some long review comment.
That can span multiple lines

Skip lines

Maybe even include some numbers
1
2
3
"""
```

The matching step definition would then be:

``` dart
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenTheMultiLineComment() {
  return given1(
    'I provide the following {string} comment',
    (comment, context) async {
      // implement step
    },
  );
}
```

#### Data tables

``` dart
import 'package:gherkin/gherkin.dart';

/// This step expects a multiline string proceeding it
///
/// For example:
///
/// `When I add the users`
///  | Firstname | Surname | Age | Gender |
///  | Woody     | Johnson | 28  | Male   |
///  | Edith     | Summers | 23  | Female |
///  | Megan     | Hill    | 83  | Female |
StepDefinitionGeneric WhenIAddTheUsers() {
  return when1(
    'I add the users',
    (Table dataTable, context) async {
      for (var row in dataTable.rows) {
        // do something with row
        row.columns.forEach((columnValue) => print(columnValue));
      }

      // or get the table as a map (column values keyed by the header)
      final columns = dataTable.asMap();
      final personOne = columns.elementAt(0);
      final personOneName = personOne["Firstname"];
      print('Name of first user: `$personOneName` ');
    },
  );
}
```

#### Well known step parameters

In addition to being able to define a step's own parameters (by using regex capturing groups) there are some well known parameter types you can include that will automatically match and convert the parameter into the correct type before passing it to you step definition.  (see <https://docs.cucumber.io/cucumber/cucumber-expressions/#parameter-types>).

In most scenarios theses parameters will be enough for you to write quite advanced step definitions.

| Parameter Name | Description                                   | Aliases                        | Type   | Example                                                             |
| -------------- | --------------------------------------------- | ------------------------------ | ------ | ------------------------------------------------------------------- |
| {word}         | Matches a single word surrounded by a quotes  | {word}, {Word}                 | String | `Given I eat a {word}` would match `Given I eat a "worm"` |
| {string}       | Matches one more words surrounded by a quotes | {string}, {String}             | String | `Given I eat a {string}` would match `Given I eat a "can of worms"` |
| {int}          | Matches an integer                            | {int}, {Int}                   | int    | `Given I see {int} worm(s)` would match `Given I see 6 worms` |
| {num}          | Matches an number                             | {num}, {Num}, {float}, {Float} | num    | `Given I see {num} worm(s)` would match `Given I see 0.75 worms` |

Note that you can combine there well known parameters in any step. For example `Given I {word} {int} worm(s)` would match `Given I "see" 6 worms` and also match `Given I "eat" 1 worm`

#### Pluralization

As the aim of a feature is to convey human readable tests it is often desirable to optionally have some word pluralized so you can use the special pluralization syntax to do simple pluralization of some words in your step definition.  For example:

The step string `Given I see {int} worm(s)` has the pluralization syntax on the word "worm" and thus would be matched to both `Given I see 1 worm` and `Given I see 4 worms` .

#### Custom Parameters

While the well know step parameter will be sufficient in most cases there are time when you would want to defined a custom parameter that might be used across more than or step definition or convert into a custom type.

The below custom parameter defines a regex that matches the words "red", "green" or "blue". The matches word is passed into the function which is then able to convert the string into a Color object.  The name of the custom parameter is used to identity the parameter within the step text.  In the below example the word "colour" is used.  This is combined with the pre / post prefixes (which default to "{" and "}") to match to the custom parameter.

``` dart
import 'package:gherkin/gherkin.dart';

enum Colour { red, green, blue }

class ColourParameter extends CustomParameter<Colour> {
  ColourParameter()
      : super("colour", RegExp(r"(red|green|blue)", caseSensitive: true), (c) {
          switch (c.toLowerCase()) {
            case "red":
              return Colour.red;
            case "green":
              return Colour.green;
            case "blue":
              return Colour.blue;
          }
        });
}
```

The step definition would then use this custom parameter like so:

``` dart
import 'package:gherkin/gherkin.dart';
import 'colour_parameter.dart';

StepDefinitionGeneric GivenIAddTheUsers() {
  return given1<Colour>(
    'I pick the colour {colour}',
    (colour, _) async {
      print("The picked colour was: '$colour'");
    },
  );
}
```

This customer parameter would be used like this: `Given I pick the colour red` . When the step is invoked the word "red" would matched and passed to the custom parameter to convert it into a `Colour` enum which is then finally passed to the step definition code as a `Colour` object.

#### World Context (per test scenario shared state)

#### Assertions

### Tags

Tags are a great way of organizing your features and marking them with filterable information.  Tags can be uses to filter the scenarios that are run.  For instance you might have a set of smoke tests to run on every check-in as the full test suite is only ran once a day.  You could also use an `@ignore` or `@todo` tag to ignore certain scenarios that might not be ready to run yet.

You can filter the scenarios by providing a tag expression to your configuration file.  Tag expression are simple infix expressions such as:

 `@smoke`
 `@smoke and @perf`
 `@billing or @onboarding`
 `@smoke and not @ignore`
You can even us brackets to ensure the order of precedence

 `@smoke and not (@ignore or @todo)`
You can use the usual boolean statement "and", "or", "not"

Also see <https://docs.cucumber.io/cucumber/api/#tags>

### Languages

In order to allow features to be written in a number of languages, you can now write the keywords in languages other than English. To improve readability and flow, some languages may have more than one translation for any given keyword. See https://cucumber.io/docs/gherkin/reference/#overview for a list of supported languages.

You can set the default language of feature files in your project via the configuration setting see [defaultLanguage](#defaultLanguage)

For example these two features are the same the keywords are just written in different languages. Note the ` `  ` # language: de `  ` ` on the second feature.  English is the default language.

``` 
Feature: Calculator
  Tests the addition of two numbers

  Scenario Outline: Add two numbers
    Given the numbers <number_one> and <number_two>
    When they are added
    Then the expected result is <result>

    Examples:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |

```

``` 
# language: de
Funktionalität: Calculator
  Tests the addition of two numbers

  Szenariogrundriss: Add two numbers
    Gegeben sei the numbers <number_one> and <number_two>
    Wenn they are added
    Dann the expected result is <result>

    Beispiele:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |

```

Please note the language data is take and attributed to the cucumber project https://github.com/cucumber/cucumber/blob/master/gherkin/gherkin-languages.json

## Hooks

A hook is a point in the execution that custom code can be run.  Hooks can be run at the below points in the test run.

* Before any tests run
* After all the tests have run
* Before each scenario
* After each scenario

To create a hook is easy.  Just inherit from `Hook` and override the method(s) that signifies the point in the process you want to run code at. Note that not all methods need to be override, just the points at which you want to run custom code.

``` dart
import 'package:gherkin/gherkin.dart';

class HookExample extends Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  @override
  int get priority => 1;

  /// Run before any scenario in a test run have executed
  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    print("before run hook");
  }

  /// Run after all scenarios in a test run have completed
  @override
  Future<void> onAfterRun(TestConfiguration config) async {
    print("after run hook");
  }

  /// Run before a scenario and it steps are executed
  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario) async {
    print("running hook before scenario '$scenario'");
  }

  /// Run after a scenario has executed
  @override
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario) async {
    print("running hook after scenario '$scenario'");
  }
}
```

Finally ensure the hook is added to the hook collection in your configuration file.

``` dart
import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook_example.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [ProgressReporter()]
    ..hooks = [HookExample()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}

```

## Reporting

A reporter is a class that is able to report on the progress of the test run. In it simplest form it could just print messages to the console or be used to tell a build server such as TeamCity of the progress of the test run.  The library has a number of built in reporters.

* `StdoutReporter` - prints all messages from the test run to the console.
* `ProgressReporter` - prints the result of each scenario and step to the console - colours the output.
* `TestRunSummaryReporter` - prints the results and duration of the test run once the run has completed - colours the output.
* `JsonReporter` - creates a JSON file with the results of the test run which can then be used by 'https://www.npmjs.com/package/cucumber-html-reporter.' to create a HTML report.  You can pass in the file path of the json file to be created.
* `FlutterDriverReporter` - prints the output from Flutter Driver. Flutter driver logs all messages to the stderr stream by default so most CI servers would mark the process as failed if anything is logged to the stderr stream (even if the Flutter driver logs are only info messages).  This reporter ensures the log messages are output to the most appropriate stream depending on their log level.

You can create your own custom reporter by inheriting from the base `Reporter` class and overriding the one or many of the methods to direct the output message.  The `Reporter` defines the following methods that can be overridden.  All methods must return a `Future<void>` and can be async.

* `onTestRunStarted`
* `onTestRunFinished`
* `onFeatureStarted`
* `onFeatureFinished`
* `onScenarioStarted`
* `onScenarioFinished`
* `onStepStarted`
* `onStepFinished`
* `onException`
* `message`
* `dispose`
Once you have created your custom reporter don't forget to add it to the `reporters` configuration file property.

*Note*: PR's of new reporters are *always* welcome.

## Flutter

### Restarting the app before each test

By default to ensure your app is in a consistent state at the start of each test the app is shut-down and restarted.  This behaviour can be turned off by setting the `restartAppBetweenScenarios` flag in your configuration object.  Although in more complex scenarios you might want to handle the app reset behaviour yourself; possibly via hooks.

You might additionally want to do some clean-up of your app after each test by implementing an `onAfterScenario` hook.

#### Flutter World

### Pre-defined Steps

For convenience the library defines a number of pre-defined steps so you can get going much quicker without having to implement lots of step classes.  The pre-defined steps are:

| Step Text                                                               | Description                                                                                                     | Examples                                                      |
| ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| I tap the {string} [button\|element\|label\|icon\|field\|text\|widget] | Taps the element with the provided key ( given by the first input parameter)                                    | `When I tap the "login" button` , `Then I tap the "save" icon` |
| I fill the {string} field with {string}                 | Fills the element with the provided key with the given value (given by the second input parameter)          | `When I fill the "email" field with "someone@gmail.com"` |
| I expect the {string} to be {string}                                    | Asserts that the element with the given key has the given string value                                        | `Then I expect the "cost" to be "£10.95"` |
| I (open\|close) the drawer                              | Opens or closes the application default drawer    | `When I open the drawer` , `And I close the drawer` |
| I expect the [button\|element\|label\|icon\|field\|text\|widget] {string} to be present within {int} second(s) | Expects a widget with the given key to be present within n seconds                                     | `Then I expect the widget 'notification' to be present within 10 seconds` , `Then I expect the icon 'notification' to be present within 1 second` |
| I pause for {int} seconds                               | Pauses the test execution for the given seconds. Only use in debug scenarios or to inspect the state of the app | `Then I pause for 20 seconds` |
| I restart the app                                       | Restarts the app under test | `Then I restart the app` |
| I tap the back button                                   | Taps the page default back button widget | `Then I tap the back button` |
| I expect a {string} that contains the text {string} to also contain the text {string} | Discovers a sibling based on its parent widget type and asserts that the both text string exist within the parent. | `Then I expect a "Row" that contains the text "X" to also contain the text "Y"` |
| I swipe [down\|left\|right\|up] by {int} pixels on the {string} | Swipes in a cardinal direction on a widget discovered by its key. | `Then I swipe up by 800 pixels on the "login_screen"` , `Then I swipe left by 200 pixels on the "dismissible_list_item"` |
| I swipe [down\|left\|right\|up] by {int} pixels on the on the [button\|element\|label\|field\|text\|widget\|dialog\|popup] that contains the text {string} | Swipes in a cardinal direction on a widget discovered by its test. | `Then I swipe left by 400 pixels on the widget that contains the text "Dismiss Me"` |
| I tap the [button\|element\|label\|field\|text\|widget] that contains the text {string} within the {string} |  Taps a widget that contains the text within another widget. If the text is not visible, the ancestor will be scrolled. | `Then I tap the label that contains the text "Logout" within the "user_settings_list"` |
| I tap the [button\|element\|label\|icon\|field\|text\|widget] of type {string} | Taps a widget of type. | `Then I tap the element of type "MaterialButton"` , `Then I tap the label of type "ListTile"` , `Then I tap the field of type "TextField"` |
| I tap the [button\|element\|label\|icon\|field\|text\|widget] of type {string} within the {string} | Taps a widget of type within another widget. | `Then I tap the element of type "MaterialButton" within the "user_settings_list"` |
| I tap the [button\|element\|label\|icon\|field\|text\|widget] that contains the text {string} | Taps a widget that contains text. | `Then I tap the label that contains the text "Logout"` , `Then I tap the button that contains the text "Sign up"` , `Then I tap the widget that contains the text "My User Profile"` |
| I expect the text {string} to be [present\|absent] | Asserts the existence of text on the screen. | `Then I expect the text "Logout" to be present` , `But I expect the text "Signup" to be absent` |
| I expect the text {string} to be [present\|absent] within the {string} | Asserts the existence of text within a parent widget. | `Then I expect the text "Logout" to be present within the "user_settings_list"` , `But I expect the text "Signup" to be absent within the "login_screen"` |
| I wait until the {string} is [present\absent] | Delays until a widget is present or absent. | `Then I wait until the "login_loading_indicator" is absent` , `And I wait until the "login_screen" is present` |
| I wait until the [button\|element\|label\|icon\|field\|text\|widget] of type {string} is [present\absent] | Waits until a widget type is present or absent. | `Then I wait until the element of type "ProgressIndicator" is absent` , `And I wait until the button of type "MaterialButton" is present` |
| I long press the {string} [button\|element\|label\|icon\|field\|text\|widget] | Scrolls into view and long presses the widget for 500 milliseconds. | `When I long press "controlKey" button` |
| I long press the {string} [button\|element\|label\|icon\|field\|text\|widget] without scrolling it into view | Long presses the widget for 500 milliseconds. | `When I long press "controlKey" button without scrolling it into view` |
| I long press the {string} [button\|element\|label\|icon\|field\|text\|widget] for {int} milliseconds | Scrolls into view and long presses the widget for the give number of milliseconds. | `When I long press "controlKey" button without scrolling it into view for 1500 milliseconds` |

#### Flutter Driver Utilities

For convenience the library provides a static `FlutterDriverUtils` class that abstracts away some common Flutter driver functionality like tapping a button, getting and entering text, checking if an element is present or absent, waiting for a condition to become true.  See [lib/src/flutter/utils/driver_utils.dart](lib/src/flutter/utils/driver_utils.dart).

### Debugging

In VSCode simply add add this block to your launch.json file (if you testable app is called `app_test.dart` and within the `test_driver` folder, if not replace that with the correct file path).  Don't forget to put a break point somewhere!

``` json
{
  "name": "Debug Features Tests",
  "request": "launch",
  "type": "dart",
  "program": "test_driver/app_test.dart",
  "flutterMode": "debug"
}
```

After which the file will most likely look like this

``` json
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart"
    },
    {
      "name": "Debug Features Tests",
      "request": "launch",
      "type": "dart",
      "program": "test_driver/app_test.dart",
      "flutterMode": "debug"
    }
  ]
}
```

#### Debugging the app under test

Setting the configuration property `runningAppProtocolEndpointUri` to the service protocol endpoint (found in stdout when an app has `--verbose` logging turned on) will ensure that the existing app is connected to rather than starting a new instance of the app.

NOTE: ensure the app you are trying to connect to calls `enableFlutterDriverExtension()` when it starts up otherwise the Flutter Driver will not be able to connect to it.

Also ensure that the `--verbose` flag is set when starting the app to test, this will then log the service protocol endpoint out to the console which is the uri you will need to set this property to.  It usually takes the form of `Connecting to service protocol: http://127.0.0.1:51540/EM72VtRsUV0=/` so set the `runningAppProtocolEndpointUri` to `http://127.0.0.1:51540/EM72VtRsUV0=/` and then start the tests.

##### Interactive debugging
One way to configure your test environment is to run the app under test in a separate terminal and run the gherkin in a different terminal. With this approach you can hot reload the app by entering `R` in the app terminal and run the steps repeatedly in the other terminal **with out** incurring the cost of the app start up.

For the app under test, in this case `lib/main_test.dart`, it should look similar to this:

```
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
void main() {
  enableFlutterDriverExtension();
runApp();
```

When you start this from the terminal, run like this:

` flutter run -t lib/main_test.dart --verbose`

As stated above, with the `--verbose` flag, you will want to find the service protocol endpoint.
You should see similar output as this:

```
.....
Connecting to service protocol: http://127.0.0.1:61658/RtsPT2zp_qs=/
.....
Flutter run key commands.
[ +2 ms] r Hot reload. 🔥🔥🔥
[ +1 ms] R Hot restart.
[ ] h Repeat this help message.
[ ] d Detach (terminate "flutter run" but leave application running).
[ ] c Clear the screen
[ ] q Quit (terminate the application on the device).
[ ] An Observatory debugger and profiler on iPhone 8 Plus is available at: http://127.0.0.1:61660/xgrsw_qQ9sI=/
[ ] Running with unsound null safety
[ ] For more information see https://dart.dev/null-safety/unsound-null-safety
```

To run the gherkin tests, first update the `test_driver/app_test.dart` to something similar to this:

```
import 'dart:async';
import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
Future<void> main(List<String> args) async {
if (args.isEmpty) {
  print('please pass in the uri');
  exit(1);
}
final Iterable<StepDefinitionGeneric<World>> steps = [];
final config = FlutterTestConfiguration.DEFAULT(
  steps,
  featurePath: 'features//**.feature',
  targetAppPath: 'test_driver/app.dart',
)
  ..restartAppBetweenScenarios = false
  ..targetAppWorkingDirectory = '../'
  ..runningAppProtocolEndpointUri = args[0]; 
  return GherkinRunner().execute(config);
}
```

Start a new terminal and navigate to the `test_driver` directory. 

Notice the `app_test.dart` expects a parameter. This is to ease the changing uri which will occur each time the app under test is started.  If you use the `R` command, the `uri` does not change.

You can copy the `uri` from the terminal window of the app under test.

Run the command `dart app_test.dart <uri>`. As an example, the app under test has this line: 
   `Connecting to service protocol: http://127.0.0.1:61658/RtsPT2zp_qs=/` 
so you would copy `http://127.0.0.1:61658/RtsPT2zp_qs=/` and paste it as such: 

`dart app_test.dart http://127.0.0.1:59862/luEyFXvK9Qc=/`.

As you make changes in the app under test, just `R` (reload). In the test window you can rerun the tests and update the Scenarios quickly and easily.

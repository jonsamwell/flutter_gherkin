# flutter_gherkin

A fully features Gherkin parser and test runner.  Works with Flutter and Dart 2.

This implementation of the Gherkin tries to follow as closely as possible other implementations of Gherkin and specifically [Cucumber](https://docs.cucumber.io/cucumber/) in it's various forms.

```dart
  # Comment
  @tag
  Feature: Eating too many cucumbers may not be good for you

    Eating too much of anything may not be good for you.

    Scenario: Eating a few is no problem
      Given Alice is hungry
      When she eats 3 cucumbers
      Then she will be full
```

## Table of Contents

<!-- TOC -->

- [flutter_gherkin](#flutter_gherkin)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Configuration](#configuration)
  - [Features Files](#features-files)
    - [Steps Definitions](#steps-definitions)
      - [Given](#given)
      - [Then](#then)
      - [Step Timeout](#step-timeout)
      - [Multiline Strings](#multiline-strings)
      - [Data tables](#data-tables)
      - [Well known step parameters](#well-known-step-parameters)
      - [Pluralisation](#pluralisation)
      - [Custom Parameters](#custom-parameters)
      - [World Context (per test scenario shared state)](#world-context-per-test-scenario-shared-state)
      - [Assertions](#assertions)
    - [Tags](#tags)
  - [Hooks](#hooks)
  - [Reporting](#reporting)
  - [Flutter](#flutter)
    - [Flutter Specific Configuration](#flutter-specific-configuration)
      - [Restarting the app before each test](#restarting-the-app-before-each-test)
      - [Flutter World](#flutter-world)
    - [Pre-defined Steps](#pre-defined-steps)
    - [Debugging](#debugging)

<!-- /TOC -->

## Getting Started

See <https://docs.cucumber.io/gherkin/> for information on the Gherkin syntax and Behaviour Driven Development (BDD).  

The first step is to create a version of your app that has flutter driver enabled so that it can be automated.  A good guide how to do this is show [here](flutter.io/cookbook/testing/integration-test-introduction/#4-instrument-the-app).  However in short, create a folder called `test_driver` and within that create a file called `app.dart` and paste in the below code.

```dart
import '../lib/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  runApp(new MyApp());
}

```

All this code does is enable the Flutter driver extension which is required to be able to automate the app and then runs your application.

To get started with BDD in Flutter the first step is to write a feature file and a test scenario within that.

First create a folder called `test_driver` (this is inline with the current integration test as we will need to use the Flutter driver to automate the app).  Within the folder create a folder called `features`, then create a file called `counter.feature`.

```dart
Feature: Counter
  The counter should be incremented when the button is pressed.

  Scenario: Counter increases when the button is pressed
    Given I expect the "counter" to be "0"
    When I tap the "increment" button 10 times
    Then I expect the "counter" to be "10"
```

Now we have created a scenario we need to implement the steps within.  Steps are just classes that extends from the base step definition class or any of its variations `Given`, `Then`, `When`, `And`, `But`.

Granted the example is a little contrived but is serves to illustrate the process.

This library has a couple of built in step definitions for convenience.  The first step uses the built in step, however the second step `When I tap the "increment" button 10 times` is a custom step and has to be implemented.  To implement a step we have to create a simple step definition class.

```dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class TapButtonNTimesStep extends When2WithWorld<String, int, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, int input2) async {
    final locator = find.byValueKey(input1);
    for (var i = 0; i < input2; i += 1) {
      await world.driver.tap(locator);
    }
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button {int} times");
}
```

As you can see the class inherits from `When2WithWorld` and specifies the types of the two input parameters.  The third type `FlutterWorld` is a special Flutter context object that allow access to the Flutter driver instance within the step.  If you did not need this you could inherit from `When2` which does not type the world context object but still provides two input parameters.

The input parameters are retrieved via the pattern regex from well know parameter types `{string}` and `{int}` [explained below](#well-known-step-parameters).  They are just special syntax to indicate you are expecting a string and an integer at those points in the step text.  Therefore, when the step to execute is `When I tap the "increment" button 10 times` the parameters "increment" and 10 will be passed into the step as the correct types.  Note that in the pattern you can use any regex capture group to indicate any input parameter.  For example the regex ```RegExp(r"When I tap the {string} (button|icon) {int} times")``` indicates 3 parameters and would match to either of the below step text.

```dart
When I tap the "increment" button 10 times    // passes 3 parameters "increment", "button" & 10
When I tap the "increment" icon 2 times       // passes 3 parameters "increment", "icon" & 2
```

It is worth noting that this library *does not* rely on mirrors (reflection) for many reasons but most prominently for ease of maintenance and to fall inline with the principles of Flutter not allowing reflection.  All in all this make for a much easier to understand and maintain code base.  The downside is that we have to be slightly more explicit by providing instances of custom code such as step definition, hook, reporters and custom parameters.

Now that we have a testable app, a feature file and a custom step definition we need to create a class that will call this library and actually run the tests.  Create a file called `app_test.dart` and put the below code in.

```dart
import 'dart:async';
import 'package:glob/glob.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/*.feature")]
    ..reporters = [StdoutReporter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}
```

This code simple creates a configuration object and calls this library which will then promptly parse your feature files and run the tests.  The configuration file is important and explained in further detail below.  However, all that is happening is a `Glob` is provide which specifies the path to one or more feature files, it sets the reporter to the `StdoutReporter` report which mean prints to the standard output (console).  Finally it specifies the path to the testable app created above `test_driver/app.dart`.  This is important as it instructions the library which app to run the tests against.

Finally to actually run the tests run the below on the command line:

```bash
dart test_driver/app_test.dart
```

To debug tests see [Debugging](#debugging).

*Note*: You might need to ensure dart is accessible by adding it to your path variable.

### Configuration

## Features Files

### Steps Definitions

Step definitions are the coded representation of a textual step in a feature file.  Each step starts with either `Given`, `Then`, `When`, `And` or `But`.  It is worth noting that all steps are actually the same but semantically different.  The keyword is not taken into account when matching a step.  Therefore the two below steps are actually treated the same and will result in the same step definition being invoked.

Note: Step definitions (in this implementation) are allowed up to 5 input parameters.  If you find yourself needing more than this you might want to consider making your step more isolated or using a `Table` parameter.

```dart
Given there are 6 kangaroos
Then there are 6 kangaroos
```

However, the domain language you choose will influence what keyword works best in each context.  For more information <https://docs.cucumber.io/gherkin/reference/#steps>.

#### Given

`Given` steps are used to describe the initial state of a system.  The execution of a `Given` step will usually put the system into well defined state.

To implement a `Given` step you can inherit from the ```Given``` class.

```dart
Given Bob has logged in
```

Would be implemented like so:

```dart
import 'package:flutter_gherkin/flutter_gherkin.dart';

class GivenWellKnownUserIsLoggedIn extends Given1<String> {
  @override
  Future<void> executeStep(String wellKnownUsername) async {
    // implement your code
  }

  @override
  RegExp get pattern => RegExp(r"(Bob|Mary|Emma|Jon) has logged in");
}
```

If you need to have more than one Given in a block it is often best to use the additional keywords `And` or `But`.

```dart
Given Bob has logged in
And opened the dashboard
```

#### Then

`Then` steps are used to describe an expected outcome, or result.  They would typically have an assertion in which can pass or fail.

```dart
Then I expect 10 apples
```

Would be implemented like so:

```dart
import 'package:flutter_gherkin/flutter_gherkin.dart';

class ThenExpectAppleCount extends Then1<int> {
  @override
  Future<void> executeStep(int count) async {
    // example code
    final actualCount = await _getActualCount();
    expectMatch(actualCount, count);
  }

  @override
  RegExp get pattern => RegExp(r"I expect {int} apple(s)");
}
```

**Caveat**: The `expect` library currently only works within the library's own `test` function blocks; so using it with a `Then` step will cause an error.  Therefore, the `expectMatch` or `expectA` or `this.expect` methods have been added which mimic the underlying functionality of `except` in that they assert that the give is true.  The `Matcher` within Dart's test library still work and can be used as expected.

#### Step Timeout

By default a step will timeout if it exceed the `defaultTimeout` parameter in the configuration file.  In some cases you want have a step that is longer or shorter running and in the case you can optionally proved a custom timeout to that step.  To do this pass in a `Duration` object in the step's call to `super`.

For example, the below sets the step's timeout to 10 seconds.

```dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class TapButtonNTimesStep extends When2WithWorld<String, int, FlutterWorld> {
  TapButtonNTimesStep()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep(String input1, int input2) async {
    final locator = find.byValueKey(input1);
    for (var i = 0; i < 10; i += 1) {
      await world.driver.tap(locator, timeout: timeout);
    }
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button {int} times");
}
```

#### Multiline Strings

Multiline strings can follow a step and will be give to the step it proceeds as the final argument.  To denote a multiline string the pre and postfix can either be third double or single quotes `""" ... """` or `''' ... '''`.

For example:

```dart
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

```dart
import 'package:flutter_gherkin/flutter_gherkin.dart';

class GivenIProvideAComment extends Given2<String, String> {
  @override
  Future<void> executeStep(String commentType, String comment) async {
    // TODO: implement executeStep
  }

  @override
  RegExp get pattern => RegExp(r"I provide the following {string} comment");
}

```

#### Data tables

```dart
import 'package:flutter_gherkin/flutter_gherkin.dart';

/// This step expects a multiline string proceeding it
///
/// For example:
///
/// `Given I add the users`
///  | Firstname | Surname | Age | Gender |
///  | Woody     | Johnson | 28  | Male   |
///  | Edith     | Summers | 23  | Female |
///  | Megan     | Hill    | 83  | Female |
class GivenIAddTheUsers extends Given1<Table> {
  @override
  Future<void> executeStep(Table dataTable) async {
    // TODO: implement executeStep
    for (var row in dataTable.rows) {
      // do something with row
      row.columns.forEach((columnValue) => print(columnValue));
    }
  }

  @override
  RegExp get pattern => RegExp(r"I add the users");
}
```

#### Well known step parameters

In addition to being able to define a step's own parameters (by using regex capturing groups) there are some well known parameter types you can include that will automatically match and convert the parameter into the correct type before passing it to you step definition.  (see <https://docs.cucumber.io/cucumber/cucumber-expressions/#parameter-types>).

In most scenarios theses parameters will be enough for you to write quite advanced step definitions.

| Parameter Name | Description                                   | Aliases                        | Type   | Example                                                             |
| -------------- | --------------------------------------------- | ------------------------------ | ------ | ------------------------------------------------------------------- |
| {word}         | Matches a single word surrounded by a quotes  | {word}, {Word}                 | String | `Given I eat a {word}` would match `Given I eat a "worm"`           |
| {string}       | Matches one more words surrounded by a quotes | {string}, {String}             | String | `Given I eat a {string}` would match `Given I eat a "can of worms"` |
| {int}          | Matches an integer                            | {int}, {Int}                   | int    | `Given I see {int} worm(s)` would match `Given I see 6 worms`       |
| {num}          | Matches an number                             | {num}, {Num}, {float}, {Float} | num    | `Given I see {num} worm(s)` would match `Given I see 0.75 worms`    |

Note that you can combine there well known parameters in any step. For example `Given I {word} {int} worm(s)` would match `Given I "see" 6 worms` and also match `Given I "eat" 1 worm`

#### Pluralisation

As the aim of a feature is to convey human readable tests it is often desirable to optionally have some word pluaralised so you can use the special pluralisation syntax to do simple pluralisation of some words in your step definition.  For example:

The step string `Given I see {int} worm(s)` has the pluralisation syntax on the word "worm" and thus would be matched to both `Given I see 1 worm` and `Given I see 4 worms`.

#### Custom Parameters

While the well know step parameter will be sufficient in most cases there are time when you would want to defined a custom parameter that might be used across more than or step definition or convert into a custom type.

The below custom parameter defines a regex that matches the words "red", "green" or "blue". The matches word is passed into the function which is then able to convert the string into a Color object.  The name of the custom parameter is used to identity the parameter within the step text.  In the below example the word "colour" is used.  This is combined with the pre / post prefixes (which default to "{" and "}") to match to the custom parameter.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class ColourParameter extends CustomParameter<Color> {
  ColourParameter()
      : super("colour", RegExp(r"(red|green|blue)"), (c) {
          switch (c.toLowerCase()) {
            case "red":
              return Colors.red;
            case "green":
              return Colors.green;
            case "blue":
              return Colors.blue;
          }
        });
}
```

The step definition would then use this custom parameter like so:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class GivenIPickAColour extends Given1<Color> {
  @override
  Future<void> executeStep(Color input1) async {
    // TODO: implement executeStep
  }

  @override
  RegExp get pattern => RegExp(r"I pick the colour {colour}");
}
```

This customer parameter would be used like this: `Given I pick the colour red`. When the step is invoked the word "red" would matched and passed to the custom parameter to convert it into a Color object which is then finally passed to the step definition code as a Color object.

#### World Context (per test scenario shared state)

#### Assertions

### Tags

Tags are a great way of organising your features and marking them with filterable information.  Tags can be uses to filter the scenarios that are run.  For instance you might have a set of smoke tests to run on every check-in as the full test suite is only ran once a day.  You could also use an `@ignore` or `@todo` tag to ignore certain scenarios that might not be ready to run yet.

You can filter the scenarios by providing a tag expression to your configuration file.  Tag expression are simple infix expressions such as:

`@smoke`

`@smoke and @perf`

`@billing or @onboarding`

`@smoke and not @ignore`

You can even us brackets to ensure the order of precedence

`@smoke and not (@ignore or @todo)`

You can use the usual boolean statement "and", "or", "not"

Also see <https://docs.cucumber.io/cucumber/api/#tags>

## Hooks

## Reporting

## Flutter

### Flutter Specific Configuration

#### Restarting the app before each test

By default to ensure your app is in a consistent state at the start of each test the app is shut-down and restarted.  This behaviour can be turned off by setting the `restartAppBetweenScenarios` flag in your configuration object.  Although in more complex scenarios you might want to handle the app reset behaviour yourself; possibly via hooks.

You might additionally want to do some clean-up of your app after each test by implementing an `onAfterScenario` hook.

#### Flutter World

### Pre-defined Steps

### Debugging

In VSCode simply add add this block to your launch.json file (if you testable app is called `app_test.dart` and within the `test_driver` folder, if not replace that with the correct file path).  Don't forget to put a break point somewhere!

```json
{
  "name": "Debug Features Tests",
  "request": "launch",
  "type": "dart",
  "program": "test_driver/app_test.dart",
  "flutterMode": "debug"
}
```

After which the file will most likely look like this

```json
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

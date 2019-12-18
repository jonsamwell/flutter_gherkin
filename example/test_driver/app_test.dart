import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      FlutterDriverReporter(
          logErrorMessages: true,
          logInfoMessages: true,
          logWarningMessages: true),
      JsonReporter(path: './report.json'),
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..hooks = [
      HookExample()
    ] // you can include "AttachScreenshotOnFailedStepHook()" to take a screenshot of each step failure and attach it to the world object
    ..stepDefinitions = [
      TapButtonNTimesStep(),
      GivenIPickAColour(),
    ]
    ..customStepParameterDefinitions = [
      ColourParameter(),
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppWorkingDirecotry = "../"
    ..targetAppPath = "test_driver/app.dart"
    // ..buildFlavor = "staging" // uncomment when using build flavor and check android/ios flavor setup see android file android\app\build.gradle
    // ..targetDeviceId = "all" // uncomment to run tests on all connected devices or set specific device target id
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    // ..logFlutterProcessOutput = true // uncomment to see the output from the Flutter process
    // ..flutterBuildTimeout = Duration(minutes: 3) // uncomment to change the default period that flutter is expected to build and start the app within
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}

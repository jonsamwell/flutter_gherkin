import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_I_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final steps = [
    TapButtonNTimesStep(),
    GivenIPickAColour(),
  ];

  final config = FlutterTestConfiguration.DEFAULT(
    steps,
    featurePath: 'features//**.feature',
    targetAppPath: 'test_driver/app.dart',
  )
    ..hooks = [
      HookExample(),
      // AttachScreenshotOnFailedStepHook(), // takes a screenshot of each step failure and attaches it to the world object
    ]
    ..customStepParameterDefinitions = [
      ColourParameter(),
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppWorkingDirectory = '../'
    ..targetAppPath = 'test_driver/app.dart'
    // ..buildFlavor = "staging" // uncomment when using build flavor and check android/ios flavor setup see android file android\app\build.gradle
    // ..targetDeviceId = "all" // uncomment to run tests on all connected devices or set specific device target id
    // ..tagExpression = '@smoke' // uncomment to see an example of running scenarios based on tag expressions
    // ..logFlutterProcessOutput = true // uncomment to see command invoked to start the flutter test app
    // ..verboseFlutterProcessLogs = true // uncomment to see the verbose output from the Flutter process
    // ..flutterBuildTimeout = Duration(minutes: 3) // uncomment to change the default period that flutter is expected to build and start the app within
    // ..runningAppProtocolEndpointUri =
    //     'http://127.0.0.1:51540/bkegoer6eH8=/' // already running app observatory / service protocol uri (with enableFlutterDriverExtension method invoked) to test against if you use this set `restartAppBetweenScenarios` to false
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly

  return GherkinRunner().execute(config);
}

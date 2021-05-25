import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_test/flutter_test.dart';

final whenStepHasTimeout = when<FlutterWidgetTesterWorld>(
  'I test the default step timeout is not applied to step with custom timeout',
  (_) async {
    // this should fail as the timeout of the test is 15 seconds but the below waits for 30 seconds
    await Future<void>.delayed(const Duration(seconds: 30));
  },
  configuration: StepDefinitionConfiguration()
    ..timeout = const Duration(seconds: 15),
);

import 'package:gherkin/gherkin.dart';
import 'package:flutter_gherkin/flutter_gherkin_integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

final whenStepHasTimeout = when<FlutterWidgetTesterWorld>(
  'I test the default step timeout is not applied to step with custom timeout',
  (_) async {
    await Future<void>.delayed(const Duration(seconds: 30));
  },
  configuration: StepDefinitionConfiguration()
    ..timeout = const Duration(seconds: 15),
);

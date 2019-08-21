import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class RestartAppStep extends WhenWithWorld<FlutterWorld> {
  RestartAppStep()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 60));

  @override
  Future<void> executeStep() async {
    await world.restartApp(timeout: timeout);
  }

  @override
  RegExp get pattern => RegExp(r"I restart the app");
}

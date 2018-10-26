import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/scenario.dart';

class BackgroundRunnable extends ScenarioRunnable {
  BackgroundRunnable(String name, RunnableDebugInformation debug)
      : super(name, debug);
}

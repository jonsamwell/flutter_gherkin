import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';

enum Target { run, feature, scenario, step }

class StartedMessage {
  final Target target;
  final String name;
  final RunnableDebugInformation context;

  StartedMessage(this.target, this.name, this.context);
}

class FinishedMessage {
  final Target target;
  final String name;
  final RunnableDebugInformation context;

  FinishedMessage(this.target, this.name, this.context);
}

class StepFinishedMessage extends FinishedMessage {
  final StepResult result;

  StepFinishedMessage(
      String name, RunnableDebugInformation context, this.result)
      : super(Target.step, name, context);
}

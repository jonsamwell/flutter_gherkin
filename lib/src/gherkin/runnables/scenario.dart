import 'package:flutter_gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/tags.dart';

class ScenarioRunnable extends RunnableBlock {
  String _name;
  List<String> tags = List<String>();
  List<StepRunnable> steps = new List<StepRunnable>();

  ScenarioRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case StepRunnable:
        steps.add(child);
        break;
      case TagsRunnable:
        tags.addAll((child as TagsRunnable).tags);
        break;
      case CommentLineRunnable:
      case EmptyLineRunnable:
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to Scenario '${child.runtimeType}'");
    }
  }
}

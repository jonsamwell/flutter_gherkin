import 'package:flutter_gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:flutter_gherkin/src/gherkin/models/table.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/table.dart';

class StepRunnable extends RunnableBlock {
  String _name;
  String description;
  List<String> multilineStrings = List<String>();
  Table table;

  StepRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case MultilineStringRunnable:
        multilineStrings
            .add((child as MultilineStringRunnable).lines.join("\n"));
        break;
      case TableRunnable:
        if (table != null)
          throw new GherkinSyntaxException(
              "Only a single table can be added to the step '$name'");

        table = (child as TableRunnable).toTable();
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to Step '${child.runtimeType}'");
    }
  }
}

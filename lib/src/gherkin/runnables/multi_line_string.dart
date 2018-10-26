import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/text_line.dart';

class MultilineStringRunnable extends RunnableBlock {
  List<String> lines = List<String>();

  @override
  String get name => "Multiline String";

  MultilineStringRunnable(RunnableDebugInformation debug) : super(debug);

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TextLineRunnable:
        lines.add((child as TextLineRunnable).text);
        break;
      case EmptyLineRunnable:
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to Multiline string '${child.runtimeType}'");
    }
  }
}

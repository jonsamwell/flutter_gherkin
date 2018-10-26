import 'package:flutter_gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/background.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/scenario.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/tags.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/text_line.dart';

class FeatureRunnable extends RunnableBlock {
  String _name;
  String description;
  List<String> tags = List<String>();
  BackgroundRunnable background;
  List<ScenarioRunnable> scenarios = List<ScenarioRunnable>();

  Map<int, Iterable<String>> _tagMap = Map<int, Iterable<String>>();

  FeatureRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TextLineRunnable:
        description =
            "${description == null ? "" : "$description\n"}${(child as TextLineRunnable).text}";
        break;
      case TagsRunnable:
        tags.addAll((child as TagsRunnable).tags);
        _tagMap.putIfAbsent(
            child.debug.lineNumber, () => (child as TagsRunnable).tags);
        break;
      case ScenarioRunnable:
        scenarios.add(child);
        if (_tagMap.containsKey(child.debug.lineNumber - 1)) {
          (child as ScenarioRunnable).addChild(
              TagsRunnable(null)..tags = _tagMap[child.debug.lineNumber - 1]);
        }
        break;
      case BackgroundRunnable:
        if (background == null) {
          background = child;
        } else {
          throw new GherkinSyntaxException(
              "Feature file can only contain one backgroung block. File'${debug.filePath}' :: line '${child.debug.lineNumber}'");
        }
        break;
      case EmptyLineRunnable:
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to Feature '${child.runtimeType}'");
    }
  }
}

import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/language.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';

class FeatureFile extends RunnableBlock {
  String _language = "en";

  List<FeatureRunnable> features = new List<FeatureRunnable>();

  FeatureFile(RunnableDebugInformation debug) : super(debug);

  String get langauge => _language;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case LanguageRunnable:
        _language = (child as LanguageRunnable).language;
        break;
      case FeatureRunnable:
        features.add(child);
        break;
      case EmptyLineRunnable:
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to FeatureFile '${child.runtimeType}'");
    }
  }

  @override
  String get name => debug.filePath;
}

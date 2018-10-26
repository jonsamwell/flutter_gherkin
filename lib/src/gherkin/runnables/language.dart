import './debug_information.dart';
import './runnable.dart';

class LanguageRunnable extends Runnable {
  String language;

  @override
  String get name => "Language";

  LanguageRunnable(RunnableDebugInformation debug) : super(debug);
}

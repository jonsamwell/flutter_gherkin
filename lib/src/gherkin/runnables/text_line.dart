import './debug_information.dart';
import './runnable.dart';

class TextLineRunnable extends Runnable {
  String text;

  @override
  String get name => "Language";

  TextLineRunnable(RunnableDebugInformation debug) : super(debug);
}

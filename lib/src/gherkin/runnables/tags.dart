import './debug_information.dart';
import './runnable.dart';

class TagsRunnable extends Runnable {
  Iterable<String> tags;

  @override
  String get name => "Tags";

  TagsRunnable(RunnableDebugInformation debug) : super(debug);
}

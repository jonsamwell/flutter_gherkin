import './debug_information.dart';
import './runnable.dart';

class EmptyLineRunnable extends Runnable {
  @override
  String get name => "Empty Line";

  EmptyLineRunnable(RunnableDebugInformation debug) : super(debug);
}

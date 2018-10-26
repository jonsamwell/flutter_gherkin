import './debug_information.dart';

abstract class Runnable {
  final RunnableDebugInformation debug;

  Runnable(this.debug);

  String get name;
}

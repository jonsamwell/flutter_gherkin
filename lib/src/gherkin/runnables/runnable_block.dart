import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';

import './runnable.dart';

abstract class RunnableBlock extends Runnable {
  RunnableBlock(RunnableDebugInformation debug) : super(debug);

  void addChild(Runnable child);
}

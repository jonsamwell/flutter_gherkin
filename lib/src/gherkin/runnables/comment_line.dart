import './debug_information.dart';
import './runnable.dart';

class CommentLineRunnable extends Runnable {
  final String comment;

  @override
  String get name => "Comment Line";

  CommentLineRunnable(this.comment, RunnableDebugInformation debug)
      : super(debug);
}

import 'dart:async';

class Perf {
  static Future<T> measure<T>(
      Future<T> action(), void logFn(int elapsedMilliseconds)) async {
    final timer = new Stopwatch();
    timer.start();
    try {
      return await action();
    } finally {
      timer.stop();
      logFn(timer.elapsedMilliseconds);
    }
  }
}

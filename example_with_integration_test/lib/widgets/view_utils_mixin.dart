import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewUtilsMixin {
  @protected
  StreamSubscription<T> subscribeOnce<T>(
    Stream<T> stream, {
    void Function(T data)? onData,
    void Function(Object, StackTrace)? onError,
    void Function()? onDone,
  }) {
    StreamSubscription<T>? sub;
    var hasErrored = false;
    return sub = stream.listen(
      (data) {
        sub?.cancel();
        if (!hasErrored && onData != null) {
          onData(data);
        }
      },
      onError: (Object er, StackTrace st) {
        hasErrored = true;
        if (onError != null) {
          onError(er, st);
        }
      },
      onDone: onDone,
      cancelOnError: true,
    );
  }
}

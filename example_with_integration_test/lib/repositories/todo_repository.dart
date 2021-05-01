import 'dart:async';
import 'dart:convert';

import 'package:example_with_integration_test/models/todo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// This is a very naive and inefficient repository please do not copy this!
///
class TodoRepository {
  static const STORAGE_ACCESSOR_KEY = 'TODO';

  final Subject<SharedPreferences> _storage =
      ReplaySubject<SharedPreferences>(maxSize: 1);

  TodoRepository() {
    StreamSubscription<SharedPreferences>? sub;
    sub = SharedPreferences.getInstance().asStream().listen(
      (sp) {
        _storage.add(sp);
        sub?.cancel();
      },
    );
  }

  Stream<Iterable<Todo>> all() {
    return _storage
        .map((accessor) => accessor.getStringList(STORAGE_ACCESSOR_KEY))
        .map(
          (items) => (items ?? <String>[])
              .map(
                (data) => Todo.fromJson(
                  jsonDecode(data),
                ),
              )
              .toList(
                growable: false,
              ),
        );
  }

  Stream<bool> add(Todo item) {
    return all().switchMap(
      (items) {
        final itemsAsJson = (items.toList()..add(item))
            .map((x) => jsonEncode(x.toJson()))
            .toList(
              growable: false,
            );

        return _storage.switchMap(
          (accessor) => accessor
              .setStringList(STORAGE_ACCESSOR_KEY, itemsAsJson)
              .asStream(),
        );
      },
    );
  }

  Stream<bool> update(Todo item) {
    return all().switchMap(
      (items) {
        final itemsAsJson = (items.toList()
              ..removeWhere((x) => x.id == item.id)
              ..add(item))
            .map((x) => jsonEncode(x.toJson()))
            .toList(
              growable: false,
            );

        return _storage.switchMap(
          (accessor) => accessor
              .setStringList(STORAGE_ACCESSOR_KEY, itemsAsJson)
              .asStream(),
        );
      },
    );
  }

  Stream<bool> delete(Todo item) {
    return all().switchMap(
      (items) {
        final itemsAsJson = (items.toList()
              ..removeWhere((x) => x.id == item.id))
            .map((x) => jsonEncode(x.toJson()))
            .toList(
              growable: false,
            );

        return _storage.switchMap(
          (accessor) => accessor
              .setStringList(STORAGE_ACCESSOR_KEY, itemsAsJson)
              .asStream(),
        );
      },
    );
  }

  Stream<bool> purge() {
    return _storage.switchMap(
      (accessor) => accessor.remove(STORAGE_ACCESSOR_KEY).asStream(),
    );
  }

  void dispose() {
    _storage.close();
  }
}

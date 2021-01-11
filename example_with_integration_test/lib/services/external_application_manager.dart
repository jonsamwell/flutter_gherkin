import 'package:example_with_integration_test/repositories/todo_repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:rxdart/rxdart.dart';

/// Class that is able to manager the application and perform tasks
/// such as resetting the app data etc
class ExternalApplicationManager {
  final Injector _injector;
  // final Subject<void> _applicationReset = BehaviorSubject<void>.seeded(null);
  final Subject<void> _applicationReset = ReplaySubject(maxSize: 1);

  Stream<void> get applicationReset => _applicationReset;

  ExternalApplicationManager(this._injector);

  /// Resets the application to a newly installed state by removing all data
  Future<void> resetApplication() async {
    await _injector.get<TodoRepository>().purge().first;
    _applicationReset.add(null);

    return Future<void>.value();
  }
}

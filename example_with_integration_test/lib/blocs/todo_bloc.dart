import 'package:example_with_integration_test/models/todo_status_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:example_with_integration_test/models/todo_model.dart';
import 'package:example_with_integration_test/repositories/todo_repository.dart';

class TodoBloc {
  final Subject<void> _dataRefresher = BehaviorSubject.seeded(null);
  final Subject<Todo> _newModel = ReplaySubject(maxSize: 1);
  final TodoRepository _repository;
  late final Stream<Iterable<Todo>> _todos;

  Stream<Iterable<Todo>> get todos => _todos;
  Stream<Todo> get newModel => _newModel;

  TodoBloc(this._repository) {
    _newModel.add(_createNewModel());
    _todos = _dataRefresher
        .switchMap((value) => _repository.all())
        .map(
          (items) => items.toList(
            growable: false,
          )..sort(
              (a, b) => b.created.compareTo(a.created),
            ),
        )
        .shareReplay(maxSize: 1);
  }

  Stream<void> add(Todo model) {
    return _repository.add(model).doOnData(
      (_) {
        _newModel.add(_createNewModel());
        _updateTodoItems();
      },
    );
  }

  Stream<void> remove(Todo model) {
    return _repository.delete(model).doOnData(
      (_) {
        _updateTodoItems();
      },
    );
  }

  Stream<void> update(Todo model) {
    return _repository.update(model).doOnData(
      (_) {
        _updateTodoItems();
      },
    );
  }

  void dispose() {
    _dataRefresher.close();
    _repository.dispose();
  }

  void _updateTodoItems() {
    _dataRefresher.add(null);
  }

  Todo _createNewModel() {
    return Todo(
      created: DateTime.now().toUtc(),
      id: Uuid().v4(),
      status: TodoStatus.pending,
      updated: DateTime.now().toUtc(),
    );
  }
}

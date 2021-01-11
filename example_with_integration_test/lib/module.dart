import 'package:example_with_integration_test/widgets/views/home_view.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'blocs/todo_bloc.dart';
import 'repositories/todo_repository.dart';

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<TodoRepository>(
      (i) => TodoRepository(),
      isSingleton: true,
    );

    injector.map<TodoBloc>(
      (i) => TodoBloc(i.get<TodoRepository>()),
    );

    // Views
    injector.map<HomeView>(
      (i) => HomeView(
        blocFactory: () => i.get<TodoBloc>(),
      ),
    );

    return injector;
  }
}

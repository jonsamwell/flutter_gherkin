import 'package:example_with_integration_test/services/external_application_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'module.dart';
import 'widgets/views/home_view.dart';

void main() {
  runApp(
    TodoApp(
      injector: Injector(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  final ExternalApplicationManager? externalApplicationManager;
  final Injector injector;

  TodoApp({
    required this.injector,
    this.externalApplicationManager,
  }) : super() {
    ModuleContainer().initialise(injector);
  }

  @override
  Widget build(BuildContext context) {
    // if the app is in test mode and an ExternalApplicationManager is passed in
    // let the app respond to external changes
    return externalApplicationManager == null
        ? MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: injector.get<HomeView>(),
          )
        : StreamBuilder(
            stream: externalApplicationManager!.applicationReset,
            builder: (ctx, _) {
              return MaterialApp(
                title: 'Todo App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: injector.get<HomeView>(),
              );
            },
          );
  }
}

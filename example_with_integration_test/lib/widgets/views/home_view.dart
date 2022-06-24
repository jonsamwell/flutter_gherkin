import 'package:example_with_integration_test/blocs/todo_bloc.dart';
import 'package:example_with_integration_test/models/todo_model.dart';
import 'package:example_with_integration_test/models/todo_status_enum.dart';
import 'package:example_with_integration_test/widgets/components/add_todo_component.dart';
import 'package:flutter/material.dart';

import '../view_utils_mixin.dart';

class HomeView extends StatefulWidget {
  final TodoBloc Function() blocFactory;

  const HomeView({
    required this.blocFactory,
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState(blocFactory());
}

class _HomeViewState extends State<HomeView> with ViewUtilsMixin {
  final TodoBloc bloc;

  _HomeViewState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: AddTodoComponent(
                    todo: bloc.newModel,
                    onAdded: (todo) {
                      subscribeOnce(bloc.add(todo));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StreamBuilder<Iterable<Todo>>(
                stream: bloc.todos,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isEmpty) {
                      return const Icon(
                        Icons.list,
                        size: 64,
                        color: Colors.black26,
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (ctx, index) {
                          final todo = data.elementAt(index);
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            key: Key(todo.action!),
                            onDismissed: (direction) {
                              subscribeOnce(
                                bloc.remove(todo),
                                onDone: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Todo deleted'),
                                    ),
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              title: Text(
                                todo.action!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      decoration:
                                          todo.status == TodoStatus.complete
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Loading...'),
                    );
                  }
                },
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        key: const Key('scrollable cards'),
                        width: 300,
                        height: 250,
                        child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? Colors.amber
                                    : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                key: Key('Page ${index + 1}'),
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Page ${index + 1}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
}

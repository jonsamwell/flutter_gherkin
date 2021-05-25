import 'package:example_with_integration_test/blocs/todo_bloc.dart';
import 'package:example_with_integration_test/models/todo_model.dart';
import 'package:example_with_integration_test/models/todo_status_enum.dart';
import 'package:example_with_integration_test/widgets/components/add_todo_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.list,
                            size: 64,
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'No todos!',
                              key: const Key('empty'),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ],
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ],
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

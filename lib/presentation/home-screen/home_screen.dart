import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/presentation/home-screen/cubit.dart';
import 'package:todo_cubit/presentation/home-screen/state.dart';
import 'package:todo_cubit/presentation/to-do-screen/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO APP')),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TodosLoaded) {
            final todos = state.todos;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Dismissible(
                    background: Container(color: Colors.red),
                    direction: DismissDirection.endToStart,
                    key: Key(todo.id.toString()),
                    onDismissed: (direction) {
                      direction == DismissDirection.endToStart
                          ? context.read<TodosCubit>().deleteTodo(todo.id)
                          : null;
                    },
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoScreen(todoId: todo.id),
                          ),
                        );
                      },
                      title: Text(todo.title),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete Todo'),
                            content: Text(
                              'Are you sure you want to delete this todo?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            );
          } else if (state is TodosError) {
            return Center(child: Text(state.error));
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: AddTodoWidget(),
    );
  }
}

class AddTodoWidget extends StatelessWidget {
  const AddTodoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextInputWidget(),
                ),
              ),
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({super.key});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Text('Add Todo'),
        TextField(autofocus: true, controller: textController),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            context.read<TodosCubit>().createTodo(title: textController.text);
            Navigator.pop(context);
            textController.clear();
          },
          child: Text('Add'),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_cubit/core/service_locator.dart';
import 'package:todo_cubit/domain/entity/todo.dart';
import 'package:todo_cubit/presentation/to-do-screen/cubit.dart';
import 'package:todo_cubit/presentation/to-do-screen/state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key, required this.todoId});

  final String todoId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TodoCubit>()..getTodo(todoId),
      child: Scaffold(
        appBar: AppBar(title: Text('TODO')),
        body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            return switch (state) {
              TodoLoading() => Center(child: CircularProgressIndicator()),
              TodoLoaded() => Center(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        final cubit = context.read<TodoCubit>();
                        return BlocProvider.value(
                          value: cubit,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: TextInputField(
                              todo: state.todo,
                              context: context,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Text(state.todo.title),
                          Text(
                            '${state.todo.createdAt.day.toString().padLeft(2, '0')}/${state.todo.createdAt.month.toString().padLeft(2, '0')}/${state.todo.createdAt.year}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TodoError() => Center(child: Text(state.error)),
              TodoInitial() => Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

class TextInputField extends StatefulWidget {
  const TextInputField({super.key, required this.todo, required this.context});

  final Todo todo;
  final BuildContext context;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 20,
      children: [
        Center(child: Text('Edit Todo')),
        TextField(controller: textController),
        BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                context.read<TodoCubit>().updateTodo(
                  title: textController.text,
                  todo: widget.todo,
                );

                Navigator.pop(context);
              },
              child: Text('Apply'),
            );
          },
        ),
      ],
    );
  }
}

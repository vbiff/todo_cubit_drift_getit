import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/core/service_locator.dart';
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
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
              TodoError() => Center(child: Text(state.error)),
              TodoInitial() => Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

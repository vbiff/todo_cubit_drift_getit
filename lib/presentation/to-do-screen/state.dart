import 'package:todo_cubit/domain/entity/todo.dart';

sealed class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final Todo todo;

  TodoLoaded({required this.todo});
}

class TodoError extends TodoState {
  final String error;

  TodoError({required this.error});
}

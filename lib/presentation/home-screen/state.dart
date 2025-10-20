import 'package:todo_cubit/domain/entity/todo.dart';

sealed class TodosState {}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo> todos;

  TodosLoaded({required this.todos});
}

class TodosError extends TodosState {
  final String error;

  TodosError({required this.error});
}

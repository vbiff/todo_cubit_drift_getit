import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/domain/entity/todo.dart';
import 'package:todo_cubit/domain/repository/todo_repository.dart';
import 'package:todo_cubit/presentation/to-do-screen/state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._todoRepository) : super(TodoInitial());

  final TodoRepository _todoRepository;

  Future<Todo> getTodo(String id) async {
    emit(TodoLoading());
    try {
      final todo = await _todoRepository.getTodo(id);
      emit(TodoLoaded(todo: todo));
      return todo;
    } catch (e) {
      emit(TodoError(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    emit(TodoLoading());
    try {
      await _todoRepository.deleteTodo(id);
    } catch (e) {
      emit(TodoError(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateTodo({required String title, required Todo todo}) async {
    emit(TodoLoading());
    try {
      final updatedTodo = Todo(
        id: todo.id,
        title: title,
        createdAt: todo.createdAt,
      );
      await _todoRepository.updateTodo(updatedTodo);
      emit(TodoLoaded(todo: updatedTodo));
    } catch (e) {
      emit(TodoError(error: e.toString()));
      rethrow;
    }
  }
}

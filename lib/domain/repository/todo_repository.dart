import 'package:todo_cubit/domain/entity/todo.dart';

abstract class TodoRepository {
  Future<Todo> createTodo(Todo todo);
  Future<Todo> getTodo(String id);
  Future<List<Todo>> getAllTodos();
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}

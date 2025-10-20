import 'package:todo_cubit/data/datasources/local/app_database.dart';
import 'package:todo_cubit/data/datasources/local/extensions/todo_extensions.dart';
import 'package:todo_cubit/domain/entity/todo.dart';
import 'package:todo_cubit/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final AppDatabase _database;

  TodoRepositoryImpl(this._database);

  @override
  Future<Todo> createTodo(Todo todo) async {
    await _database.into(_database.todoTable).insert(todo.toDrift());
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    await (_database.delete(
      _database.todoTable,
    )..where((todo) => todo.id.equals(id))).go();
  }

  @override
  Future<Todo> getTodo(String id) async {
    final todo = _database.select(_database.todoTable)
      ..where((todo) => todo.id.equals(id));
    final row = await todo.getSingle();
    return row.toEntity();
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    final todos = await _database.select(_database.todoTable).get();
    return todos.map((row) => row.toEntity()).toList();
  }
}

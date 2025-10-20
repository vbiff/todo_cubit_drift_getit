import 'package:todo_cubit/data/datasources/local/app_database.dart';
import 'package:todo_cubit/domain/entity/todo.dart';

extension TodoTableDataExtension on TodoTableData {
  Todo toEntity() {
    return Todo(id: id, title: title, createdAt: createdAt);
  }
}

extension TodoEntityExtension on Todo {
  TodoTableCompanion toDrift() {
    return TodoTableCompanion.insert(
      id: id,
      title: title,
      createdAt: createdAt,
    );
  }
}

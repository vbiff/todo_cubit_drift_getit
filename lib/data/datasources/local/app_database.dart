import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_cubit/data/datasources/local/tables/todo_table.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [TodoTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todos.db'));
    return NativeDatabase.createInBackground(file);
  });
}

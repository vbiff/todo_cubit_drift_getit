import 'package:drift/drift.dart';

class TodoTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

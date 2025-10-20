import 'package:get_it/get_it.dart';
import 'package:todo_cubit/data/datasources/local/app_database.dart';
import 'package:todo_cubit/data/repository/todo_repository_impl.dart';
import 'package:todo_cubit/domain/repository/todo_repository.dart';
import 'package:todo_cubit/presentation/home-screen/cubit.dart';
import 'package:todo_cubit/presentation/to-do-screen/cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Repositories
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl<AppDatabase>()),
  );

  //Cubits
  sl.registerFactory(() => TodoCubit(sl<TodoRepository>()));
  sl.registerFactory(() => TodosCubit(sl<TodoRepository>()));
}

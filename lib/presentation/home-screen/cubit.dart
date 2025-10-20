import 'package:bloc/bloc.dart';
import 'package:todo_cubit/domain/entity/todo.dart';
import 'package:todo_cubit/domain/repository/todo_repository.dart';
import 'package:todo_cubit/presentation/home-screen/state.dart';
import 'package:uuid/uuid.dart';

class TodosCubit extends Cubit<TodosState> {
  TodosCubit(this._todoRepository) : super(TodosInitial()) {
    init();
  }

  final TodoRepository _todoRepository;

  Future<void> init() async {
    await getAllTodos();
  }

  Future<List<Todo>> getAllTodos() async {
    emit(TodosLoading());
    try {
      final todos = await _todoRepository.getAllTodos();
      emit(TodosLoaded(todos: todos));
      return todos;
    } catch (e) {
      emit(TodosError(error: e.toString()));
      rethrow;
    }
  }

  Future<void> createTodo({required String title}) async {
    emit(TodosLoading());
    try {
      final todo = Todo(
        id: Uuid().v4(),
        createdAt: DateTime.now(),
        title: title,
      );
      await _todoRepository.createTodo(todo);
      await getAllTodos();
    } catch (e) {
      emit(TodosError(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    emit(TodosLoading());
    try {
      await _todoRepository.deleteTodo(id);
      await getAllTodos();
    } catch (e) {
      emit(TodosError(error: e.toString()));
      rethrow;
    }
  }
}

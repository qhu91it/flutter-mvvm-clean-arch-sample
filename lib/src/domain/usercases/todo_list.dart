import '../entities/entities.dart';
import '../repositories/repositories.dart';

enum TodoListFilter {
  all,
  active,
  completed,
}

abstract class TodoList {
  late List<TodoEntity> todos;

  Future<void> load();
  Future<void> add(String description);
  Future<void> toggle(int id);
  Future<void> edit({required int id, required String description});
  Future<void> remove(TodoEntity target);
}

class TodoListImpl implements TodoList {
  final TodoRepository _todoRepo;
  TodoListImpl(TodoRepository todoRepo) : _todoRepo = todoRepo;

  @override
  List<TodoEntity> todos = [];

  @override
  Future<void> load() async {
    final localTodos = await _todoRepo.getAll();
    todos = localTodos.map((e) => TodoEntity.fromDto(e)).toList();
  }

  @override
  Future<void> add(String description) async {
    final id = await _todoRepo.add(description);
    todos = [
      ...todos,
      TodoEntity(id: id, description: description),
    ];
  }

  @override
  Future<void> toggle(int id) async {
    await _todoRepo.toggle(id);
    todos = [
      for (final todo in todos)
        if (todo.id == id)
          TodoEntity(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  @override
  Future<void> edit({required int id, required String description}) async {
    await _todoRepo.edit(id: id, description: description);
    todos = [
      for (final todo in todos)
        if (todo.id == id)
          TodoEntity(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  @override
  Future<void> remove(TodoEntity target) async {
    await _todoRepo.remove(target.id);
    todos = todos.where((todo) => todo.id != target.id).toList();
  }
}

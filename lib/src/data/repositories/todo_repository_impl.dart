import '../../domain/repositories/repositories.dart';
import '../datasource/datasource.dart';
import '../models/models.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoBox _todoBox;
  TodoRepositoryImpl({required TodoBox todoBox}) : _todoBox = todoBox;

  @override
  Future<List<TodoDto>> getAll() async {
    return await _todoBox.getAll();
  }

  @override
  Future<int> add(String description) async {
    final todo = TodoDto(description: description);
    return _todoBox.put(todo);
  }

  @override
  Future<int> edit({
    required int id,
    required String description,
  }) async {
    TodoDto? todo = await _todoBox.get(id);
    if (todo == null) {
      return -1;
    }
    final updateTodo = TodoDto.update(todo, description);
    return _todoBox.put(updateTodo);
  }

  @override
  Future<bool> remove(int id) {
    return _todoBox.delete(id);
  }

  @override
  Future<int> toggle(int id) async {
    TodoDto? todo = await _todoBox.get(id);
    if (todo == null) {
      return -1;
    }
    final updateTodo = TodoDto.toggle(todo, !todo.completed);
    return _todoBox.put(updateTodo);
  }
}

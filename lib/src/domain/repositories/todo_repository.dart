import '../../data/models/models.dart';

abstract class TodoRepository {
  Future<List<TodoDto>> getAll();
  Future<int> add(String description);
  Future<int> toggle(int id);
  Future<int> edit({required int id, required String description});
  Future<bool> remove(int id);
}

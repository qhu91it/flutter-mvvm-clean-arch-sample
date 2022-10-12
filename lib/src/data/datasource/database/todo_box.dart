import 'package:objectbox/objectbox.dart';

import '../../models/models.dart';
import 'base_box.dart';

abstract class TodoBox {
  Future<int> put(TodoDto todo);
  Future<bool> delete(int id);
  Future<TodoDto?> get(int id);
  Future<List<TodoDto>> getAll();
}

class TodoBoxImpl extends BaseBox implements TodoBox {
  TodoBoxImpl() : super(boxName: 'todoBox');

  @override
  Future<int> put(TodoDto todo) async {
    final store = await lazyStore;
    Box<TodoDto> box = store.box<TodoDto>();
    return box.put(todo);
  }

  @override
  Future<bool> delete(int id) async {
    final store = await lazyStore;
    Box<TodoDto> box = store.box<TodoDto>();
    return box.remove(id);
  }

  @override
  Future<TodoDto?> get(int id) async {
    final store = await lazyStore;
    Box<TodoDto> box = store.box<TodoDto>();
    return box.get(id);
  }

  @override
  Future<List<TodoDto>> getAll() async {
    final store = await lazyStore;
    Box<TodoDto> box = store.box<TodoDto>();
    return box.getAll();
  }
}

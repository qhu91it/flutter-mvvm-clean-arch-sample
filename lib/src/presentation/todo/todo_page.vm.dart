import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usercases/usercases.dart';
import '../../foundation/helper/helper.dart';
import '../../injected.dart';

class TodoState {
  final List<TodoEntity> todos;
  final TodoListFilter filter;
  final int uncompletedTodosCount;

  const TodoState({
    this.todos = const [],
    this.filter = TodoListFilter.all,
    this.uncompletedTodosCount = 0,
  });
}

class TodoViewModel extends StateNotifier<TodoState> {
  final TodoList _todoList;
  TodoViewModel({required TodoList todoList})
      : _todoList = todoList,
        super(const TodoState()) {
    init();
  }

  final TextEditingController todoController = TextEditingController();
  final FocusNode todoFocusNode = FocusNode();
  TodoEntity? currentTodo;

  Future<void> init() async {
    await _todoList.load();
    loadWith(TodoListFilter.all);
  }

  void loadWith(TodoListFilter filter) {
    List<TodoEntity> todos;
    switch (filter) {
      case TodoListFilter.completed:
        todos = _todoList.todos.where((todo) => todo.completed).toList();
        break;
      case TodoListFilter.active:
        todos = _todoList.todos.where((todo) => !todo.completed).toList();
        break;
      case TodoListFilter.all:
        todos = _todoList.todos;
        break;
    }
    final uncompletedTodosCount =
        _todoList.todos.where((todo) => !todo.completed).length;
    state = TodoState(
      todos: todos,
      filter: filter,
      uncompletedTodosCount: uncompletedTodosCount,
    );
  }

  void onUnfocus() {
    if (currentTodo != null) {
      todoController.clear();
    }
    currentTodo = null;
    todoFocusNode.unfocus();
  }

  void onFilter(TodoListFilter filter) {
    loadWith(filter);
  }

  Future<void> onSubmitted(String value) async {
    if (currentTodo != null) {
      await _todoList.edit(
        id: currentTodo!.id,
        description: todoController.text,
      );
      currentTodo = null;
    } else {
      await _todoList.add(value);
    }
    todoController.clear();
    loadWith(state.filter);
  }

  void onEdit(TodoEntity todo) {
    currentTodo = todo;
    todoController.text = todo.description;
    todoFocusNode.requestFocus();
    loadWith(state.filter);
  }

  Future<void> onRemove(int index) async {
    final todo = state.todos[index];
    await _todoList.remove(todo);
    if (currentTodo != null && currentTodo!.id == todo.id) {
      currentTodo = null;
      todoController.clear();
    }
    loadWith(state.filter);
  }

  Future<void> onToggle(int id) async {
    await _todoList.toggle(id);
    loadWith(state.filter);
  }

  @override
  void dispose() {
    todoController.dispose();
    todoFocusNode.dispose();
    currentTodo = null;
    logD('Dispose $runtimeType');
    super.dispose();
  }
}

final todoViewModelProvider =
    StateNotifierProvider.autoDispose<TodoViewModel, TodoState>((ref) {
  final todoList = ref.read(todoListProvider);
  return TodoViewModel(todoList: todoList);
});

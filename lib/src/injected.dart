import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasource/datasource.dart';
import 'data/repositories/repositories.dart';
import 'domain/repositories/repositories.dart';
import 'domain/usercases/usercases.dart';
import 'foundation/helper/helper.dart';
import 'foundation/themes/theme.dart';

/// data source
final todoBoxProvider = Provider<TodoBox>((ref) {
  return TodoBoxImpl();
});

/// repositories
final todoRepoProvider = Provider<TodoRepository>((ref) {
  final todoBox = ref.watch(todoBoxProvider);
  return TodoRepositoryImpl(todoBox: todoBox);
});

final postRepoProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(
    getPostsApi: GetPostsApi(),
    postPostApi: PostPostApiImpl(),
  );
});

/// foundation
final appThemeModeProvider =
    StateNotifierProvider<StateController<ThemeMode>, ThemeMode>(
  (ref) => StateController(ThemeMode.light),
);

final appThemeProvider = Provider<AppTheme>(
  (ref) {
    final mode = ref.watch(appThemeModeProvider);
    switch (mode) {
      case ThemeMode.dark:
        return AppTheme.dark();
      case ThemeMode.light:
      default:
        return AppTheme.light();
    }
  },
);

/// user cases
final appOrientationProvider = StateProvider<CheckOrientation>((ref) {
  return CheckOrientationImpl();
});

final todoListProvider = Provider<TodoList>((ref) {
  final todoRepo = ref.watch(todoRepoProvider);
  return TodoListImpl(todoRepo);
});

final postListProvider = Provider<PostList>((ref) {
  final postRepo = ref.watch(postRepoProvider);
  return PostListImpl(postRepo: postRepo);
});

/// helper
final appLifecycleProvider = StateProvider<AppLifecycleState>((ref) {
  return AppLifecycleState.detached;
});

final toastProvider = Provider<ToastHelper>((ref) {
  final theme = ref.watch(appThemeProvider);
  return ToastHelperImpl(theme: theme);
});

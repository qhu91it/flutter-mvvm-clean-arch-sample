import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usercases/usercases.dart';
import '../../foundation/common/common.dart';
import '../../foundation/themes/theme.dart';
import '../../injected.dart';
import 'todo_page.vm.dart';

final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.watch(todoViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => vm.onUnfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.todoPageTitle).tr(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Title(theme: theme),
                TodoTextfield(vm: vm),
                const SizedBox(height: 42),
                const Toolbar(),
                const SizedBox(height: 10),
                const TodoItemList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoTextfield extends StatelessWidget {
  final TodoViewModel vm;
  const TodoTextfield({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: addTodoKey,
      focusNode: vm.todoFocusNode,
      controller: vm.todoController,
      decoration: InputDecoration(
        labelText: LocaleKeys.todoPlaceholder.tr(),
      ),
      onSubmitted: (value) => vm.onSubmitted(value),
    );
  }
}

class Toolbar extends ConsumerWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.watch(todoViewModelProvider.notifier);
    final filter = ref.watch(todoViewModelProvider.select((_) => _.filter));

    Color? textColorFor(TodoListFilter value) {
      return filter == value
          ? theme.appColors.primary
          : theme.appColors.secondary;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Consumer(
              builder: (_, ref, __) {
                final uncompletedTodosCount = ref.watch(todoViewModelProvider
                    .select((_) => _.uncompletedTodosCount));
                return Text(
                  LocaleKeys.todoItemsLeft,
                  overflow: TextOverflow.ellipsis,
                ).tr(args: ['$uncompletedTodosCount']);
              },
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: LocaleKeys.todoAllTodos.tr(),
            child: TextButton(
              onPressed: () => vm.onFilter(TodoListFilter.all),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
              ),
              child: Text(LocaleKeys.todoAll).tr(),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: LocaleKeys.todoUncompletedTodos.tr(),
            child: TextButton(
              onPressed: () => vm.onFilter(TodoListFilter.active),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.active),
                ),
              ),
              child: Text(LocaleKeys.todoActive).tr(),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: LocaleKeys.todoCompletedTodos.tr(),
            child: TextButton(
              onPressed: () => vm.onFilter(TodoListFilter.completed),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.completed),
                ),
              ),
              child: Text(LocaleKeys.todoCompleted).tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItemList extends ConsumerWidget {
  const TodoItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.watch(todoViewModelProvider.notifier);
    final todos = ref.watch(todoViewModelProvider.select((_) => _.todos));

    if (todos.isEmpty) {
      return SizedBox(
        width: 0.7.sw,
        height: 0.7.sw,
        child: EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_3,
          title: LocaleKeys.todoNoItems.tr(),
          subTitle: LocaleKeys.todoNoItemsSub.tr(),
          titleTextStyle: TextStyle(
            fontSize: 22,
            color: theme.appColors.secondary,
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 14,
            color: theme.appColors.secondary,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: todos.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, i) {
        return Dismissible(
          key: ValueKey(todos[i].id),
          onDismissed: (_) => vm.onRemove(i),
          child: TodoItem(todo: todos[i]),
        );
      },
    );
  }
}

class Title extends StatelessWidget {
  final AppTheme theme;
  const Title({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: theme.appColors.primary,
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class TodoItem extends ConsumerWidget {
  final TodoEntity todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.watch(todoViewModelProvider.notifier);

    return Material(
      elevation: 6,
      child: ListTile(
        onTap: () => vm.onEdit(todo),
        leading: Checkbox(
          activeColor: theme.appColors.primary,
          checkColor: theme.appColors.primaryVariant,
          value: todo.completed,
          onChanged: (value) => vm.onToggle(todo.id),
        ),
        title: Text(todo.description),
      ),
    );
  }
}

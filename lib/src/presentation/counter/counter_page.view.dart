import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../foundation/common/common.dart';
import '../../injected.dart';
import 'counter_page.vm.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.watch(counterViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.counterPageTitle).tr()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              LocaleKeys.counterNoti,
              textAlign: TextAlign.center,
            ).tr(),
            Consumer(
              builder: (_, ref, __) {
                final count =
                    ref.watch(counterViewModelProvider.select((_) => _.count1));
                return ColoredBox(
                  color: vm.randomColor(),
                  child: Text(
                    '$count',
                    style: theme.textTheme.h90.copyWith(
                      color: vm.randomColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            Consumer(
              builder: (_, ref, __) {
                final count =
                    ref.watch(counterViewModelProvider.select((_) => _.count2));
                return ColoredBox(
                  color: vm.randomColor(),
                  child: Text(
                    '$count',
                    style: theme.textTheme.h90.copyWith(
                      color: vm.randomColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () => vm.increment(),
            tooltip: LocaleKeys.counterIncrement.tr(args: ["1"]),
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () => vm.increment2(),
            tooltip: LocaleKeys.counterIncrement.tr(args: ["2"]),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

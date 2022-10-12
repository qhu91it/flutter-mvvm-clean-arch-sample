import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../r.g.dart';
import '../../foundation/common/common.dart';
import '../../foundation/helper/helper.dart';
import '../../injected.dart';
import 'home_page.vm.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final vm = ref.read(homePageViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.homePageTitle).tr(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                LocaleKeys.homeChangeLanguage,
                style: theme.textTheme.h60,
              ).tr(),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => context.setLocale(Constants.locales[0]),
                    icon: Image(image: R.image.english()),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => context.setLocale(Constants.locales[1]),
                    icon: Image(image: R.image.vietnam()),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                LocaleKeys.homeDefineEnv,
                style: theme.textTheme.h60,
              ).tr(),
              Text(
                LocaleKeys.homeDefineEnvAppName,
                style: theme.textTheme.h40,
              ).tr(args: [Constants.appName]),
              Text(
                LocaleKeys.homeDefineEnvAppSuffix,
                style: theme.textTheme.h40,
              ).tr(args: [Constants.appSuffix]),
              TextButton(
                onPressed: () => context.push(Screen.counter),
                child: Text(LocaleKeys.homeGotoPage).tr(args: ["Counter"]),
              ),
              TextButton(
                onPressed: () => context.push(Screen.posts),
                child: Text(LocaleKeys.homeGotoPage).tr(args: ["Post"]),
              ),
              TextButton(
                onPressed: () => context.push(Screen.todoList),
                child: Text(LocaleKeys.homeGotoPage).tr(args: ["Todo"]),
              ),
              const SizedBox(height: 40),
              Text(
                LocaleKeys.homePrintLog,
                style: theme.textTheme.h60,
              ).tr(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => vm.showLog(LogLevel.debug),
                    child: const Text('DEBUG'),
                  ),
                  TextButton(
                    onPressed: () => vm.showLog(LogLevel.info),
                    child: const Text('INFO'),
                  ),
                  TextButton(
                    onPressed: () => vm.showLog(LogLevel.warn),
                    child: const Text('WARN'),
                  ),
                  TextButton(
                    onPressed: () => vm.showLog(LogLevel.error),
                    child: const Text('ERROR'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

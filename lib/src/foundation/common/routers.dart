import 'package:flutter/material.dart';

import '../../presentation/presentation.dart';

class NavigationSetting {
  final bool presentModally;
  final Object? arguments;

  NavigationSetting({this.presentModally = false, this.arguments});
}

class Screen {
  static const String home = "/home";
  static const String counter = "/counter";
  static const String posts = "/posts";
  static const String todoList = "/todo_list";
}

class Routers {
  factory Routers() {
    return _singleton;
  }
  Routers._internal();
  static final Routers _singleton = Routers._internal();

  Route generator(RouteSettings settings) {
    switch (settings.name) {
      case Screen.home:
        return _buildRoute(settings, const HomePage());
      case Screen.counter:
        return _buildRoute(settings, const CounterPage());
      case Screen.posts:
        return _buildRoute(settings, const PostPage());
      case Screen.todoList:
        return _buildRoute(settings, const TodoPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  PageRoute _buildRoute(RouteSettings settings, Widget builder) {
    final args = settings.arguments as NavigationSetting;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => builder,
      fullscreenDialog: args.presentModally,
    );
  }
}

extension BuildContextExt on BuildContext {
  bool pop([dynamic result]) {
    if (Navigator.canPop(this)) {
      Navigator.pop(this, result);
      return true;
    }
    return false;
  }

  bool popToRoot() {
    if (Navigator.canPop(this)) {
      Navigator.popUntil(this, (route) => route.isFirst);
      return true;
    }
    return false;
  }

  Future<T?> push<T extends dynamic>(
    String name, {
    bool presentModally = false,
    Object? arguments,
  }) {
    final args = NavigationSetting(
      presentModally: presentModally,
      arguments: arguments,
    );
    return Navigator.pushNamed<T>(this, name, arguments: args);
  }

  Future<T?> pushReplacement<T extends dynamic, TO extends dynamic>(
    String name, {
    Object? arguments,
  }) {
    final args = NavigationSetting(
      presentModally: false,
      arguments: arguments,
    );
    return Navigator.pushReplacementNamed<T, TO>(
      this,
      name,
      arguments: args,
    );
  }
}

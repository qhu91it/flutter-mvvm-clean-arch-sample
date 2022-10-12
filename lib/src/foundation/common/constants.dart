import 'package:flutter/material.dart';

enum Env { dev, prod }

class Constants {
  const Constants._({required this.jsonplaceholderHost});

  factory Constants.of() {
    switch (env) {
      case Env.dev:
        return Constants._dev();
      case Env.prod:
      default:
        return Constants._prod();
    }
  }

  factory Constants._dev() {
    return const Constants._(
      jsonplaceholderHost: 'jsonplaceholder.typicode.com',
    );
  }

  factory Constants._prod() {
    return const Constants._(
      jsonplaceholderHost: 'jsonplaceholder.typicode.com',
    );
  }

  final String jsonplaceholderHost;

  /// Languages
  static final locales = [const Locale('en', 'US'), const Locale('vi', 'VN')];

  /// Environment
  static Env get env {
    const env = String.fromEnvironment('ENV', defaultValue: "prod");
    return Env.values.byName(env);
  }

  static Color get envColor {
    switch (env) {
      case Env.dev:
        return Colors.red.withOpacity(0.6);
      case Env.prod:
        return Colors.green.withOpacity(0.6);
    }
  }

  static const appName =
      String.fromEnvironment('DEFINE_APP_NAME', defaultValue: 'mvvmTemplate');
  static const appSuffix = String.fromEnvironment('DEFINE_APP_SUFFIX');

  /// Whether to enable Device Preview
  static bool get enablePreview =>
      const bool.fromEnvironment('PREVIEW', defaultValue: false);
}

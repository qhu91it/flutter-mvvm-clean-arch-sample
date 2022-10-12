import 'dart:developer' as developer;

import 'package:flutter/material.dart';

enum LogLevel { all, debug, info, warn, error, off }

int _logLevel = LogLevel.all.raw;
int _errorTrackLine = 0;

extension _LogLevelExt on LogLevel {
  int get raw {
    switch (this) {
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 1;
      case LogLevel.warn:
        return 2;
      case LogLevel.error:
        return 3;
      case LogLevel.off:
        return 4;
      default:
        return -1;
    }
  }

  String get name {
    switch (this) {
      case LogLevel.debug:
        return 'D';
      case LogLevel.info:
        return 'I';
      case LogLevel.warn:
        return 'W';
      case LogLevel.error:
        return 'E';
      default:
        return '';
    }
  }

  String color(String msg) {
    switch (this) {
      case LogLevel.debug:
        return '\x1B[34m$msg\x1B[0m';
      case LogLevel.info:
        return '\x1B[32m$msg\x1B[0m';
      case LogLevel.warn:
        return '\x1B[33m$msg\x1B[0m';
      case LogLevel.error:
        return '\x1B[31m$msg\x1B[0m';
      default:
        return '\x1B[37m$msg\x1B[0m';
    }
  }
}

String _logPrint(LogLevel level, Object? message, StackTrace stackTrace,
    [int maxLine = 0]) {
  final now = DateTime.now();
  final msg = '${now.toString()} [${level.name}] ${message.toString()}';
  Iterable<String> lines = stackTrace.toString().trimRight().split('\n');
  String line = lines.toList()[1];
  final i = line.indexOf('package:');
  if (maxLine > 0) {
    lines = lines.take(maxLine + (i < 0 ? 2 : 1) + 1);
    final ls = lines.toList()..removeRange(0, i < 0 ? 2 : 1);
    final l = ls.toList().map((e) {
      final x = e.split(' ');
      final i = int.tryParse(x.first.substring(1));
      if (i != null) {
        x.replaceRange(0, 1, ['#${i - 1}']);
      }
      return x.join(' ');
    }).toList();
    return FlutterError.defaultStackFilter(l)
        .join('\n')
        .replaceAll('packages/', 'package:')
        .replaceRange(0, 2, level.color(msg));
  } else {
    final list = line.split(" ");
    return '${level.color(msg)} ${list.last}';
  }
}

void setLogLevel(LogLevel level, {int errorTrackLine = 0}) {
  _logLevel = level.raw;
  _errorTrackLine = errorTrackLine;
}

// Log level: INFO
void logI(Object? msg, [int maxLine = 0]) {
  const level = LogLevel.info;
  if (_logLevel > level.index) {
    return;
  }
  final stackTrace = StackTrace.current;
  developer.log(_logPrint(level, msg, stackTrace, maxLine));
}

// Log level: DEBUG
void logD(Object? msg, [int maxLine = 0]) {
  const level = LogLevel.debug;
  if (_logLevel > level.index) {
    return;
  }
  final stackTrace = StackTrace.current;
  developer.log(_logPrint(level, msg, stackTrace, maxLine));
}

// Log level: WARNING
void logW(Object? msg, [int maxLine = 0]) {
  const level = LogLevel.warn;
  if (_logLevel > level.index) {
    return;
  }
  final line =
      maxLine == 0 || maxLine < _errorTrackLine ? _errorTrackLine : maxLine;
  final stackTrace = StackTrace.current;
  developer.log(_logPrint(level, msg, stackTrace, line));
}

// Log level: ERROR
void logE(Object? msg, [int maxLine = 0]) {
  const level = LogLevel.error;
  if (_logLevel > level.index) {
    return;
  }
  final line =
      maxLine == 0 || maxLine < _errorTrackLine ? _errorTrackLine : maxLine;
  final stackTrace = StackTrace.current;
  developer.log(_logPrint(level, msg, stackTrace, line));
}

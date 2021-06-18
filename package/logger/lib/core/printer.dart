import 'dart:convert';

import '../logger.dart';
import 'log_adapter.dart';

abstract class Printer {
  void addAdapter(LogAdapter adapter);

  void clearLogAdapters();

  void t(String? tag);

  void log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  });

  void d(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag});

  void e(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag});

  void w(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag});

  void i(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag});

  void v(dynamic message, {dynamic error, StackTrace? stackTrace, String? tag});

  void json(String? json, {String? tag});

  void xml(String? xml, {String? tag});
}

class LoggerPrinter extends Printer {
  static const int JSON_INDENT = 2;

  List<LogAdapter> _logAdapters = [];

  String? _globalTag;

  @override
  void addAdapter(LogAdapter adapter) {
    _logAdapters.add(adapter);
  }

  @override
  void clearLogAdapters() {
    _logAdapters.clear();
  }

  @override
  void t(String? tag) {
    _globalTag = tag;
  }

  @override
  void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(
      LogLevel.debug,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  @override
  void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  @override
  void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(
      LogLevel.info,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  @override
  void v(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(
      LogLevel.verbose,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  @override
  void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    log(
      LogLevel.warning,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  @override
  void log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (message == null || message.isEmpty) {
      message = 'Empty / Null Message';
    }
    for (LogAdapter adapter in _logAdapters) {
      if (adapter.isLoggable(level, tag)) {
        adapter.log(level, tag ?? _globalTag, message, error, stackTrace);
      }
    }
  }

  @override
  void json(String? json, {String? tag}) {
    if (json == null || json.isEmpty) {
      e("Empty / Null Json", tag: tag);
      return;
    }
    try {
      var decodedJson = jsonDecode(json);
      var spaces = ' ' * JSON_INDENT;
      var encoder = JsonEncoder.withIndent(spaces);
      String prettyJson = encoder.convert(decodedJson);
      i(prettyJson, tag: tag);
    } catch (error) {
      e("Invalid Json");
    }
  }

  /// todo 有空再实现
  @override
  void xml(String? xml, {String? tag}) {}
}

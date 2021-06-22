library logger;

import 'core/log_adapter.dart';
import 'core/printer.dart';

export 'core/log_adapter.dart';
export 'core/printer.dart';

class Logger {
  static Printer _printer = LoggerPrinter();

  Logger._();

  static void printer(Printer printer) {
    Logger._printer = printer;
  }

  static void addLogAdapter(LogAdapter adapter) {
    _printer.addAdapter(adapter);
  }

  static void clearLogAdapters() {
    _printer.clearLogAdapters();
  }

  /// 设置全局tag
  static void t(String? tag) {
    _printer.t(tag);
  }

  static void log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.log(
      level,
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );
  }

  static void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.d(message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.e(message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.i(message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void v(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.v(message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _printer.w(message, error: error, stackTrace: stackTrace, tag: tag);
  }

  /// Formats the given json content and print it
  static void json(String? json, {String? tag}) {
    _printer.json(json, tag: tag);
  }

  /// Formats the given xml content and print it
  static void xml(String? xml, {String? tag}) {
    _printer.xml(xml, tag: tag);
  }
}

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

import '../logger.dart';
import 'format_strategy.dart';

abstract class LogAdapter {
  bool isLoggable(LogLevel level, String? tag);

  void log(
    LogLevel level,
    String? tag,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  );
}

class LoggerAdapter extends LogAdapter {
  final FormatStrategy formatStrategy;

  LoggerAdapter({this.formatStrategy = const DefaultFormatStrategy()});

  @override
  bool isLoggable(LogLevel level, String? tag) {
    return true;
  }

  @override
  void log(
    LogLevel level,
    String? tag,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    formatStrategy.log(level, tag, message, error, stackTrace);
  }
}

class NoLoggerAdapter extends LogAdapter {
  @override
  bool isLoggable(LogLevel level, String? tag) {
    return false;
  }

  @override
  void log(
    LogLevel level,
    String? tag,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  ) {}
}

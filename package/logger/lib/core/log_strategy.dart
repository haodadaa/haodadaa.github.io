import 'package:flutter/widgets.dart';

abstract class LogStrategy {
  const LogStrategy();

  void log(List<String> messageLines);
}

class DebugPrintLogStrategy extends LogStrategy {
  const DebugPrintLogStrategy() : super();

  @override
  void log(List<String> messageLines) {
    messageLines.forEach(debugPrint);
  }
}

class PrintLogStrategy extends LogStrategy {
  const PrintLogStrategy() : super();

  @override
  void log(List<String> messageLines) {
    messageLines.forEach(print);
  }
}

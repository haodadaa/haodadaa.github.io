import 'dart:convert';

import '../logger.dart';
import '../support/ansi_color.dart';
import 'log_strategy.dart';

abstract class FormatStrategy {
  const FormatStrategy();

  void log(
    LogLevel level,
    String? tag,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  );
}

class DefaultFormatStrategy extends FormatStrategy {
  static const String _topLeftCorner = '┌';
  static const String _bottomLeftCorner = '└';
  static const String _middleCorner = '├';
  static const String _horizontalLine = '│';
  static const String _doubleDivider =
      "────────────────────────────────────────────────────────";
  static const String _singleDivider =
      "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄";
  static const String _topBorder =
      _topLeftCorner + _doubleDivider + _doubleDivider;
  static const String _bottomBorder =
      _bottomLeftCorner + _doubleDivider + _doubleDivider;
  static const String _middleBorder =
      _middleCorner + _singleDivider + _singleDivider;

  static final Map<LogLevel, AnsiColor> _levelColors = {
    LogLevel.verbose: AnsiColor()..gray(level: 0.5),
    LogLevel.debug: AnsiColor(),
    LogLevel.info: AnsiColor()..green(bold: true),
    LogLevel.warning: AnsiColor()..rgb(r: 1, g: 0.4, b: 0),
    LogLevel.error: AnsiColor()..rgb(r: 1, g: 0, b: 0),
  };

  /// Matches a stacktrace line as generated on Android/iOS devices.
  /// For example:
  /// #1      Logger.log (package:logger/src/logger.dart:115:29)
  static final _deviceStackTraceRegex =
      RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  /// Matches a stacktrace line as generated by Flutter web.
  /// For example:
  /// packages/logger/src/printers/pretty_printer.dart 91:37
  static final _webStackTraceRegex =
      RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  /// Matches a stacktrace line as generated by browser Dart.
  /// For example:
  /// dart:sdk_internal
  /// package:logger/src/logger.dart
  static final _browserStackTraceRegex =
      RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  final int? errorMethodCount;
  final int methodOffset;
  final bool showThreadInfo;
  final LogStrategy logStrategy;

  const DefaultFormatStrategy({
    this.errorMethodCount,
    this.methodOffset = 0,
    this.showThreadInfo = false,
    this.logStrategy = const DebugPrintLogStrategy(),
  }) : super();

  @override
  void log(
    LogLevel level,
    String? tag,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    String? formatTag = _formatTag(tag);

    String messageStr = _formatMessage(message);

    String result = '';
    result = _addTopBorder(result);

    /// Tag
    if (formatTag != null) {
      result = _addContent(result, formatTag);
      result = _addDivider(result);
    }

    /// error
    if (error != null) {
      result = _addContent(result, error.toString());
      result = _addDivider(result);
    }

    /// error StackTrace
    if (stackTrace != null) {
      result = _addContent(
        result,
        _formatStackTrace(stackTrace, errorMethodCount) ??
            'Parser StackTrace Failed',
      );
      result = _addDivider(result);
    }

    /// message
    result = _addContent(result, messageStr);
    result = _addBottomBorder(result);

    /// 将完整字符串分割成多行分别打印
    List<String> lines = result.split('\n');
    logStrategy.log(lines.map<String>((e) => _levelColors[level]!(e)).toList());
  }

  String? _formatTag(String? logTag) {
    if (logTag == null || logTag.isEmpty) {
      return null;
    }
    return logTag;
  }

  String _formatMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', _toEncodeFallback);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  Object _toEncodeFallback(dynamic object) {
    return object.toString();
  }

  String _addTopBorder(String content) {
    return content + _topBorder + '\n';
  }

  String _addDivider(String content) {
    return content + _middleBorder + '\n';
  }

  String _addBottomBorder(String content) {
    return content + _bottomBorder;
  }

  String _addContent(String content, String message) {
    final pattern = RegExp('.{1,1024}');
    for (RegExpMatch match in pattern.allMatches(message)) {
      content = content + _horizontalLine + ' ' + (match.group(0) ?? '') + '\n';
    }
    return content;
  }

  String? _formatStackTrace(StackTrace stackTrace, int? methodCount) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line) ||
          _discardBrowserStacktraceLine(line) ||
          line.isEmpty) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      count++;
      if (methodCount != null && count == methodCount) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('packages/logger') ||
        match.group(1)!.startsWith('dart-sdk/lib');
  }

  bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('package:logger') ||
        match.group(1)!.startsWith('dart:');
  }
}

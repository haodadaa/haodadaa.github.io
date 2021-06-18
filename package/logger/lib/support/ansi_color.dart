// import 'support_ansi.dart'
//     if (dart.library.io) 'support_ansi_io.dart'
//     if (dart.library.html) 'support_ansi_web.dart';

// bool ansiColorDisabled = !supportsAnsiColor;
bool ansiColorDisabled = false;

/// 参考链接
/// https://github.com/google/ansicolor-dart
/// https://qiufeng.blue/node/color.html#_3-4-bit
class AnsiColor {
  int _fColor = -1;
  int _bColor = -1;
  String _pen = '';
  bool _dirty = false;

  String call(Object msg) => wrap(msg);

  @override
  String toString() {
    if (ansiColorDisabled) return '';
    if (!_dirty) return _pen;

    final sb = StringBuffer();
    if (_fColor != -1) {
      sb.write('${ansiEscape}38;5;${_fColor}m');
    }

    if (_bColor != -1) {
      sb.write('${ansiEscape}48;5;${_bColor}m');
    }

    _dirty = false;
    _pen = sb.toString();
    return _pen;
  }

  String get down => '${this}';

  String get up => ansiColorDisabled ? '' : ansiDefault;

  /// 使用 ansi color 包裹当前内容
  String wrap(Object msg) => '${this}$msg$up';

  /// 0-7 普通颜色 bold 8-15 高强度色彩
  void black({bool bg = false, bool bold = false}) => _std(0, bold, bg);

  void red({bool bg = false, bool bold = false}) => _std(1, bold, bg);

  void green({bool bg = false, bool bold = false}) => _std(2, bold, bg);

  void yellow({bool bg = false, bool bold = false}) => _std(3, bold, bg);

  void blue({bool bg = false, bool bold = false}) => _std(4, bold, bg);

  void magenta({bool bg = false, bool bold = false}) => _std(5, bold, bg);

  void cyan({bool bg = false, bool bold = false}) => _std(6, bold, bg);

  void white({bool bg = false, bool bold = false}) => _std(7, bold, bg);

  /// 16 - 231 216色
  void rgb({num r = 1.0, num g = 1.0, num b = 1.0, bool bg = false}) => xterm(
      (r.clamp(0.0, 1.0) * 5).toInt() * 36 +
          (g.clamp(0.0, 1.0) * 5).toInt() * 6 +
          (b.clamp(0.0, 1.0) * 5).toInt() +
          16,
      bg: bg);

  /// 232-255 白到黑，24阶灰阶色彩
  void gray({num level = 1.0, bool bg = false}) =>
      xterm(232 + (level.clamp(0.0, 1.0) * 23).round(), bg: bg);

  void _std(int color, bool bold, bool bg) =>
      xterm(color + (bold ? 8 : 0), bg: bg);

  /// Directly index the xterm 256 color palette.
  void xterm(int color, {bool bg = false}) {
    _dirty = true;
    final c = color < 0
        ? 0
        : color > 255
            ? 255
            : color;
    if (bg) {
      _bColor = c;
    } else {
      _fColor = c;
    }
  }

  void reset() {
    _dirty = false;
    _pen = '';
    _bColor = _fColor = -1;
  }
}

const ansiEscape = '\x1B[';

const ansiDefault = '${ansiEscape}0m';

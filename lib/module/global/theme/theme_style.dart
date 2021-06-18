import 'dart:ui';

import 'package:flutter/material.dart';

/// 所有属性均不能为空
class ThemeStyle {
  Color backgroundColor;
  Color primaryColor;
  Color selectColor;

  @protected
  ThemeStyle({
    required this.backgroundColor,
    required this.primaryColor,
    required this.selectColor,
  });

  ThemeStyle.dark({
    this.backgroundColor = const Color(0xDD000000),
    this.primaryColor = const Color(0xFF6897BB),
    this.selectColor = const Color(0xDDFFFFFF),
  });

  ThemeStyle.light({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.primaryColor = const Color(0xFF6897BB),
    this.selectColor = const Color(0xFFFF00FF),
  });

  static ThemeStyle lerp(ThemeStyle a, ThemeStyle b, double t) {
    return ThemeStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t)!,
      selectColor: Color.lerp(a.selectColor, b.selectColor, t)!,
    );
  }
}

/// begin , end 均不能为null
class ThemeStyleTween extends Tween<ThemeStyle> {
  ThemeStyleTween({required ThemeStyle begin, required ThemeStyle end})
      : super(begin: begin, end: end);

  @override
  ThemeStyle lerp(double t) => ThemeStyle.lerp(begin!, end!, t);
}

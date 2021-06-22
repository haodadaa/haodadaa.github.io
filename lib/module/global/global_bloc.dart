import 'package:blog/core/extension/num.dart';
import 'package:blog/module/global/theme/theme_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:blog/module/global/app_ext.dart';

enum AppTheme {
  light,
  dark,
}

enum AppLanguage {
  sc,
  tc,
  en,
}

enum AppTextStyle {
  normal,
  red,
}

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final TickerProvider _tickerProvider;

  AnimationController? _themeAnimController;
  Animation<ThemeStyle>? _themeAnim;

  AppTheme _currentAppTheme = AppTheme.light;

  GlobalBloc(this._tickerProvider) : super(DefaultGlobal());

  @override
  Stream<GlobalState> mapEventToState(event) async* {
    if (event is SwitchAppTheme || event is ChangeAppTheme) {
      ThemeStyle themeStyle;
      AppTheme newAppTheme;
      if (event is SwitchAppTheme) {
        switch (_currentAppTheme) {
          case AppTheme.light:
            newAppTheme = AppTheme.dark;
            break;
          case AppTheme.dark:
            newAppTheme = AppTheme.light;
            break;
        }
      } else {
        newAppTheme = (event as ChangeAppTheme).appTheme;
      }
      switch (newAppTheme) {
        case AppTheme.light:
          themeStyle = lightTheme;
          break;
        case AppTheme.dark:
          themeStyle = darkTheme;
          break;
      }
      _currentAppTheme = newAppTheme;

      _themeAnimController?.stop();
      _themeAnimController?.dispose();

      _themeAnimController = AnimationController(
        vsync: _tickerProvider,
        duration: 500.milliseconds,
      );
      _themeAnimController?.addListener(() {
        ThemeStyle? themeStyle = _themeAnim?.value;
        if (themeStyle != null) {
          add(_AnimateThemeStyle(themeStyle));
        }
      });
      _themeAnim = ThemeStyleTween(
        begin: state.themeStyle,
        end: themeStyle,
      ).animate(
        CurvedAnimation(
          parent: _themeAnimController!,
          curve: Curves.easeOutQuart,
        ),
      );
      _themeAnimController?.forward();
    }
    if (event is _AnimateThemeStyle) {
      yield AppGlobal(locale: state.locale, themeStyle: event.themeStyle);
    }
    if (event is ChangeAppLanguage) {
      Locale locale;
      switch (event.appLanguage) {
        case AppLanguage.sc:
          locale = localeSC;
          break;
        case AppLanguage.tc:
          locale = localeTC;
          break;
        case AppLanguage.en:
          locale = localeEN;
          break;
      }
      yield AppGlobal(locale: locale, themeStyle: state.themeStyle);
    }
    if (event is ChangeAppTextStyle) {
      TextStyle textStyle;
      switch (event.appTextStyle) {
        case AppTextStyle.normal:
          textStyle = const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
            fontFamilyFallback: ["PingFang SC", "Heiti SC"],
          );
          break;
        case AppTextStyle.red:
          textStyle = const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.overline,
            fontFamilyFallback: ["PingFang SC", "Heiti SC"],
          );
          break;
      }
      yield state.appGlobal(textStyle: textStyle);
    }
  }
}

class GlobalEvent {}

class SwitchAppTheme extends GlobalEvent {}

class ChangeAppTheme extends GlobalEvent {
  final AppTheme appTheme;

  ChangeAppTheme(this.appTheme);
}

class _AnimateThemeStyle extends GlobalEvent {
  final ThemeStyle themeStyle;

  _AnimateThemeStyle(this.themeStyle);
}

class ChangeAppTextStyle extends GlobalEvent {
  final AppTextStyle appTextStyle;

  ChangeAppTextStyle(this.appTextStyle);
}

class ChangeAppLanguage extends GlobalEvent {
  final AppLanguage appLanguage;

  ChangeAppLanguage(this.appLanguage);
}

class GlobalState {
  final ThemeStyle themeStyle;
  final Locale locale;
  final TextStyle textStyle;

  GlobalState(this.themeStyle, this.locale, this.textStyle);
}

class DefaultGlobal extends GlobalState {
  DefaultGlobal() : super(lightTheme, localeSC, normalTextStyle);
}

class AppGlobal extends GlobalState {
  AppGlobal({ThemeStyle? themeStyle, Locale? locale, TextStyle? textStyle})
      : super(
          themeStyle ?? lightTheme,
          locale ?? localeSC,
          textStyle ?? normalTextStyle,
        );
}

// region 主题样式
ThemeStyle lightTheme = ThemeStyle.light();

ThemeStyle darkTheme = ThemeStyle.dark();
// endregion

// region 多语言
/// Simplified Chinese 简体中文
const Locale localeSC =
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');

/// Traditional Chinese 繁体中文
const Locale localeTC =
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');

/// English 英文
const Locale localeEN = Locale.fromSubtags(languageCode: 'en');
// endregion

// region 文字样式
const normalTextStyle = TextStyle(
  color: Colors.black87,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.none,
  fontFamilyFallback: ["PingFang SC", "Heiti SC"],
);

const redTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.overline,
  fontFamilyFallback: ["PingFang SC", "Heiti SC"],
);

// endregion
extension AppGlobalExt on GlobalState {
  AppGlobal appGlobal(
      {ThemeStyle? themeStyle, Locale? locale, TextStyle? textStyle}) {
    return AppGlobal(
      themeStyle: themeStyle ?? this.themeStyle,
      locale: locale ?? this.locale,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

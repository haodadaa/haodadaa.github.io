import 'package:blog/module/global/global_bloc.dart';
import 'package:blog/module/global/global_localization_delegate.dart';
import 'package:blog/module/global/locale/locale_image.dart';
import 'package:blog/module/global/locale/locale_text.dart';
import 'package:blog/module/global/theme/theme_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension GlobalContextExt on BuildContext {
  GlobalBloc get globalBloc => BlocProvider.of<GlobalBloc>(this);

  ThemeStyle get themeStyle =>
      BlocProvider.of<GlobalBloc>(this).state.themeStyle;

  LocaleText get localeText => GlobalLocalizations.of(this)!.currentLocaleText;

  LocaleImage get localImage =>
      GlobalLocalizations.of(this)!.currentLocaleImage;
}

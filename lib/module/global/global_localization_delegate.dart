import 'package:blog/module/global/global_bloc.dart';
import 'package:blog/module/global/locale/locale_image.dart';
import 'package:blog/module/global/locale/locale_image_en.dart';
import 'package:blog/module/global/locale/locale_image_sc.dart';
import 'package:blog/module/global/locale/locale_image_tc.dart';
import 'package:blog/module/global/locale/locale_text.dart';
import 'package:blog/module/global/locale/locale_text_en.dart';
import 'package:blog/module/global/locale/locale_text_sc.dart';
import 'package:blog/module/global/locale/locale_text_tc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum Language {
  sc,
  tc,
  en,
}

class GlobalLocalizationDelegate
    extends LocalizationsDelegate<GlobalLocalizations> {
  static GlobalLocalizationDelegate delegate = GlobalLocalizationDelegate();

  /// 简中，繁中，英文
  List<Locale> get supportedLocales {
    return const <Locale>[
      localeSC,
      localeTC,
      localeEN,
    ];
  }

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<GlobalLocalizations> load(Locale locale) {
    Language language;
    if (locale.languageCode == 'zh' &&
        (locale.countryCode?.toUpperCase() == 'TW' ||
            locale.countryCode?.toUpperCase() == 'HK' ||
            locale.countryCode?.toUpperCase() == 'MO' ||
            locale.scriptCode?.toUpperCase() == 'HANT')) {
      language = Language.tc;
    } else if (locale.languageCode == 'en') {
      language = Language.en;
    } else {
      language = Language.sc;
    }
    return SynchronousFuture<GlobalLocalizations>(
        GlobalLocalizations(language));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<dynamic> old) {
    return false;
  }
}

class GlobalLocalizations {
  static Map<Language, LocaleText> _localeTexts = {
    Language.sc: LocaleTextSC(),
    Language.tc: LocaleTextTC(),
    Language.en: LocaleTextEN(),
  };

  static Map<Language, LocaleImage> _localeImages = {
    Language.sc: LocaleImageSC(),
    Language.tc: LocaleImageTC(),
    Language.en: LocaleImageEN(),
  };

  final Language _language;

  GlobalLocalizations(this._language);

  Language get language => _language;

  LocaleText get currentLocaleText {
    return _localeTexts[_language]!;
  }

  LocaleImage get currentLocaleImage {
    return _localeImages[_language]!;
  }

  static GlobalLocalizations? of(BuildContext context) {
    GlobalLocalizations? appLocalizations =
        Localizations.of(context, GlobalLocalizations);
    return appLocalizations;
  }
}

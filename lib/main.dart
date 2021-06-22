import 'package:blog/module/global/global_bloc.dart';
import 'package:blog/module/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';

import 'module/global/global_localization_delegate.dart';

void main() {
  assert(() {
    Logger.addLogAdapter(LoggerAdapter());
    return true;
  }());
  runApp(const GlobalApp());
}

class GlobalApp extends StatefulWidget {
  const GlobalApp({Key? key}) : super(key: key);

  @override
  _GlobalAppState createState() => _GlobalAppState();
}

class _GlobalAppState extends State<GlobalApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Logger.i('App Start');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return GlobalBloc(this);
        }),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      bloc: context.globalBloc,
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalLocalizationDelegate.delegate,
          ],
          locale: state.locale,
          supportedLocales:
              GlobalLocalizationDelegate.delegate.supportedLocales,
          builder: (context, widget) {
            return const HomePage();
          },
        );
      },
    );
  }
}

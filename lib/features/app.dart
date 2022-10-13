import 'package:flutter/material.dart';

import 'routes.dart';
import 'views/login_view.dart';

import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Carteira',
      initialRoute: Routes.initial,
      routes: Routes.routes,
      theme: ThemeData.light(useMaterial3: true),
      localizationsDelegates: [
        SfGlobalLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt', ''),
        Locale('en', ''),
      ],
      locale: const Locale('pt'),
      home: const LoginView(),
    );
  }
}

import 'package:flutter/material.dart';

import 'routes.dart';
import 'views/login_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste',
      initialRoute: Routes.initial,
      routes: Routes.routes,
      home: const LoginView(),
    );
  }
}

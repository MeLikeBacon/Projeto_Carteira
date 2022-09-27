import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/stores/entrada_store.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'features/app.dart';
import 'features/stores/movs_store.dart';
import 'features/stores/saida_store.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => PessoasStore()),
      Provider(create: (_) => EntradaStore()),
      Provider(create: (_) => MovsStore()),
      Provider(create: (_) => SaidaStore()),
    ],
    child: const MyApp(),
  ));
}

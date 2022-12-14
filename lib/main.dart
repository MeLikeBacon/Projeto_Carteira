import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'features/movement/stores/entrada_store.dart';
import 'features/movement/stores/saida_store.dart';
import 'features/movement/stores/movs_store.dart';
import 'features/account/stores/pessoas_store.dart';

import 'package:projeto_carteira/features/services/firebase_messaging_service.dart';
import 'package:projeto_carteira/features/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => PessoasStore()),
      Provider(create: (_) => EntradaStore()),
      Provider(create: (_) => MovsStore()),
      Provider(create: (_) => SaidaStore()),
      Provider<NotificationService>(create: (context) => NotificationService()),
      Provider<FirebaseMessagingService>(
        create: (context) => FirebaseMessagingService(context.read<NotificationService>()),
      )
    ],
    child: const MyApp(),
  ));
}

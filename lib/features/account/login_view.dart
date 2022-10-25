import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:projeto_carteira/features/services/firebase_messaging_service.dart';
import 'package:projeto_carteira/features/services/notification_service.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final PessoaController _pessoaController = PessoaController();

  late PessoasStore _pessoasStore;

  bool visible = false;

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    checkNotifications();
    initializeFirebaseMessaging();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

  String? errorTextEmail, errorTextSenha;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            width: screenSize.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                    child: const Icon(
                      Icons.wallet,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _pessoasStore.forms.emailControl,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      errorText: errorTextEmail,
                      border: const OutlineInputBorder(),
                      labelText: 'E-mail',
                      suffixIcon: IconButton(
                        onPressed: _pessoasStore.forms.emailControl.clear,
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextFormField(
                    controller: _pessoasStore.forms.senhaControl,
                    style: TextStyle(fontSize: textSize),
                    obscureText: !visible,
                    decoration: InputDecoration(
                      errorText: errorTextSenha,
                      border: const OutlineInputBorder(),
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        onPressed: (() {
                          setState(() {
                            visible = !visible;
                          });
                        }),
                        icon: Icon(
                          visible ? Icons.visibility : Icons.visibility_off,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
                RichText(
                    text: TextSpan(
                        text: 'Esqueceu a senha?',
                        style: TextStyle(fontSize: textSize - 4, color: Colors.lightBlue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() {
                            Navigator.pushReplacementNamed(context, '/forgor');
                          }))),
                Container(
                  margin: EdgeInsets.only(top: 15 * screenSize.height * 0.0025),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (!isFieldNull()) {
                          List<PessoaModel> userLogin = await _pessoaController.logInPessoa(
                              _pessoasStore.forms.emailControl.text, _pessoasStore.forms.senhaControl.text);
                          if (!mounted) return;
                          if (userLogin.isNotEmpty) {
                            _pessoasStore.changeUser(userLogin.first);
                            _pessoasStore.clearForms();

                            userLogin.first.tipo == 'adm'
                                ? Navigator.pushReplacementNamed(context, '/adm')
                                : Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            setState(() {
                              errorTextEmail = '';
                              errorTextSenha = 'E-mail ou senha inválidos, tente novamente';
                            });
                          }
                        }
                      },
                      child: Container(
                        width: screenSize.width * 0.65,
                        alignment: Alignment.center,
                        child: Text(
                          'Entrar',
                          style: TextStyle(fontSize: textSize),
                        ),
                      )),
                ),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      'Não tenho conta',
                      style: TextStyle(fontSize: textSize),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isFieldNull() {
    var n = 0;
    if (_pessoasStore.forms.emailControl.text.isEmpty) {
      setState(() {
        errorTextEmail = 'Preencha este campo';
      });
      n++;
    } else {
      errorTextEmail = null;
    }
    if (_pessoasStore.forms.senhaControl.text.isEmpty) {
      setState(() {
        errorTextSenha = 'Preencha este campo';
      });
      n++;
    } else {
      errorTextSenha = null;
    }
    return n > 0;
  }
}

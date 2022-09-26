import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/models/pessoa_model.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../models/entrada_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final PessoaController _pessoaController = PessoaController();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  late PessoasStore _pessoasStore;

  bool visible = false;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.lightBlue),
                  child: const Icon(
                    Icons.wallet,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                  width: screenSize.width * 0.75,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _controllerEmail,
                    style: TextStyle(fontSize: textSize),
                    decoration: InputDecoration(
                      //errorText: '',
                      border: const OutlineInputBorder(),
                      labelText: 'E-mail',
                      suffixIcon: IconButton(
                        onPressed: _controllerEmail.clear,
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: SizedBox(
                  width: screenSize.width * 0.75,
                  child: TextFormField(
                    controller: _controllerSenha,
                    style: TextStyle(fontSize: textSize),
                    obscureText: !visible,
                    decoration: InputDecoration(
                      //errorText: '',
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
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: RichText(
                    text: TextSpan(
                        text: 'Esqueceu a senha?',
                        style: TextStyle(
                            fontSize: textSize - 4, color: Colors.lightBlue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() => print('funciona')))),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Container(
                  width: screenSize.width * 0.70,
                  margin: EdgeInsets.only(top: 15 * screenSize.height * 0.0025),
                  child: ElevatedButton(
                      onPressed: () async {
                        List<PessoaModel> userlogin =
                            await _pessoaController.logInPessoa(
                                _controllerEmail.text, _controllerSenha.text);
                        if (userlogin.isNotEmpty) {
                          _pessoasStore.changeUser(userlogin.first);
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {}
                      },
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: textSize),
                      )),
                ),
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
    );
  }
}

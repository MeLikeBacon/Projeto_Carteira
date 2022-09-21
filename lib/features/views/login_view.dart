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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
              Container(
                width: screenSize.width * 0.75,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    //errorText: '',
                    border: const OutlineInputBorder(),
                    labelText: 'E-mail',
                    suffixIcon: IconButton(
                      onPressed: _controllerEmail.clear,
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                ),
              ),
              Container(
                width: screenSize.width * 0.75,
                child: TextFormField(
                  controller: _controllerSenha,
                  decoration: InputDecoration(
                    //errorText: '',
                    border: const OutlineInputBorder(),
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      onPressed: _controllerSenha.clear,
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: RichText(
                    text: TextSpan(
                        text: 'Esqueceu a senha?',
                        style: const TextStyle(color: Colors.lightBlue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() => print('funciona')))),
              ),
              Container(
                width: screenSize.width * 0.70,
                margin: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                    onPressed: () async {
                      List<PessoaModel> userlogin =
                          await _pessoaController.logInPessoa(
                              _controllerEmail.text, _controllerSenha.text);
                      if (userlogin.isNotEmpty) {
                        _pessoasStore.login(userlogin.first);
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {}
                    },
                    child: const Text('Entrar')),
              ),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: const Text('Não tenho conta')),
            ],
          ),
        ),
      ),
    );
  }
}

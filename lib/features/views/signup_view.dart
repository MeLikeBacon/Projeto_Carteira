import 'package:flutter/material.dart';

import '../controllers/pessoa_controller.dart';
import '../models/pessoa_model.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final PessoaController _pessoaController = PessoaController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  String? errorTextEmail, errorTextNome, errorTextSenha;
  double _controllerMinimo = 0;

  bool visible = false;

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
          children: [
            Text(
              'Registre-se!',
              style: TextStyle(
                  fontSize: textSize + 20, fontWeight: FontWeight.bold),
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
                    errorText: errorTextEmail,
                    border: const OutlineInputBorder(),
                    labelText: 'E-mail',
                    suffixIcon: IconButton(
                      onPressed: _controllerEmail.clear,
                      icon: Icon(Icons.cancel_outlined, size: iconSize),
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
                  controller: _controllerNome,
                  style: TextStyle(fontSize: textSize),
                  decoration: InputDecoration(
                    errorText: errorTextNome,
                    border: const OutlineInputBorder(),
                    labelText: 'Nome',
                    suffixIcon: IconButton(
                      onPressed: _controllerNome.clear,
                      icon: Icon(Icons.cancel_outlined, size: iconSize),
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Container(
                width: screenSize.width * 0.75,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  controller: _controllerSenha,
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
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SizedBox(
                width: screenSize.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo mínimo',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: textSize),
                    ),
                    Slider(
                      value: _controllerMinimo,
                      max: 600,
                      divisions: 60,
                      label: _controllerMinimo.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _controllerMinimo = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenSize.width,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: SizedBox(
                      width: screenSize.width * 0.70,
                      child: ElevatedButton(
                          onPressed: () async {
                            PessoaModel tempPessoa = PessoaModel(
                                nome: _controllerNome.text,
                                email: _controllerEmail.text,
                                senha: _controllerSenha.text,
                                minimo: _controllerMinimo);

                            loginFun(tempPessoa);
                          },
                          child: Text(
                            'Registrar',
                            style: TextStyle(fontSize: textSize),
                          )),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder())),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Icon(
                        Icons.undo,
                        size: iconSize,
                      ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void clearTextControllers() {
    setState(() {
      _controllerNome.text = '';

      _controllerEmail.text = '';

      _controllerSenha.text = '';

      _controllerMinimo = 0;
    });
  }

  void loginFun(PessoaModel tempPessoa) async {
    bool hasDuplicate;

    if (_controllerNome.text.isEmpty ||
        _controllerEmail.text.isEmpty ||
        _controllerSenha.text.isEmpty) {
      setState(() {
        _controllerNome.text.isEmpty
            ? errorTextNome = 'Este campo está incompleto'
            : errorTextNome = null;
        _controllerEmail.text.isEmpty
            ? errorTextEmail = 'Este campo está incompleto'
            : errorTextEmail = null;
        _controllerSenha.text.isEmpty
            ? errorTextSenha = 'Este campo está incompleto'
            : errorTextSenha = null;
      });
      clearTextControllers();
      hasDuplicate = true;
      return;
    } else {
      hasDuplicate = await _pessoaController.insertPessoa(context, tempPessoa);
    }
    if (hasDuplicate) {
      clearTextControllers();
      print('couldnt sign up');
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Erro de registro'),
                content:
                    const Text('Já existe alguém registrado com esse e-mail.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Registrado'),
                content: const Text('Pessoa registrada com sucesso.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }
}

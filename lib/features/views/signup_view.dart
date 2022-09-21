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
  double _controllerMinimo = 0;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Registre-se!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                controller: _controllerNome,
                decoration: InputDecoration(
                  //errorText: '',
                  border: const OutlineInputBorder(),
                  labelText: 'Nome',
                  suffixIcon: IconButton(
                    onPressed: _controllerNome.clear,
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
            ),
            Container(
              width: screenSize.width * 0.75,
              margin: const EdgeInsets.symmetric(vertical: 20),
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
              width: screenSize.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.075),
                    child: const Text('Saldo mínimo'),
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
            Container(
              width: screenSize.width * 0.70,
              margin: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                  onPressed: () async {
                    PessoaModel tempPessoa = PessoaModel(
                        nome: _controllerNome.text,
                        email: _controllerEmail.text,
                        senha: _controllerSenha.text,
                        minimo: _controllerMinimo);
                    bool hasDuplicate = await _pessoaController.insertPessoa(
                        context, tempPessoa);

                    if (hasDuplicate) {
                      print('couldnt sign up');
                    } else {
                      AlertDialog(
                        title: const Text('Registrado'),
                        content: const Text('Pessoa registrada com sucesso.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }
                  },
                  child: const Text('Registrar')),
            ),
          ],
        ),
      )),
    );
  }
}

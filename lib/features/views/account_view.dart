import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../controllers/pessoa_controller.dart';
import '../models/pessoa_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final PessoaController _pessoaController = PessoaController();

  //Forms
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  double _controllerMinimo = 0;

  late PessoasStore _pessoasStore;

  String? errorTextEmail, errorTextNome, errorTextSenha;

  bool visible = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _controllerEmail.text = _pessoasStore.currentUser.email!;
    _controllerNome.text = _pessoasStore.currentUser.nome!;
    _controllerSenha.text = _pessoasStore.currentUser.senha!;
    _controllerMinimo = _pessoasStore.currentUser.minimo!;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Alterar conta',
      ),
      body: Center(
          heightFactor: 1.15,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Theme.of(context).primaryColor,
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
                        errorText: errorTextEmail,
                        border: const OutlineInputBorder(),
                        labelText: 'E-mail',
                        suffixIcon: IconButton(
                          onPressed: _controllerEmail.clear,
                          icon: const Icon(Icons.cancel_outlined),
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
                          icon: const Icon(Icons.cancel_outlined),
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
                      obscureText: !visible,
                      style: TextStyle(fontSize: textSize),
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
                          icon: Icon(visible
                              ? Icons.visibility
                              : Icons.visibility_off),
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Container(
                    width: screenSize.width * 0.70,
                    margin: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                        onPressed: () async {
                          PessoaModel tempPessoa = PessoaModel(
                              nome: _controllerNome.text,
                              email: _controllerEmail.text,
                              senha: _controllerSenha.text,
                              minimo: _controllerMinimo);
                          changeFun(tempPessoa);
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              'Salvar',
                              style: TextStyle(fontSize: textSize),
                            ))),
                            Icon(
                              Icons.save,
                              size: iconSize,
                            )
                          ],
                        )),
                  ),
                ),
                SizedBox(height: iconSize)
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.home,
            size: iconSize,
          )),
    );
  }

  void changeFun(PessoaModel tempPessoa) async {
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
    }
    if (_controllerNome.text.isNotEmpty &&
        _controllerEmail.text.isNotEmpty &&
        _controllerSenha.text.isNotEmpty) {
      _pessoaController.updatePessoaWhole(
          _pessoasStore.currentUser, tempPessoa);
    }
  }
}

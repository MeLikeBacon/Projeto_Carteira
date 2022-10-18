import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_carteira/features/components/homeFAB.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../controllers/pessoa_controller.dart';
import '../models/pessoa_model.dart';

class ManageView extends StatefulWidget {
  const ManageView({super.key});

  @override
  State<ManageView> createState() => _ManageViewState();
}

class _ManageViewState extends State<ManageView> {
  PessoaController _pessoaController = PessoaController();

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _pessoasStore.pessoas.isEmpty ? _pessoasStore.loadPessoas() : null;
  }

  String? errorTextNome, errorTextEmail, errorTextSenha, errorTextMinimo;

  int numValidFields = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 11 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: MyAppBar(title: 'Cadastrar usuários'),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          width: screenSize.width * 0.75,
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _pessoasStore.nomeControl,
                decoration: InputDecoration(
                  errorText: errorTextNome,
                  border: const OutlineInputBorder(),
                  labelText: 'Nome',
                  suffixIcon: IconButton(
                    onPressed: _pessoasStore.nomeControl.clear,
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pessoasStore.emailControl,
                decoration: InputDecoration(
                  errorText: errorTextEmail,
                  border: const OutlineInputBorder(),
                  labelText: 'E-Mail',
                  suffixIcon: IconButton(
                    onPressed: _pessoasStore.emailControl.clear,
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pessoasStore.senhaControl,
                decoration: InputDecoration(
                  errorText: errorTextSenha,
                  border: const OutlineInputBorder(),
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    onPressed: _pessoasStore.senhaControl.clear,
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _pessoasStore.minimoControl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter()
                ],
                decoration: InputDecoration(
                  errorText: errorTextMinimo,
                  border: const OutlineInputBorder(),
                  labelText: 'Mínimo',
                  suffixIcon: IconButton(
                    onPressed: _pessoasStore.minimoControl.clear,
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: screenSize.width * 0.6,
                child: ElevatedButton(
                    onPressed: () async {
                      late String snackContent;
                      numValidFields = 0;
                      setState(() {
                        errorTextNome = nllField(_pessoasStore.nomeControl);
                        errorTextEmail = nllField(_pessoasStore.emailControl);
                        errorTextSenha = nllField(_pessoasStore.senhaControl);
                        errorTextMinimo = nllField(_pessoasStore.minimoControl);
                      });
                      if (numValidFields == 4) {
                        List<PessoaModel> exists = await _pessoaController
                            .findPessoaByEmail(_pessoasStore.emailControl.text);
                        if (exists.isEmpty) {
                          snackContent =
                              "Usuário '${_pessoasStore.nomeControl.text}' criado!";
                          _pessoasStore.clearAllControls();
                        } else {
                          setState(() {
                            snackContent =
                                'Um usuário com esse e-mail já existe';
                          });
                        }

                        final snackBar = SnackBar(
                          content: Text(snackContent),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('Cadastrar')),
              )
            ],
          ),
        ),
      )),
      floatingActionButton: HomeFAB(iconSize: iconSize),
    );
  }

  String? nllField(TextEditingController control) {
    if (control.text.isEmpty) {
      return 'Não deixe este campo vazio';
    } else {
      numValidFields++;
      return null;
    }
  }
}

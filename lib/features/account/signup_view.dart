import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/account/components/form_field.dart';
import 'package:provider/provider.dart';

import 'controllers/pessoa_controller.dart';
import 'models/pessoa_model.dart';
import 'stores/pessoas_store.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final PessoaController _pessoaController = PessoaController();

  double _minimumControl = 0;

  bool visible = false;

  List<TextEditingController> controls = [];
  List<String> labels = ['Nome', 'E-mail', 'Senha', 'Confirme sua senha'];
  List<String?> errors = [null, null, null, null, null];

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    controls = [
      _pessoasStore.forms.nomeControl,
      _pessoasStore.forms.emailControl,
      _pessoasStore.forms.senhaControl,
      _pessoasStore.forms.senha2Control,
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;

    Widget minimumSlider() {
      return Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Saldo mínimo',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).hintColor, fontSize: textSize),
          ),
        ),
        Slider(
          value: _minimumControl,
          max: 600,
          divisions: 60,
          label: _minimumControl.round().toString(),
          onChanged: (double value) {
            setState(() {
              _minimumControl = value.roundToDouble();
            });
          },
        ),
      ]);
    }

    return Scaffold(
      body: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        width: screenSize.width * 0.75,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Registre-se!',
              style: TextStyle(fontSize: textSize + 20, fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, int index) {
                    return index < 4
                        ? MyFormField(labelText: labels[index], control: controls[index], errorText: errors[index])
                        : minimumSlider();
                  }),
            ),
            Container(
              width: screenSize.width * 0.7,
              margin: const EdgeInsets.only(top: 15),
              constraints: const BoxConstraints(maxWidth: 650),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          PessoaModel tempPessoa = PessoaModel(
                              nome: _pessoasStore.forms.nomeControl.text,
                              email: _pessoasStore.forms.emailControl.text,
                              senha: _pessoasStore.forms.senhaControl.text,
                              minimo: _minimumControl);

                          signupFun(tempPessoa);
                        },
                        child: Text(
                          'Registrar',
                          style: TextStyle(fontSize: textSize),
                        )),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(shape: MaterialStateProperty.all(const CircleBorder())),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
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

  bool isFieldNull() {
    var n = 0;
    for (int i = 0; i < controls.length; i++) {
      if (controls[i].text.isEmpty) {
        setState(() {
          errors[i] = 'Preencha este campo';
        });
        n++;
      } else {
        setState(() {
          errors[i] = null;
        });
      }
    }
    return n > 0;
  }

  void signupFun(PessoaModel tempPessoa) async {
    bool hasDuplicate = true;
    String title = '', body = '';

    if (isFieldNull()) {
      return;
    }

    if (_pessoasStore.forms.senhaControl.text != _pessoasStore.forms.senha2Control.text) {
      setState(() {
        errors[2] = '';
        errors[3] = 'As duas senhas não coincidem';
      });
      return;
    }

    hasDuplicate = await _pessoaController.insertPessoa(tempPessoa);

    _pessoasStore.clearForms();

    if (hasDuplicate) {
      title = 'Erro de registro';
      body = 'Já existe alguém registrado com esse e-mail.';
    } else {
      title = 'Registrado';
      body = 'Pessoa registrada com sucesso.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Container(constraints: const BoxConstraints(maxHeight: 20, maxWidth: 250), child: Text(body)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              hasDuplicate ? null : Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

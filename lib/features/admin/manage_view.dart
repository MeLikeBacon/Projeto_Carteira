import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/components/homeFAB.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../account/components/form_field.dart';
import '../account/controllers/pessoa_controller.dart';
import '../account/models/pessoa_model.dart';

class ManageView extends StatefulWidget {
  const ManageView({super.key});

  @override
  State<ManageView> createState() => _ManageViewState();
}

class _ManageViewState extends State<ManageView> {
  final PessoaController _pessoaController = PessoaController();

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);

    _pessoasStore.setUserType(dropLabel);

    controls = [
      _pessoasStore.forms.nomeControl,
      _pessoasStore.forms.emailControl,
      _pessoasStore.forms.senhaControl,
      _pessoasStore.forms.minimumControl
    ];
  }

  String dropLabel = 'user';

  List<TextEditingController> controls = [];
  List<String> dropTypes = ['adm', 'user'];
  List<String> labels = ['Nome', 'E-mail', 'Senha', 'Mínimo'];
  List<String?> errors = [null, null, null, null];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 11 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    Widget saveButton() {
      return Expanded(
        flex: 3,
        child: ElevatedButton(
            onPressed: () async {
              signupFun(_pessoasStore.getTempPessoa());
            },
            child: const Text('Cadastrar')),
      );
    }

    Widget userTypeDropdown() {
      return Expanded(
          flex: 2,
          child: DropdownButton(
            isExpanded: true,
            hint: const Text('Tipo'),
            value: dropLabel,
            items: dropTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropLabel = value!;
              });
              _pessoasStore.setUserType(value);
            },
          ));
    }

    Widget bottomForm() {
      return SizedBox(
        child: Row(
          children: [userTypeDropdown(), const SizedBox(width: 10), saveButton()],
        ),
      );
    }

    return Scaffold(
      appBar: MyAppBar(title: 'Cadastrar usuários'),
      body: Center(
          child: Container(
        width: screenSize.width * 0.75,
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Flexible(
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, int index) {
                    return index < 4
                        ? MyFormField(labelText: labels[index], control: controls[index], errorText: errors[index])
                        : bottomForm();
                  }),
            ),
            const SizedBox(height: 15),
          ],
        ),
      )),
      floatingActionButton: HomeFAB(iconSize: iconSize),
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
    String snackContent = '';

    if (isFieldNull()) {
      return;
    }

    hasDuplicate = await _pessoaController.insertPessoa(tempPessoa);

    _pessoasStore.clearForms();

    if (hasDuplicate) {
      snackContent = 'Já existe alguém registrado com esse e-mail.';
    } else {
      snackContent = 'Pessoa registrada com sucesso.';
    }

    final snackBar = SnackBar(
      content: Text(snackContent),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

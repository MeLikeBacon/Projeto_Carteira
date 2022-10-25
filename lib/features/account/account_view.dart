import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../components/homeFAB.dart';
import 'controllers/pessoa_controller.dart';
import 'models/pessoa_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final PessoaController _pessoaController = PessoaController();
  List<TextEditingController> controls = [];

  late PessoasStore _pessoasStore;
  int nFields = 4;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _pessoasStore.forms.typeControl = _pessoasStore.currentUser.tipo;
    controls = [
      _pessoasStore.forms.nomeControl,
      _pessoasStore.forms.emailControl,
      _pessoasStore.forms.senhaControl,
      _pessoasStore.forms.minimumControl,
    ];
  }

  List<String> labels = ['Nome', 'E-mail', 'Senha', 'Mínimo'];
  List<String?> errorTextVar = [null, null, null, null];
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;

    Widget formField(String labelText, TextEditingController control, String? errorText) {
      return TextFormField(
        obscureText: labelText == 'Senha' ? !visible : false,
        keyboardType: labelText == 'Mínimo' ? TextInputType.number : null,
        inputFormatters:
            labelText == 'Mínimo' ? [FilteringTextInputFormatter.digitsOnly, CentavosInputFormatter()] : null,
        controller: control,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          errorText: errorText,
          border: const OutlineInputBorder(),
          labelText: labelText,
          suffixIcon: labelText == 'Senha'
              ? IconButton(
                  onPressed: (() {
                    setState(() {
                      visible = !visible;
                    });
                  }),
                  icon: Icon(
                    visible ? Icons.visibility : Icons.visibility_off,
                    size: iconSize,
                  ),
                )
              : IconButton(
                  onPressed: control.clear,
                  icon: const Icon(Icons.cancel_outlined),
                ),
        ),
      );
    }

    return Scaffold(
        appBar: MyAppBar(
          title: 'Alterar conta',
        ),
        body: Center(
          heightFactor: 1.15,
          child: _pessoasStore.pessoaLoaded
              ? Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  width: screenSize.width * 0.75,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: nFields,
                            itemBuilder: (context, int index) {
                              return formField(labels[index], controls[index], errorTextVar[index]);
                            }),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 650),
                        width: screenSize.width * 0.70,
                        margin: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                            onPressed: () async {
                              changeFun(_pessoasStore.getTempPessoa());
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
                      SizedBox(height: iconSize)
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
        floatingActionButton: HomeFAB(iconSize: iconSize));
  }

  void changeFun(PessoaModel tempPessoa) async {
    int vazio = 0;
    setState(() {
      for (int i = 0; i < nFields; i++) {
        if (controls[i].text.isEmpty) {
          errorTextVar[i] = 'Este campo está incompleto';
          vazio++;
        } else {
          errorTextVar[i] = null;
        }
      }
    });
    vazio == 0 ? _pessoaController.updatePessoaWhole(_pessoasStore.editedUser, tempPessoa) : null;
  }
}

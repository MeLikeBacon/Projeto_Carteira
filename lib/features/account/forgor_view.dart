import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/account/components/form_field.dart';
import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:projeto_carteira/features/services/notification_service.dart';
import 'package:provider/provider.dart';

class ForgorView extends StatefulWidget {
  const ForgorView({super.key});

  @override
  State<ForgorView> createState() => _ForgorViewState();
}

class _ForgorViewState extends State<ForgorView> {
  final PessoaController _pessoaController = PessoaController();
  String? errorText;
  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          width: screenSize.width * 0.75,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Recuperar senha',
              style: TextStyle(fontSize: textSize + 20, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child:
                    MyFormField(labelText: 'E-Mail', control: _pessoasStore.forms.emailControl, errorText: errorText)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        forgorFun();
                      },
                      child: Text(
                        'Recuperar',
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
          ]),
        ),
      ),
    );
  }

  void forgorFun() async {
    if (_pessoasStore.forms.emailControl.text.isEmpty) {
      setState(() {
        errorText = 'Preencha este campo';
      });
      return;
    }
    setState(() {
      errorText = null;
    });

    var temp = await _pessoaController.findPessoaByEmail(_pessoasStore.forms.emailControl.text);

    if (temp.isEmpty) {
      setState(() {
        errorText = 'E-mail inválido';
      });
      return;
    }

    if (!mounted) return;
    Provider.of<NotificationService>(context, listen: false).showNotification(CustomNotification(
        id: 1, title: 'Senha da conta ${temp.first.email}', body: temp.first.senha, payload: '/login'));

    _pessoasStore.clearForms();
  }
}

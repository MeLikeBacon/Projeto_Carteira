import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/services/notification_service.dart';
import 'package:provider/provider.dart';

class ForgorView extends StatefulWidget {
  const ForgorView({super.key});

  @override
  State<ForgorView> createState() => _ForgorViewState();
}

class _ForgorViewState extends State<ForgorView> {
  final TextEditingController _controllerEmail = TextEditingController();
  final PessoaController _pessoaController = PessoaController();
  String? errorText;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Recuperar senha',
            style:
                TextStyle(fontSize: textSize + 20, fontWeight: FontWeight.bold),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            width: screenSize.width * 0.75,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: TextFormField(
              controller: _controllerEmail,
              style: TextStyle(fontSize: textSize),
              decoration: InputDecoration(
                errorText: errorText,
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
                          // if (await forgorFun()) {
                          //   errorText = 'E-mail inválido';
                          // }
                          forgorFun();
                          print(errorText);
                        },
                        child: Text(
                          'Recuperar',
                          style: TextStyle(fontSize: textSize),
                        )),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder())),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: Icon(
                      Icons.undo,
                      size: iconSize,
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void forgorFun() async {
    if (_controllerEmail.text.isNotEmpty) {
      var temp =
          await _pessoaController.findPessoaByEmail(_controllerEmail.text);

      if (temp.isEmpty) {
        setState(() {
          errorText = 'E-mail inválido';
        });
      } else {
        setState(() {
          errorText = null;
        });
        Provider.of<NotificationService>(context, listen: false)
            .showNotification(CustomNotification(
                id: 1,
                title: 'Senha da conta ${temp.first.email}',
                body: temp.first.senha,
                payload: '/login'));
      }
    } else {
      setState(() {
        errorText = 'Preencha este campo';
      });
    }
  }
}

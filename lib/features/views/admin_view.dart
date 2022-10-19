import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../components/myAppBar.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  List<IconData> iconButtons = [
    Icons.group_add,
    Icons.person_search,
    Icons.account_balance_wallet,
    Icons.receipt_long,
    Icons.logout,
  ];

  List<String> iconLabels = ['Cadastrar usuários', 'Consultar usuários', 'Movimentar', 'Consultar movimentos', 'Sair'];

  List<String> iconRefs = ['/manage', '/userlist', '/movs', '/search', '/login'];

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 14 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 40 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    void deslogar() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Saindo'),
                content: const Text('Deseja realmente sair de sua conta?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'SIM');
                      _pessoasStore.logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/'));
                    },
                    child: const Text('SIM'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'NÃO');
                    },
                    child: const Text('NÃO'),
                  ),
                ],
              ));
    }

    return Scaffold(
      appBar: MyAppBar(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(iconButtons[index]),
              title: Text(iconLabels[index]),
              onTap: () {
                if (index == (iconLabels.length - 1)) {
                  deslogar();
                } else {
                  Navigator.pushNamed(context, iconRefs[index]);
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: iconLabels.length),
    );
  }
}

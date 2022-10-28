import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../account/models/homebutton_model.dart';
import '../components/myAppBar.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {

  List<HomeButton> adminButtons = [
    HomeButton(Icons.group_add, 'Cadastrar usuários', '/manage'),
    HomeButton(Icons.person_search, 'Consultar usuários', '/userlist'),
    HomeButton(Icons.account_balance_wallet, 'Movimentar', '/movs'),
    HomeButton(Icons.receipt_long, 'Consultar movimentos', '/search'),
    HomeButton(Icons.logout, 'Sair', '/login')
  ];

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    void deslogar() {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
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
              leading: Icon(adminButtons[index].icone),
              title: Text(adminButtons[index].label),
              onTap: () {
                if (index == (adminButtons.length - 1)) {
                  deslogar();
                } else {
                  Navigator.pushNamed(context, adminButtons[index].ref);
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: adminButtons.length),
    );
  }
}

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/account/models/homebutton_model.dart';
import 'package:provider/provider.dart';

import '../components/myAppBar.dart';
import '../account/stores/pessoas_store.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool gridLoaded = false;

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    // Quando a tela inicia em modo horizontal, ela faz uma animação com o gridview, iniciando todos os tiles
    // minúsculos, mas com conteúdo dentro.
    // Essa função serve pra esperar a animação terminar para mostrar o conteúdo do grid e não dar overflow.
    Future.delayed(Duration(milliseconds: _pessoasStore.pessoaLoaded ? 350 : 200), () {
      setState(() {
        gridLoaded = true;
      });
    });
  }

  List<HomeButton> homeButtons = [],
      fullHomeButtons = [
        HomeButton(Icons.manage_accounts, 'Editar conta', '/account'),
        HomeButton(Icons.account_balance_wallet, 'Movimentar', '/movs'),
        HomeButton(Icons.receipt_long, 'Consultar', '/search'),
        HomeButton(Icons.picture_as_pdf, 'Exportar PDF', '/pdf'),
        HomeButton(Icons.logout, 'Sair', '/login'),
      ];

  @override
  Widget build(BuildContext context) {
    var textSize = 14 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 40 + MediaQuery.of(context).size.width * 0.0075;
    var screenSize = MediaQuery.of(context).size;
    bool screenVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    if (screenVertical) {
      homeButtons = [HomeButton(Icons.account_circle, '', ''), ...fullHomeButtons];
    } else {
      homeButtons = [...fullHomeButtons, HomeButton(Icons.account_circle, '', '')];
    }

    void logout() {
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

    Widget gridTile(int index) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            homeButtons[index].icone,
            size: iconSize,
          ),
          const SizedBox(
            height: 3,
          ),
          Column(
            children: [
              Text(
                homeButtons[index].icone == Icons.account_circle
                    ? _pessoasStore.currentUser.nome!
                    : homeButtons[index].label,
                style: TextStyle(fontSize: textSize),
              ),
              homeButtons[index].icone == Icons.account_circle
                  ? Text(
                      '${UtilBrasilFields.obterReal(_pessoasStore.currentUser.saldo!)}${screenVertical ? '' : ' / ${UtilBrasilFields.obterReal(_pessoasStore.currentUser.minimo!)}'}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: textSize),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      );
    }

    int colorNum = 0;

    Widget homePage = GridView.count(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      scrollDirection: screenVertical ? Axis.vertical : Axis.horizontal,
      children: List.generate(screenVertical ? homeButtons.length : homeButtons.length - 1, (index) {
        bool firstColor = index == colorNum;

        if (index == colorNum + 3) {
          colorNum = index + 1;
          firstColor = true;
        }

        return InkWell(
          onTap: (() {
            _pessoasStore.setEditedUser(_pessoasStore.currentUser);
            _pessoasStore.setAllControllers(_pessoasStore.editedUser);

            homeButtons[index].icone == Icons.account_circle
                ? null
                : homeButtons[index].label == 'Sair'
                    ? logout()
                    : Navigator.pushNamed(context, homeButtons[index].ref);
          }),
          child: Ink(
              color: firstColor ? const Color.fromARGB(139, 206, 235, 247) : null,
              child: screenVertical || gridLoaded ? gridTile(index) : const SizedBox()),
        );
      }),
    );

    Widget horizontalProfile = Expanded(
      child: InkWell(
          onTap: () {},
          child: Ink(color: const Color.fromARGB(139, 206, 235, 247), child: gridTile(homeButtons.length - 1))),
    );

    return Scaffold(
        appBar: MyAppBar(),
        body: screenVertical
            ? homePage
            : Row(
                children: [homePage, horizontalProfile],
              ));
  }
}

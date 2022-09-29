import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/myAppBar.dart';
import '../stores/pessoas_store.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
  }

  List<IconData> iconButtons = [
    Icons.manage_accounts,
    Icons.account_balance_wallet,
    Icons.receipt_long,
    Icons.picture_as_pdf,
    Icons.logout,
  ];
  List<String> iconLabels = [
    'Editar conta',
    'Movimentar',
    'Consultar',
    'Exportar PDF',
    'Sair'
  ];
  List<String> iconRefs = ['/account', '/movs', '/search', '/pdf', '/login'];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 14 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 40 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<Widget> homePage = [
      Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: screenVertical ? Axis.vertical : Axis.horizontal,
          children: List.generate(screenVertical ? 6 : 5, (index) {
            return InkWell(
              onTap: (() {
                if (screenVertical && index == 0) {
                } else {
                  if (iconLabels[screenVertical ? index - 1 : index] ==
                      'Sair') {
                    print('deslogado');
                    _pessoasStore.logout();
                    Navigator.pushReplacementNamed(
                        context, iconRefs[screenVertical ? index - 1 : index]);
                  } else {
                    Navigator.pushNamed(
                        context, iconRefs[screenVertical ? index - 1 : index]);
                  }
                }
              }),
              child: Ink(
                color: index == 0 || index == 3 || index == 4
                    ? const Color.fromARGB(139, 206, 235, 247)
                    : null,
                child: index == 0 && screenVertical
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: iconSize,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            _pessoasStore.currentUser.nome!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: textSize),
                          ),
                          Text(
                            'R\$${_pessoasStore.currentUser.saldo!.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: textSize,
                                color: Theme.of(context).hintColor),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconButtons[screenVertical ? index - 1 : index],
                            size: iconSize,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            iconLabels[screenVertical ? index - 1 : index],
                            style: TextStyle(fontSize: textSize),
                          )
                        ],
                      ),
              ),
            );
          }),
        ),
      ),
      screenVertical
          ? Container()
          : InkWell(
              onTap: () {},
              child: Container(
                width: (screenSize.width) - (screenSize.height * 1.5 - 120),
                color: const Color.fromARGB(177, 206, 235, 247),
                child: Ink(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: iconSize,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        _pessoasStore.currentUser.nome!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: textSize),
                      ),
                      Text(
                        'R\$${_pessoasStore.currentUser.saldo!.toStringAsFixed(2)} / R\$${_pessoasStore.currentUser.minimo!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: textSize),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ];

    return Scaffold(
      appBar: MyAppBar(),
      body: screenVertical
          ? Column(
              children: homePage,
            )
          : Row(
              children: homePage,
            ),
    );
  }
}

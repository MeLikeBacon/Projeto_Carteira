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
    bool screenVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: MyAppBar(),
      endDrawer: Drawer(),
      body: Row(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: screenVertical ? Axis.vertical : Axis.horizontal,
              children: List.generate(screenVertical ? 6 : 5, (index) {
                return InkWell(
                  onTap: (() {
                    if (screenVertical && index == 0) {
                      null;
                    } else {
                      if (iconLabels[screenVertical ? index - 1 : index] ==
                          'Sair') {
                        print('deslogado');
                        _pessoasStore.logout();
                        Navigator.pushReplacementNamed(context,
                            iconRefs[screenVertical ? index - 1 : index]);
                      } else {
                        Navigator.pushNamed(context,
                            iconRefs[screenVertical ? index - 1 : index]);
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
                              const Icon(
                                Icons.account_circle,
                                size: 50,
                              ),
                              Text(
                                _pessoasStore.currentUser.nome!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                  'R\$${_pessoasStore.currentUser.saldo!.toStringAsFixed(2)}'),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                iconButtons[screenVertical ? index - 1 : index],
                                size: 50,
                              ),
                              Text(iconLabels[
                                  screenVertical ? index - 1 : index])
                            ],
                          ),
                  ),
                );
              }),
            ),
          ),
          screenVertical
              ? Container()
              : Container(
                  width: screenSize.width * .35,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(177, 206, 235, 247),
                      border: Border(
                          left: BorderSide(
                              width: 10, color: Colors.black.withOpacity(.1)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      Text(
                        _pessoasStore.currentUser.nome!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                          'R\$${_pessoasStore.currentUser.saldo!.toStringAsFixed(2)} / R\$${_pessoasStore.currentUser.minimo!.toStringAsFixed(2)}'),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

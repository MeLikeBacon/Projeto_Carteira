import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/controllers/saida_controller.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';
import 'package:provider/provider.dart';

import '../components/homeFAB.dart';
import '../components/myAppBar.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<int> _selected = [];
  EntradaController _entradaController = EntradaController();
  SaidaController _saidaController = SaidaController();

  late PessoasStore _pessoasStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _pessoasStore.pessoas.isEmpty ? _pessoasStore.loadPessoas() : null;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 11 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        appBar: MyAppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _selected = [];
                  });
                },
                icon: const Icon(
                  Icons.clear_all,
                  size: 40,
                  color: Color.fromARGB(255, 10, 57, 95),
                )),
            IconButton(
                onPressed: () {
                  for (int i = 0; i < _selected.length; i++) {
                    _entradaController.deleteSingleUserEntradas(_selected[i]);
                    _saidaController.deleteSingleUserSaidas(_selected[i]);
                    _pessoasStore.deleteUser(_selected[i]);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  size: 40,
                  color: Color.fromARGB(255, 10, 57, 95),
                ))
          ],
        ),
        body: Observer(
          builder: ((context) {
            return _pessoasStore.pessoaLoaded
                ? _pessoasStore.pessoas.length > 1
                    ? ListView.separated(
                        scrollDirection:
                            screenVertical ? Axis.vertical : Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          if (_pessoasStore.pessoas[index].codigo != 0) {
                            return ListTile(
                                selectedColor: Colors.blue,
                                selected: _selected.contains(
                                    _pessoasStore.pessoas[index].codigo),
                                onTap: () {
                                  setState(() {
                                    _selected.contains(
                                            _pessoasStore.pessoas[index].codigo)
                                        ? _selected.remove(
                                            _pessoasStore.pessoas[index].codigo)
                                        : _selected.add(_pessoasStore
                                            .pessoas[index].codigo!);
                                  });
                                  print(_selected);
                                },
                                onLongPress: () {
                                  print(_pessoasStore.pessoas[index]);
                                },
                                leading: Text(
                                  _pessoasStore.pessoas[index].codigo
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                title: Text(
                                  _pessoasStore.pessoas[index].nome!,
                                  style: TextStyle(
                                      fontSize: textSize + 1,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(_pessoasStore.pessoas[index].email!,
                                        style: TextStyle(
                                          fontSize: textSize - 2,
                                        )),
                                trailing: Text(
                                  UtilBrasilFields.obterReal(
                                      _pessoasStore.pessoas[index].saldo!),
                                  style: TextStyle(
                                    fontSize: textSize,
                                  ),
                                ));
                          } else {
                            return ListTile(
                              leading: Text(
                                'ID',
                                style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                'NOME/E-MAIL',
                                style: TextStyle(
                                    fontSize: textSize + 1,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text('SALDO',
                                  style: TextStyle(
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold)),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              height: 10,
                              color: Colors.black.withOpacity(
                                  _pessoasStore.pessoas[index].codigo != 0
                                      ? .25
                                      : .75),
                              thickness:
                                  _pessoasStore.pessoas[index].codigo != 0
                                      ? 1
                                      : 2,
                            ),
                        //
                        itemCount: _pessoasStore.pessoas.length)
                    : Center(
                        child: Text('Lista de usuários vazia',
                            style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold)),
                      )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
        ),
        floatingActionButton: HomeFAB(
          iconSize: iconSize,
        ));
  }
}

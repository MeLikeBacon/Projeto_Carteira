import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/movement/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/movement/controllers/saida_controller.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
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
    _pessoasStore.loadPessoas();
    //_pessoasStore.pessoas.isEmpty ? _pessoasStore.loadPessoas() : null;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 11 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    bool screenVertical = MediaQuery.of(context).orientation == Orientation.portrait;
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
            return Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListTile(
                    leading: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                    title: Text('NOME / E-MAIL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                    trailing: Text('SALDO (R\$)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                  ),
                ),
                Expanded(
                  child: _pessoasStore.pessoaLoaded
                      ? _pessoasStore.getLowerUsers().isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    selectedColor: Colors.blue,
                                    selected: _selected.contains(_pessoasStore.getLowerUsers()[index].codigo),
                                    onTap: () {
                                      setState(() {
                                        _selected.contains(_pessoasStore.getLowerUsers()[index].codigo)
                                            ? _selected.remove(_pessoasStore.getLowerUsers()[index].codigo)
                                            : _selected.add(_pessoasStore.getLowerUsers()[index].codigo!);
                                      });
                                      print(_selected);
                                    },
                                    onLongPress: () {
                                      showUserInfo(_pessoasStore.getLowerUsers()[index], textSize - 2);
                                    },
                                    leading: Text(
                                      _pessoasStore.getLowerUsers()[index].codigo.toString(),
                                      style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
                                    ),
                                    title: Text(
                                      _pessoasStore.getLowerUsers()[index].nome!,
                                      style: TextStyle(fontSize: textSize + 1, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(_pessoasStore.getLowerUsers()[index].email!,
                                        style: TextStyle(
                                          fontSize: textSize - 2,
                                        )),
                                    trailing: Text(
                                      UtilBrasilFields.obterReal(_pessoasStore.getLowerUsers()[index].saldo!),
                                      style: TextStyle(
                                        fontSize: textSize,
                                      ),
                                    ));
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                              //
                              itemCount: _pessoasStore.getLowerUsers().length)
                          : Center(
                              child: Text('Lista de usuários vazia',
                                  style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold)),
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: HomeFAB(
          iconSize: iconSize,
        ));
  }

  showUserInfo(PessoaModel pessoa, double textSize) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Informações do usuário', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize + 4)),
        content: Wrap(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Nome:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('E-Mail:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Senha:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Mínimo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Saldo atual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${pessoa.codigo}', style: TextStyle(fontSize: textSize)),
                      Text('${pessoa.nome}', style: TextStyle(fontSize: textSize)),
                      Text('${pessoa.email}', style: TextStyle(fontSize: textSize)),
                      Text('${pessoa.senha}', style: TextStyle(fontSize: textSize)),
                      Text(UtilBrasilFields.obterReal(pessoa.minimo!), style: TextStyle(fontSize: textSize)),
                      Text(UtilBrasilFields.obterReal(pessoa.saldo!), style: TextStyle(fontSize: textSize)),
                      Text('${pessoa.tipo}', style: TextStyle(fontSize: textSize)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

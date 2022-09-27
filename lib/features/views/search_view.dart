import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/stores/entrada_store.dart';
import 'package:projeto_carteira/features/stores/movs_store.dart';
import 'package:projeto_carteira/features/stores/saida_store.dart';
import 'package:provider/provider.dart';

import '../models/movimento_abs.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late EntradaStore _entradaStore;
  late SaidaStore _saidaStore;
  late MovsStore _movsStore;

  var isAscending = true;
  var sortColumnIndex = 3;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _entradaStore = Provider.of<EntradaStore>(context);
    _saidaStore = Provider.of<SaidaStore>(context);
    _movsStore = Provider.of<MovsStore>(context);
    _entradaStore.loadEntradas();
    _saidaStore.loadSaidas();
    _movsStore.loadMovs();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 10 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Consulta',
      ),
      body: Center(
          heightFactor: 1,
          child: Observer(
            builder: ((context) {
              return _movsStore.movsLoaded
                  ? SingleChildScrollView(
                      child: Column(
                      children: [
                        DataTable(
                          sortAscending: isAscending,
                          sortColumnIndex: sortColumnIndex,
                          showBottomBorder: true,
                          columnSpacing: iconSize - 2,
                          headingTextStyle: TextStyle(
                              fontSize: textSize, color: Colors.black),
                          dataTextStyle: TextStyle(
                              fontSize: textSize,
                              color: Colors.black.withOpacity(0.75)),
                          columns: [
                            DataColumn(
                                onSort: (columnIndex, ascending) =>
                                    setState(() {
                                      sortColumnIndex = columnIndex;
                                      isAscending = ascending;
                                      ascending
                                          ? _movsStore.movs.sort(((a, b) =>
                                              a.data!.compareTo(b.data!)))
                                          : _movsStore.movs.sort(((b, a) =>
                                              a.data!.compareTo(b.data!)));
                                    }),
                                label: const Text(
                                  'Data',
                                  textAlign: TextAlign.center,
                                )),
                            DataColumn(
                                onSort: (columnIndex, ascending) =>
                                    setState(() {
                                      sortColumnIndex = columnIndex;
                                      isAscending = ascending;
                                      ascending
                                          ? _movsStore.movs.sort(((a, b) => a
                                              .descricao!
                                              .compareTo(b.descricao!)))
                                          : _movsStore.movs.sort(((b, a) => a
                                              .descricao!
                                              .compareTo(b.descricao!)));
                                    }),
                                label: const Text(
                                  'Descrição',
                                  textAlign: TextAlign.center,
                                )),
                            DataColumn(
                                onSort: (columnIndex, ascending) =>
                                    setState(() {
                                      sortColumnIndex = columnIndex;
                                      isAscending = ascending;
                                      ascending
                                          ? _movsStore.movs.sort(((a, b) =>
                                              a.valor!.compareTo(b.valor!)))
                                          : _movsStore.movs.sort(((b, a) =>
                                              a.valor!.compareTo(b.valor!)));
                                    }),
                                label: const Text(
                                  'Valor (R\$)',
                                  textAlign: TextAlign.center,
                                )),
                            DataColumn(
                              onSort: (columnIndex, ascending) => setState(() {
                                sortColumnIndex = columnIndex;
                                isAscending = ascending;
                                ascending
                                    ? _movsStore.movs.sort(((b, a) => a
                                        .mov_type!
                                        .toString()
                                        .compareTo(b.mov_type!.toString())))
                                    : _movsStore.movs.sort(((a, b) => a
                                        .mov_type!
                                        .toString()
                                        .compareTo(b.mov_type!.toString())));
                              }),
                              label: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: iconSize),
                                child: const Text(
                                  'E/S',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                          rows: List<DataRow>.generate(
                              _movsStore.movs.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text(
                                      UtilData.obterDataDDMMAAAA(
                                          _movsStore.movs[index].data!),
                                    )),
                                    DataCell(
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: screenSize.width * 0.2),
                                          child: Text(
                                            _movsStore.movs[index].descricao!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onTap: (() => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  content: Text(_movsStore
                                                      .movs[index].descricao!),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                )))),
                                    DataCell(Text(
                                      UtilBrasilFields.obterReal(
                                          _movsStore.movs[index].valor!),
                                    )),
                                    DataCell(Text(
                                      _movsStore.movs[index].mov_type!
                                          ? 'E'
                                          : 'S',
                                    ))
                                  ])),
                        )
                      ],
                    ))
                  : const Center(child: CircularProgressIndicator());
            }),
          )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: 'Home',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Icon(
                Icons.home,
                size: iconSize,
              )),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton(
              heroTag: 'Debug',
              onPressed: () {
                print(
                    _entradaStore.entradaLoaded = !_entradaStore.entradaLoaded);
              },
              child: Icon(
                Icons.bug_report,
                size: iconSize,
              )),
        ],
      ),
    );
  }
}

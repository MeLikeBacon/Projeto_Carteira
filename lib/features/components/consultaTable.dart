import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/controllers/saida_controller.dart';
import 'package:provider/provider.dart';

import '../models/movimento_abs.dart';
import '../stores/entrada_store.dart';
import '../stores/movs_store.dart';
import '../stores/saida_store.dart';

class ConsultaTable extends StatefulWidget {
  ConsultaTable(
      {super.key, required this.view, required this.tableItems, required this.sortColumnIndex, required this.canEdit});

  String view;
  List<Movimento> tableItems;
  int sortColumnIndex;
  bool canEdit;

  @override
  State<ConsultaTable> createState() => _ConsultaTableState();
}

class _ConsultaTableState extends State<ConsultaTable> {
  var isAscending = true;

  final PessoaController _pessoaController = PessoaController();
  final EntradaController _entradaController = EntradaController();
  final SaidaController _saidaController = SaidaController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 10 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;

    List<DataColumn> tableColumns() {
      List<DataColumn> columns = [
        DataColumn(
            onSort: (columnIndex, ascending) => setState(() {
                  widget.sortColumnIndex = columnIndex;
                  isAscending = ascending;
                  ascending
                      ? widget.tableItems.sort(((a, b) => a.data!.compareTo(b.data!)))
                      : widget.tableItems.sort(((b, a) => a.data!.compareTo(b.data!)));
                }),
            label: const Text(
              'Data',
              textAlign: TextAlign.center,
            )),
        DataColumn(
            onSort: (columnIndex, ascending) => setState(() {
                  widget.sortColumnIndex = columnIndex;
                  isAscending = ascending;
                  ascending
                      ? widget.tableItems.sort(((a, b) => a.descricao!.compareTo(b.descricao!)))
                      : widget.tableItems.sort(((b, a) => a.descricao!.compareTo(b.descricao!)));
                }),
            label: const Text(
              'Descrição',
              textAlign: TextAlign.center,
            )),
        DataColumn(
            onSort: (columnIndex, ascending) => setState(() {
                  widget.sortColumnIndex = columnIndex;
                  isAscending = ascending;
                  ascending
                      ? widget.tableItems.sort(((a, b) => a.valor!.compareTo(b.valor!)))
                      : widget.tableItems.sort(((b, a) => a.valor!.compareTo(b.valor!)));
                }),
            label: const Text(
              'Valor\n(R\$)',
              textAlign: TextAlign.center,
            )),
      ];
      widget.view == 'Entradas e Saídas'
          ? columns.add(DataColumn(
              onSort: (columnIndex, ascending) => setState(() {
                widget.sortColumnIndex = columnIndex;
                isAscending = ascending;
                ascending
                    ? widget.tableItems.sort(((b, a) => a.mov_type!.toString().compareTo(b.mov_type!.toString())))
                    : widget.tableItems.sort(((a, b) => a.mov_type!.toString().compareTo(b.mov_type!.toString())));
              }),
              label: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: iconSize),
                child: const Text(
                  'E/S',
                  textAlign: TextAlign.center,
                ),
              ),
            ))
          : null;
      widget.canEdit ? columns.add(const DataColumn(label: Text(''))) : null;
      return columns;
    }

    List<DataCell> tableCells(int index) {
      List<DataCell> cells = [
        DataCell(Text(
          UtilData.obterDataDDMMAAAA(widget.tableItems[index].data!),
        )),
        DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.width * 0.15),
              child: Text(
                widget.tableItems[index].descricao!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: (() => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      content: Text(widget.tableItems[index].descricao!),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    )))),
        DataCell(Text(
          UtilBrasilFields.obterReal(widget.tableItems[index].valor!),
        )),
      ];

      widget.view == 'Entradas e Saídas'
          ? cells.add(DataCell(Text(
              widget.tableItems[index].mov_type! ? 'E' : 'S',
            )))
          : null;

      widget.canEdit
          ? cells.add(DataCell(IconButton(
              icon: Icon(
                Icons.settings,
                size: iconSize,
                color: Colors.black.withOpacity(.75),
              ),
              onPressed: () async {
                await showMovInfo(widget.tableItems[index], textSize, iconSize);
              },
            )))
          : null;

      return cells;
    }

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: widget.sortColumnIndex,
      showBottomBorder: true,
      columnSpacing: iconSize - 12,
      headingTextStyle: TextStyle(fontSize: textSize, color: Colors.black),
      dataTextStyle: TextStyle(fontSize: textSize, color: Colors.black.withOpacity(0.75)),
      columns: tableColumns(),
      rows: List<DataRow>.generate(widget.tableItems.length, (index) => DataRow(cells: tableCells(index))),
    );
  }

  showMovInfo(Movimento mov, double textSize, double iconSize) async {
    var user = await _pessoaController.findPessoaByID(mov.pessoa!);
    var resp = await _pessoaController.findPessoaByID(mov.responsavel!);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Informações do movimento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize + 4)),
        content: Wrap(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Usuário:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Responsável:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Data:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Valor:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                      Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${mov.codigo}', style: TextStyle(fontSize: textSize)),
                      Text(user.email!, style: TextStyle(fontSize: textSize)),
                      Text(resp.email!, style: TextStyle(fontSize: textSize)),
                      Text(UtilData.obterDataDDMMAAAA(mov.data!), style: TextStyle(fontSize: textSize)),
                      Text(UtilBrasilFields.obterReal(mov.valor!), style: TextStyle(fontSize: textSize)),
                      Text(mov.mov_type! ? 'Entrada' : 'Saída', style: TextStyle(fontSize: textSize)),
                      Text(mov.descricao!,
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: textSize)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, size: iconSize, color: Colors.blue.withOpacity(.75)),
            onPressed: () {
              print(widget.tableItems);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, size: iconSize, color: Colors.red.withOpacity(.75)),
            onPressed: () {
              mov.mov_type! ? _entradaController.deleteEntrada(mov.codigo!) : _saidaController.deleteSaida(mov.codigo!);

              setState(() {
                widget.tableItems.removeWhere((element) {
                  if (element.mov_type == mov.mov_type) {
                    return element.codigo == mov.codigo;
                  }
                  return false;
                });
              });
              Navigator.pop(context, 'OK');
            },
          ),
          IconButton(
            icon: Icon(Icons.keyboard_return, size: iconSize, color: Colors.black.withOpacity(.75)),
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
          )
        ],
      ),
    );
  }
}

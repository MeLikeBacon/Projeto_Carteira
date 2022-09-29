import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/movimento_abs.dart';
import '../stores/entrada_store.dart';
import '../stores/movs_store.dart';
import '../stores/saida_store.dart';

class consultaTable extends StatefulWidget {
  consultaTable(
      {super.key,
      required this.view,
      required this.tableItems,
      required this.sortColumnIndex});

  String view;
  List<Movimento> tableItems;
  int sortColumnIndex;

  @override
  State<consultaTable> createState() => _consultaTableState();
}

class _consultaTableState extends State<consultaTable> {
  var isAscending = true;

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
                      ? widget.tableItems
                          .sort(((a, b) => a.data!.compareTo(b.data!)))
                      : widget.tableItems
                          .sort(((b, a) => a.data!.compareTo(b.data!)));
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
                      ? widget.tableItems.sort(
                          ((a, b) => a.descricao!.compareTo(b.descricao!)))
                      : widget.tableItems.sort(
                          ((b, a) => a.descricao!.compareTo(b.descricao!)));
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
                      ? widget.tableItems
                          .sort(((a, b) => a.valor!.compareTo(b.valor!)))
                      : widget.tableItems
                          .sort(((b, a) => a.valor!.compareTo(b.valor!)));
                }),
            label: const Text(
              'Valor\n(R\$)',
              textAlign: TextAlign.center,
            )),
      ];
      widget.view == 'Tudo'
          ? columns.add(DataColumn(
              onSort: (columnIndex, ascending) => setState(() {
                widget.sortColumnIndex = columnIndex;
                isAscending = ascending;
                ascending
                    ? widget.tableItems.sort(((b, a) => a.mov_type!
                        .toString()
                        .compareTo(b.mov_type!.toString())))
                    : widget.tableItems.sort(((a, b) => a.mov_type!
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
            ))
          : null;
      return columns;
    }

    List<DataCell> tableCells(int index) {
      List<DataCell> cells = [
        DataCell(Text(
          UtilData.obterDataDDMMAAAA(widget.tableItems[index].data!),
        )),
        DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.width * 0.2),
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

      widget.view == 'Tudo'
          ? cells.add(DataCell(Text(
              widget.tableItems[index].mov_type! ? 'E' : 'S',
            )))
          : null;

      return cells;
    }

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: widget.sortColumnIndex,
      showBottomBorder: true,
      columnSpacing: iconSize - 2,
      headingTextStyle: TextStyle(fontSize: textSize, color: Colors.black),
      dataTextStyle:
          TextStyle(fontSize: textSize, color: Colors.black.withOpacity(0.75)),
      columns: tableColumns(),
      rows: List<DataRow>.generate(widget.tableItems.length,
          (index) => DataRow(cells: tableCells(index))),
    );
  }
}

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:projeto_carteira/features/components/consultaTable.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/stores/entrada_store.dart';
import 'package:projeto_carteira/features/stores/movs_store.dart';
import 'package:projeto_carteira/features/stores/saida_store.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  bool isAscending = true;
  int sortColumnIndex = 3;

  List<String> consultaItems = ['Tudo', 'Entradas', 'Saídas'];
  String? consultaDrop = 'Tudo';

  String dataRangeStart = '', dataRangeEnd = '';

  final TextEditingController _initialDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _entradaStore = Provider.of<EntradaStore>(context);
    _saidaStore = Provider.of<SaidaStore>(context);
    _movsStore = Provider.of<MovsStore>(context);
    _entradaStore.entradas.isEmpty ? _entradaStore.loadEntradas() : null;
    _saidaStore.saidas.isEmpty ? _saidaStore.loadSaidas() : null;
    _movsStore.movs.isEmpty ? _movsStore.loadMovs() : null;
  }

  final List<String> _range = ['', ''];
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range[0] = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        // ignore: lines_longer_than_80_chars
        _range[1] = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate);
      }
    });
    print('_range: $_range');
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 10 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;

    defineView() {
      switch (consultaDrop!) {
        case 'Tudo':
          return _movsStore.movs;
        case 'Entradas':
          return _entradaStore.entradas;
        case 'Saídas':
          return _saidaStore.saidas;
        default:
          return _movsStore.movs;
      }
    }

    return Scaffold(
      appBar: MyAppBar(
        title: 'Consulta',
      ),
      body: Center(
          heightFactor: 1,
          child: Observer(
            builder: ((context) {
              return _movsStore.movsLoaded &&
                      _saidaStore.saidaLoaded &&
                      _entradaStore.entradaLoaded
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          consultaTable(
                            view: consultaDrop!,
                            tableItems: defineView(),
                            sortColumnIndex: sortColumnIndex,
                          ),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator());
            }),
          )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30.0),
            child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  width: screenSize.width * 0.4,
                  child: DropdownButton<String>(
                    dropdownColor: Colors.blue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    value: consultaDrop,
                    onChanged: ((String? value) {
                      setState(() {
                        switch (value!) {
                          case 'Tudo':
                            sortColumnIndex = 3;
                            filterMovs();
                            break;
                          case 'Entradas':
                            sortColumnIndex = 0;
                            filterEntradas();
                            break;
                          case 'Saídas':
                            sortColumnIndex = 0;
                            filterSaidas();
                            break;
                        }
                        consultaDrop = value;
                      });
                    }),
                    items: consultaItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: textSize, color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
          Row(
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
              SpeedDial(
                icon: Icons.event,
                spaceBetweenChildren: 6,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.refresh),
                      onTap: () => setState(() {
                            filterMovs();
                            filterEntradas();
                            filterSaidas();
                          })),
                  SpeedDialChild(
                    child: const Icon(Icons.date_range),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Filtrar intervalo de tempo'),
                                content: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: 700, maxHeight: 300),
                                  child: Container(
                                    width: screenSize.width * 0.75,
                                    child: SfDateRangePicker(
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        dataRangeStart = _range[0];
                                        dataRangeEnd = _range[1];
                                        defineDataRange();
                                        Navigator.pop(context, 'FILTRAR');
                                      });
                                    },
                                    child: const Text('FILTRAR'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'CANCELAR');
                                    },
                                    child: const Text('CANCELAR'),
                                  ),
                                ],
                              ));
                    },
                  ),
                  SpeedDialChild(
                      child: const Text('7 dias'),
                      onTap: () => setState(() {
                            dataRangeStart = DateFormat('yyyy-MM-dd').format(
                                DateTime.now().add(const Duration(days: -7)));
                            dataRangeEnd =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            defineDataRange();
                          })),
                  SpeedDialChild(
                      child: const Text('15 dias'),
                      onTap: () => setState(() {
                            dataRangeStart = DateFormat('yyyy-MM-dd').format(
                                DateTime.now().add(const Duration(days: -15)));
                            dataRangeEnd =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            defineDataRange();
                          })),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  filterMovs({String initialDate = '', String finalDate = ''}) async {
    _movsStore.emptyMovs();
    await _movsStore.loadMovs(initialDate: initialDate, finalDate: finalDate);
  }

  filterEntradas({String initialDate = '', String finalDate = ''}) async {
    _entradaStore.emptyEntradas();
    await _entradaStore.loadEntradas(
        initialDate: initialDate, finalDate: finalDate);
  }

  filterSaidas({String initialDate = '', String finalDate = ''}) async {
    _saidaStore.emptySaidas();
    await _saidaStore.loadSaidas(
        initialDate: initialDate, finalDate: finalDate);
  }

  defineDataRange() {
    switch (consultaDrop) {
      case 'Tudo':
        filterMovs(initialDate: dataRangeStart, finalDate: dataRangeEnd);
        break;
      case 'Entradas':
        filterEntradas(initialDate: dataRangeStart, finalDate: dataRangeEnd);
        break;
      case 'Saídas':
        filterSaidas(initialDate: dataRangeStart, finalDate: dataRangeEnd);
        break;
    }
  }
}

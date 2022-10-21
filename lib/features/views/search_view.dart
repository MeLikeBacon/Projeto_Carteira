import 'package:flutter/material.dart';
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

import '../components/homeFAB.dart';
import '../models/pessoa_model.dart';
import '../stores/pessoas_store.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late EntradaStore _entradaStore;
  late SaidaStore _saidaStore;
  late MovsStore _movsStore;
  late PessoasStore _pessoasStore;

  bool isAscending = true;
  int sortColumnIndex = 3;

  List<String> consultaItems = ['Entradas e Saídas', 'Entradas', 'Saídas'];
  String? dropUsers, consultaDrop = 'Entradas e Saídas';

  String dataRangeStart = '', dataRangeEnd = '';
  int? selectedPersonId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _pessoasStore.pessoas.isEmpty ? _pessoasStore.loadPessoas() : null;
    _entradaStore = Provider.of<EntradaStore>(context);
    _saidaStore = Provider.of<SaidaStore>(context);
    _movsStore = Provider.of<MovsStore>(context);
    dropUsers = _pessoasStore.getLowerUsers().first.email;
    selectedPersonId = _pessoasStore.getLowerUsers().first.codigo;
    _entradaStore.entradas.isEmpty ? _entradaStore.loadEntradas(selectedPersonId!) : null;
    _saidaStore.saidas.isEmpty ? _saidaStore.loadSaidas(selectedPersonId!) : null;
    _movsStore.movs.isEmpty ? _movsStore.loadMovs(selectedPersonId!) : null;
  }

  final List<String> _range = ['', ''];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range[0] = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        // ignore: lines_longer_than_80_chars
        _range[1] = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
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
        case 'Entradas e Saídas':
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
        actions: [
          IconButton(
              onPressed: (() => Navigator.pushReplacementNamed(context, '/pdf')),
              icon: const Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Color.fromARGB(255, 10, 57, 95),
              )),
          IconButton(
              onPressed: (() => Navigator.pushReplacementNamed(context, '/plots')),
              icon: const Icon(
                Icons.query_stats,
                size: 40,
                color: Color.fromARGB(255, 10, 57, 95),
              ))
        ],
      ),
      body: Center(
          heightFactor: 1,
          child: Observer(
            builder: ((context) {
              return _movsStore.movsLoaded && _saidaStore.saidaLoaded && _entradaStore.entradaLoaded
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          _pessoasStore.currentUser.tipo == 'adm'
                              ? Container(
                                  constraints: const BoxConstraints(maxWidth: 500),
                                  width: screenSize.width * 0.9,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    value: dropUsers,
                                    hint: Text(
                                      'Usuário',
                                      style: TextStyle(fontSize: textSize),
                                    ),
                                    items: _pessoasStore.getLowerUsers().map((PessoaModel pessoa) {
                                      return DropdownMenuItem<String>(
                                          value: pessoa.email,
                                          child: Text(
                                            pessoa.email!,
                                            style: TextStyle(fontSize: textSize),
                                          ));
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropUsers = value ?? '';
                                        var resp =
                                            _pessoasStore.getLowerUsers().firstWhere((pessoa) => pessoa.email == value);
                                        selectedPersonId = resp.codigo;
                                      });
                                      setFilter(selectedPersonId!);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          ConsultaTable(
                            view: consultaDrop!,
                            tableItems: defineView(),
                            sortColumnIndex: sortColumnIndex,
                            canEdit: _pessoasStore.currentUser.tipo == 'adm',
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
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
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
                          case 'Entradas e Saídas':
                            sortColumnIndex = 3;
                            //filterMovs();
                            break;
                          case 'Entradas':
                            sortColumnIndex = 0;
                            //filterEntradas();
                            break;
                          case 'Saídas':
                            sortColumnIndex = 0;
                            //filterSaidas();
                            break;
                        }
                        consultaDrop = value;
                        setFilter(selectedPersonId!);
                      });
                    }),
                    items: consultaItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: textSize, color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
          Row(
            children: [
              HomeFAB(iconSize: iconSize),
              const SizedBox(
                width: 15,
              ),
              SpeedDial(
                icon: Icons.event,
                spaceBetweenChildren: 6,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.refresh),
                      onTap: () => setState(() {
                            setFilter(selectedPersonId!);
                          })),
                  SpeedDialChild(
                    child: const Icon(Icons.date_range),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Filtrar intervalo de tempo'),
                                content: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 700, maxHeight: 300),
                                  child: SizedBox(
                                    width: screenSize.width * 0.75,
                                    child: SfDateRangePicker(
                                      onSelectionChanged: _onSelectionChanged,
                                      selectionMode: DateRangePickerSelectionMode.range,
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
                            dataRangeStart =
                                DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -7)));
                            dataRangeEnd = DateFormat('yyyy-MM-dd').format(DateTime.now());
                            defineDataRange();
                          })),
                  SpeedDialChild(
                      child: const Text('15 dias'),
                      onTap: () => setState(() {
                            dataRangeStart =
                                DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -15)));
                            dataRangeEnd = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

  setFilter(int personID, {String initialDate = '', String finalDate = '', bool clean = false}) async {
    if (clean) {
      _movsStore.emptyMovs();
      await _movsStore.loadMovs(personID, initialDate: initialDate, finalDate: finalDate);
      _entradaStore.emptyEntradas();
      await _entradaStore.loadEntradas(personID, initialDate: initialDate, finalDate: finalDate);
      _saidaStore.emptySaidas();
      await _saidaStore.loadSaidas(personID, initialDate: initialDate, finalDate: finalDate);
    } else {
      switch (consultaDrop) {
        case 'Entradas e Saídas':
          _movsStore.emptyMovs();
          await _movsStore.loadMovs(personID, initialDate: initialDate, finalDate: finalDate);
          break;
        case 'Entradas':
          _entradaStore.emptyEntradas();
          await _entradaStore.loadEntradas(personID, initialDate: initialDate, finalDate: finalDate);
          break;
        case 'Saídas':
          _saidaStore.emptySaidas();
          await _saidaStore.loadSaidas(personID, initialDate: initialDate, finalDate: finalDate);
          break;
      }
    }
    print('filtrado');
  }

  defineDataRange() {
    setFilter(selectedPersonId!, initialDate: dataRangeStart, finalDate: dataRangeEnd);
  }
}

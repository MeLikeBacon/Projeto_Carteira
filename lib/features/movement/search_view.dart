import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/movement/components/consultaTable.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/movement/stores/movs_store.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/homeFAB.dart';
import '../account/models/pessoa_model.dart';
import '../account/stores/pessoas_store.dart';
import 'stores/entrada_store.dart';
import 'stores/saida_store.dart';

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

  final PessoaController _pessoaController = PessoaController();

  bool isAscending = true;
  int sortColumnIndex = 3;

  String dataRangeStart = '', dataRangeEnd = '';

  List<String> consultaItems = ['Entradas e Saídas', 'Entradas', 'Saídas'];
  String? consultaDrop = 'Entradas e Saídas';
  String dropUsers = '';
  int selectedPersonId = 0;

  int storeCanLoad = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    _pessoasStore.loadPessoas();
    _entradaStore = Provider.of<EntradaStore>(context);
    _saidaStore = Provider.of<SaidaStore>(context);
    _movsStore = Provider.of<MovsStore>(context);

    await _pessoasStore.setFirstUser();

    if (_pessoasStore.currentUser.tipo == 'adm') {
      if (_pessoasStore.firstLowerUser.codigo != null) {
        dropUsers = _pessoasStore.firstLowerUser.email!;
        selectedPersonId = _pessoasStore.firstLowerUser.codigo!;
      }
    } else {
      dropUsers = _pessoasStore.currentUser.email!;
      selectedPersonId = _pessoasStore.currentUser.codigo!;
    }

    // print(_pessoasStore.firstLowerUser)

    storeCanLoad == 0 ? _entradaStore.loadEntradas(selectedPersonId) : null;
    storeCanLoad == 0 ? _saidaStore.loadSaidas(selectedPersonId) : null;
    storeCanLoad == 0 ? _movsStore.loadMovs(selectedPersonId) : null;
    storeCanLoad++;
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

    getMovTypeByLabel() {
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
              return _movsStore.movsLoaded &&
                      _saidaStore.saidaLoaded &&
                      _entradaStore.entradaLoaded &&
                      selectedPersonId != 0
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
                                    onChanged: (String? value) async {
                                      var resp = await _pessoaController.findLowerPessoaByEmail(value!, 'adm');
                                      selectedPersonId = resp!.codigo!;
                                      setState(() {
                                        dropUsers = value;
                                      });
                                      setFilter();
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          ConsultaTable(
                            view: consultaDrop!,
                            tableItems: getMovTypeByLabel(),
                            sortColumnIndex: sortColumnIndex,
                            canEdit: _pessoasStore.currentUser.tipo == 'adm',
                          ),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: selectedPersonId == 0
                          ? const Text('Nenhum usuário encontrado')
                          : const CircularProgressIndicator());
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
                        sortColumnIndex = value == 'Entradas e Saídas' ? 3 : 0;
                        consultaDrop = value;
                        setFilter();
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
                            setFilter();
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
                                      setFilter(initialDate: _range[0], finalDate: _range[1]);
                                      Navigator.pop(context, 'FILTRAR');
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
                      onTap: () => setFilter(
                          initialDate: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -7))),
                          finalDate: DateFormat('yyyy-MM-dd').format(DateTime.now()))),
                  SpeedDialChild(
                      child: const Text('15 dias'),
                      onTap: () => setFilter(
                          initialDate: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: -15))),
                          finalDate: DateFormat('yyyy-MM-dd').format(DateTime.now()))),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  setFilter({String initialDate = '', String finalDate = ''}) async {
    switch (consultaDrop) {
      case 'Entradas e Saídas':
        await _movsStore.loadMovs(selectedPersonId, initialDate: initialDate, finalDate: finalDate);
        break;
      case 'Entradas':
        await _entradaStore.loadEntradas(selectedPersonId, initialDate: initialDate, finalDate: finalDate);
        break;
      case 'Saídas':
        await _saidaStore.loadSaidas(selectedPersonId, initialDate: initialDate, finalDate: finalDate);
        break;
    }
  }
}

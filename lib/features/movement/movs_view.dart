import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:projeto_carteira/features/account/controllers/pessoa_controller.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:provider/provider.dart';

import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/movement/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/movement/controllers/saida_controller.dart';
import 'package:projeto_carteira/features/movement/models/entrada_model.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/homeFAB.dart';
import 'models/saida_model.dart';

class MovsView extends StatefulWidget {
  const MovsView({super.key});

  @override
  State<MovsView> createState() => _MovsViewState();
}

class _MovsViewState extends State<MovsView> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final PessoaController _pessoaController = PessoaController();

  late PessoasStore _pessoasStore;

  final EntradaController _entradaController = EntradaController();
  final SaidaController _saidaController = SaidaController();

  String? errorTextUser, errorTextDate, errorTextValue, dropUsers;

  bool sameUser = false;

  PessoaModel contaMovimento = PessoaModel();

  int i = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    i == 0 ? _pessoasStore.loadPessoas() : null;
    i++;

    if (contaMovimento.codigo == null) {
      await setPersonAffected(_pessoasStore.currentUser.codigo!);
    }
  }

  setPersonAffected(int conta) async {
    contaMovimento = (await _pessoaController.findPessoaByID(conta))!;
    sameUser = contaMovimento.codigo == _pessoasStore.currentUser.codigo;
    print('Current: ${_pessoasStore.currentUser.codigo!}');
    print('Owner: $contaMovimento');
  }

  String? _selectedDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      _selectedDate = DateFormat('dd-MM-yyyy').format(args.value);
      print(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 12 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
        appBar: MyAppBar(
          title: 'Movimentar',
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            width: screenSize.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Observer(builder: (context) {
                    return _pessoasStore.pessoaLoaded && _pessoasStore.currentUser.tipo == 'adm'
                        ? Column(
                            children: [
                              DropdownButton(
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
                                  var resp = await _pessoaController.findPessoaByEmail(value!);
                                  setState(() {
                                    dropUsers = value;
                                    setPersonAffected(resp!.codigo!);
                                  });
                                },
                              ),
                              errorTextUser != null
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        errorTextUser ?? '',
                                        style: TextStyle(fontSize: textSize - 2, color: Colors.red),
                                      ))
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox();
                  }),
                  TextFormField(
                    controller: _valueController,
                    style: TextStyle(fontSize: textSize),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CentavosInputFormatter()],
                    decoration: InputDecoration(
                      errorText: errorTextValue,
                      labelText: 'Valor (R\$)',
                      suffixIcon: IconButton(
                        onPressed: _valueController.clear,
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    height: 220,
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                  ),
                  errorTextDate != null
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(errorTextDate ?? '', style: TextStyle(fontSize: textSize - 2, color: Colors.red)))
                      : const SizedBox(),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Descrição da movimentação',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Theme.of(context).hintColor, fontSize: textSize),
                          ),
                        ),
                        TextFormField(
                          controller: _descController,
                          style: TextStyle(fontSize: textSize),
                          minLines: 4,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _descController.clear,
                              icon: Icon(Icons.cancel_outlined, size: iconSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (!isFieldNull()) {
                              EntradaModel tempEntrada = EntradaModel(
                                  pessoa: contaMovimento.codigo,
                                  responsavel: _pessoasStore.currentUser.codigo,
                                  data_entrada: UtilData.obterDateTime(_selectedDate!),
                                  descricao: _descController.text,
                                  valor: UtilBrasilFields.converterMoedaParaDouble(_valueController.text));

                              _entradaController.insertEntrada(tempEntrada, contaMovimento);

                              sameUser ? _pessoasStore.currentUser = contaMovimento : null;
                            }
                          },
                          style: ButtonStyle(elevation: MaterialStateProperty.all(7.5)),
                          child: Icon(
                            Icons.add,
                            size: iconSize + 20,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (!isFieldNull()) {
                              SaidaModel tempSaida = SaidaModel(
                                  pessoa: contaMovimento.codigo,
                                  responsavel: _pessoasStore.currentUser.codigo,
                                  data_saida: UtilData.obterDateTime(_selectedDate!),
                                  descricao: _descController.text,
                                  valor: UtilBrasilFields.converterMoedaParaDouble(_valueController.text));

                              if (contaMovimento.saldo! -
                                      UtilBrasilFields.converterMoedaParaDouble(_valueController.text) <
                                  contaMovimento.minimo!) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Aviso de consumo!'),
                                          content: Text(
                                              'Fazer essa movimentação deixará seu saldo abaixo do seu mínimo definido de '
                                              '${UtilBrasilFields.obterReal(_pessoasStore.currentUser.minimo!)}, deseja continuar?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'SIM');
                                                _saidaController.insertSaida(tempSaida, contaMovimento);
                                              },
                                              child: const Text('SIM'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'NÃO');
                                              },
                                              child: const Text('NÃO'),
                                            ),
                                          ],
                                        ));
                              } else {
                                _saidaController.insertSaida(tempSaida, contaMovimento);
                                sameUser ? _pessoasStore.currentUser = contaMovimento : null;
                              }
                            }
                          },
                          style: ButtonStyle(elevation: MaterialStateProperty.all(7.5)),
                          child: Icon(
                            Icons.remove,
                            size: iconSize + 20,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: HomeFAB(iconSize: iconSize));
  }

  bool isFieldNull() {
    var n = 0;

    setState(() {
      if (dropUsers == null && _pessoasStore.currentUser.tipo == 'adm') {
        errorTextUser = 'Escolha um usuário';

        n++;
      } else {
        errorTextUser = null;
      }

      if (_valueController.text.isEmpty) {
        errorTextValue = 'Preencha este campo';

        n++;
      } else {
        errorTextValue = null;
      }
      if (_selectedDate == null) {
        errorTextDate = 'Escolha uma data';

        n++;
      } else {
        errorTextDate = null;
      }
    });
    return n > 0;
  }
}

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_carteira/features/account/models/pessoa_model.dart';
import 'package:provider/provider.dart';

import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/movement/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/movement/controllers/saida_controller.dart';
import 'package:projeto_carteira/features/movement/models/entrada_model.dart';
import 'package:projeto_carteira/features/account/stores/pessoas_store.dart';

import '../components/homeFAB.dart';
import 'models/saida_model.dart';

class MovsView extends StatefulWidget {
  const MovsView({super.key});

  @override
  State<MovsView> createState() => _MovsViewState();
}

class _MovsViewState extends State<MovsView> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  late PessoasStore _pessoasStore;

  final EntradaController _entradaController = EntradaController();
  final SaidaController _saidaController = SaidaController();

  String? errorTextDate, errorTextValue, dropUsers;

  bool sameUser = false;

  PessoaModel contaMovimento = PessoaModel();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
    await _pessoasStore.loadPessoas();

    if (contaMovimento.codigo == null && _pessoasStore.pessoaLoaded) {
      setPersonAffected(_pessoasStore.currentUser.codigo!);
    }
  }

  setPersonAffected(int conta) {
    contaMovimento = _pessoasStore.pessoas.singleWhere((element) => conta == element.codigo);
    sameUser = contaMovimento.codigo == _pessoasStore.currentUser.codigo;
    print('Current: ${_pessoasStore.currentUser.codigo!}');
    print('Responsible: $contaMovimento');
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
          heightFactor: 1.2,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Observer(builder: ((context) {
                return _pessoasStore.pessoaLoaded && _pessoasStore.currentUser.tipo == 'adm'
                    ? Column(
                        children: [
                          dropUsers == null
                              ? Text(
                                  'Um usuário precisa ser definido.',
                                  style: TextStyle(fontSize: textSize - 2, color: Colors.red),
                                )
                              : const SizedBox(),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 700),
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
                                  var resp = _pessoasStore.pessoas.firstWhere((pessoa) => pessoa.email == value);
                                  setPersonAffected(resp.codigo!);
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox();
              })),
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                width: screenSize.width * 0.9,
                child: TextFormField(
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
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: screenSize.width * 0.75,
                child: TextFormField(
                  controller: _dateController,
                  style: TextStyle(fontSize: textSize),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, DataInputFormatter()],
                  decoration: InputDecoration(
                    errorText: errorTextDate,
                    labelText: 'Data (DD/MM/AAAA)',
                    suffixIcon: IconButton(
                      onPressed: _dateController.clear,
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: screenSize.width * 0.9,
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
                        //errorText: '',
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (filledForms()) {
                          EntradaModel tempEntrada = EntradaModel(
                              pessoa: contaMovimento.codigo,
                              responsavel: _pessoasStore.currentUser.codigo,
                              data_entrada: UtilData.obterDateTime(_dateController.text),
                              descricao: _descController.text,
                              valor: UtilBrasilFields.converterMoedaParaDouble(_valueController.text));

                          setState(() {
                            if (validDate()) {
                              _entradaController.insertEntrada(tempEntrada, contaMovimento);
                              if (sameUser) {
                                _pessoasStore.currentUser = contaMovimento;
                              }
                              errorTextDate = null;
                            } else {
                              errorTextDate = 'Data inválida';
                            }
                          });
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
                        if (filledForms()) {
                          SaidaModel tempSaida = SaidaModel(
                              pessoa: contaMovimento.codigo,
                              responsavel: _pessoasStore.currentUser.codigo,
                              data_saida: UtilData.obterDateTime(_dateController.text),
                              descricao: _descController.text,
                              valor: UtilBrasilFields.converterMoedaParaDouble(_valueController.text));

                          setState(() {
                            if (validDate()) {
                              errorTextDate = null;
                              if (contaMovimento.saldo! -
                                      UtilBrasilFields.converterMoedaParaDouble(_valueController.text) <
                                  contaMovimento.minimo!) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Aviso de consumo!'),
                                          content: Text(
                                              'Fazer essa movimentação deixará seu saldo abaixo do seu mínimo definido de ${UtilBrasilFields.obterReal(_pessoasStore.currentUser.minimo!.toDouble())}, deseja continuar?'),
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
                                if (sameUser) {
                                  _pessoasStore.currentUser = contaMovimento;
                                }
                              }
                              errorTextDate = null;
                            } else {
                              errorTextDate = 'Data inválida';
                            }
                          });
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
          )),
        ),
        floatingActionButton: HomeFAB(iconSize: iconSize));
  }

  bool filledForms() {
    if (_dateController.text == '' || _valueController.text == '') {
      setState(() {
        if (_valueController.text == '') {
          errorTextValue = 'Insira um valor';
        }
        if (_dateController.text == '') {
          errorTextDate = 'Insira uma data';
        }
      });
      return false;
    } else {
      errorTextDate = null;
      errorTextValue = null;
      if (dropUsers == null && _pessoasStore.currentUser.tipo == 'adm') {
        return false;
      }
      return true;
    }
  }

  validDate() {
    if ((UtilData.obterDia(_dateController.text)! < 1 || UtilData.obterDia(_dateController.text)! > 31) ||
        (UtilData.obterMes(_dateController.text)! < 1 || UtilData.obterMes(_dateController.text)! > 12)) {
      return false;
    } else {
      return true;
    }
  }
}

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:projeto_carteira/features/controllers/entrada_controller.dart';
import 'package:projeto_carteira/features/controllers/saida_controller.dart';
import 'package:projeto_carteira/features/models/entrada_model.dart';
import 'package:projeto_carteira/features/stores/pessoas_store.dart';

import '../models/saida_model.dart';

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

  String? ErrorTextDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pessoasStore = Provider.of<PessoasStore>(context);
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SizedBox(
                width: screenSize.width * 0.9,
                child: TextFormField(
                  controller: _valueController,
                  style: TextStyle(fontSize: textSize),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter()
                  ],
                  decoration: InputDecoration(
                    //errorText: '',
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
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: screenSize.width * 0.75,
                child: TextFormField(
                  controller: _dateController,
                  style: TextStyle(fontSize: textSize),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter()
                  ],
                  decoration: InputDecoration(
                    errorText: ErrorTextDate,
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
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: screenSize.width * 0.9,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Descrição da movimentação',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: textSize),
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
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      EntradaModel tempEntrada = EntradaModel(
                          pessoa: _pessoasStore.currentUser.codigo,
                          data_entrada:
                              UtilData.obterDateTime(_dateController.text),
                          descricao: _descController.text,
                          valor: UtilBrasilFields.converterMoedaParaDouble(
                              _valueController.text));

                      setState(() {
                        if (validDate()) {
                          _entradaController.insertEntrada(
                              tempEntrada, _pessoasStore.currentUser);
                          ErrorTextDate = null;
                        } else {
                          ErrorTextDate = 'Data inválida';
                        }
                      });
                    },
                    style:
                        ButtonStyle(elevation: MaterialStateProperty.all(7.5)),
                    child: Icon(
                      Icons.add,
                      size: iconSize + 20,
                    )),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      SaidaModel tempSaida = SaidaModel(
                          pessoa: _pessoasStore.currentUser.codigo,
                          data_saida:
                              UtilData.obterDateTime(_dateController.text),
                          descricao: _descController.text,
                          valor: UtilBrasilFields.converterMoedaParaDouble(
                              _valueController.text));

                      setState(() {
                        if (validDate()) {
                          _saidaController.insertSaida(
                              tempSaida, _pessoasStore.currentUser);
                          ErrorTextDate = null;
                        } else {
                          ErrorTextDate = 'Data inválida';
                        }
                      });
                    },
                    style:
                        ButtonStyle(elevation: MaterialStateProperty.all(7.5)),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.home,
            size: iconSize,
          )),
    );
  }

  validDate() {
    if ((UtilData.obterDia(_dateController.text)! < 1 ||
            UtilData.obterDia(_dateController.text)! > 31) ||
        (UtilData.obterMes(_dateController.text)! < 1 ||
            UtilData.obterMes(_dateController.text)! > 12)) {
      return false;
    } else {
      return true;
    }
  }
}

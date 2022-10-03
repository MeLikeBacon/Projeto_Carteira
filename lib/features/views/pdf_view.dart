import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:provider/provider.dart';

import '../pdf_invoice.dart';
import '../stores/entrada_store.dart';
import '../stores/movs_store.dart';
import '../stores/saida_store.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  late EntradaStore _entradaStore;
  late SaidaStore _saidaStore;
  late MovsStore _movsStore;

  String? consultaDrop = 'Entradas e Saídas';
  List<String> consultaItems = ['Entradas e Saídas', 'Entradas', 'Saídas'];

  int number = 0;

  String? filePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _entradaStore = Provider.of<EntradaStore>(context);
    _saidaStore = Provider.of<SaidaStore>(context);
    _movsStore = Provider.of<MovsStore>(context);
    // _entradaStore.entradas.isEmpty ? _entradaStore.loadEntradas() : null;
    // _saidaStore.saidas.isEmpty ? _saidaStore.loadSaidas() : null;
    // _movsStore.movs.isEmpty ? _movsStore.loadMovs() : null;
  }

  final PdfInvoiceService service = PdfInvoiceService();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textSize = 10 + MediaQuery.of(context).size.width * 0.0075;
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Exportar para PDF',
        actions: [
          IconButton(
              onPressed: (() =>
                  Navigator.pushReplacementNamed(context, '/search')),
              icon: const Icon(
                Icons.receipt_long,
                size: 40,
                color: Color.fromARGB(255, 10, 57, 95),
              ))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.only(top: 10),
          width: screenSize.width * 0.75,
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 7.5),
              child: const Text(
                'Exportar a tabela de:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
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
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 15, bottom: 7.5),
              child: const Text(
                'Itens a exportar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue)),
                    onPressed: () async {
                      final data;
                      setState(() {
                        filePath = null;
                      });

                      switch (consultaDrop!) {
                        case 'Entradas e Saídas':
                          await _movsStore.emptyMovs();
                          await _movsStore.loadMovs();
                          data =
                              await service.createMovsInvoice(_movsStore.movs);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                        case 'Entradas':
                          await _entradaStore.emptyEntradas();
                          await _entradaStore.loadEntradas();
                          data = await service
                              .createSpecificInvoice(_entradaStore.entradas);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                        case 'Saídas':
                          await _saidaStore.emptySaidas();
                          await _saidaStore.loadSaidas();
                          data = await service
                              .createSpecificInvoice(_saidaStore.saidas);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                      }
                      final snackBar = SnackBar(
                        content: Text("Relatório salvo em '$filePath'"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      number++;
                    },
                    child: const Text('Todos'),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue)),
                    onPressed: () async {
                      final data;
                      setState(() {
                        filePath = null;
                      });

                      switch (consultaDrop!) {
                        case 'Entradas e Saídas':
                          data =
                              await service.createMovsInvoice(_movsStore.movs);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                        case 'Entradas':
                          data = await service
                              .createSpecificInvoice(_entradaStore.entradas);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                        case 'Saídas':
                          data = await service
                              .createSpecificInvoice(_saidaStore.saidas);
                          filePath = await service.savePdfFile(
                              "relatorio_$number", data);
                          setState(() {});
                          break;
                      }
                      final snackBar = SnackBar(
                        content: Text("Relatório salvo em '$filePath'"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      number++;
                    },
                    child: const Text('Selecionados'),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 30),
              child: const Text(
                "Se você não filtrou itens na tela de consulta, a opção de 'Selecionados' retornará a tabela inteira.\n" +
                    "Você pode clicar no ícone no canto direito da barra de navegação para acessar a tela de consulta.",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            filePath != null
                ? Column(
                    children: [
                      Text('Preview:'),
                      SizedBox(
                          width: screenSize.width * 0.75,
                          height: screenSize.width * 0.75 * 1.414,
                          child: PdfView(path: filePath!)),
                    ],
                  )
                : const SizedBox()
          ]),
        )),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'Home',
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.home,
            size: iconSize,
          )),
    );
  }
}

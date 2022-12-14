import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'movement/models/movimento_abs.dart';

// final pdfPinchController = pdfx.PdfControllerPinch(
//   document: pdfx.PdfDocument.openAsset('assets/sample.pdf'),
// );

class CustomRow {
  final String itemDate;
  final String itemDesc;
  final String itemValue;
  final String? itemType;

  CustomRow(this.itemDate, this.itemDesc, this.itemValue, [this.itemType]);
}

class PdfInvoiceService {
  // To test PDF library
  Future<Uint8List> createHelloWorld() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Text('Hello World'));
        },
      ),
    );

    return pdf.save();
  }

  // Actual function you're supposed to use
  Future<Uint8List> createMovsInvoice(List<Movimento> movs) {
    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow('Data (dd/mm/aaaa)', 'Descrição', 'Valor (R\$)', 'E/S'),
      for (var movimento in movs)
        CustomRow(UtilData.obterDataDDMMAAAA(movimento.data!), movimento.descricao!,
            UtilBrasilFields.obterReal(movimento.valor!), movimento.mov_type! ? 'E' : 'S'),
      CustomRow('Soma total', '', '', UtilBrasilFields.obterReal(getSumTotal(movs)!))
    ];

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(children: [itemColumn(elements, true)]);
      },
    ));

    return pdf.save();
  }

  Future<Uint8List> createSpecificInvoice(List<Movimento> specifics) {
    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow('Data (dd/mm/aaaa)', 'Descrição', 'Valor (R\$)'),
      for (var specific in specifics)
        CustomRow(
          UtilData.obterDataDDMMAAAA(specific.data!),
          specific.descricao!,
          UtilBrasilFields.obterReal(specific.valor!),
        ),
      CustomRow('Soma total', '', UtilBrasilFields.obterReal(getSumTotal(specifics)!))
    ];

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(children: [itemColumn(elements, false)]);
      },
    ));

    return pdf.save();
  }

  Future<String> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getApplicationDocumentsDirectory();
    var filePath = '${output.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(byteList);

    print(filePath);
    return filePath;
  }

  pw.Expanded itemColumn(List<CustomRow> elements, bool fourColumns) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Column(children: [
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text(element.itemDate,
                          textAlign: pw.TextAlign.left,
                          style:
                              TextStyle(fontWeight: element == elements.first ? FontWeight.bold : FontWeight.normal))),
                  pw.Expanded(
                      child: pw.Text(element.itemDesc,
                          textAlign: pw.TextAlign.right,
                          style:
                              TextStyle(fontWeight: element == elements.first ? FontWeight.bold : FontWeight.normal))),
                  pw.Expanded(
                      child: pw.Text(element.itemValue,
                          textAlign: pw.TextAlign.right,
                          style:
                              TextStyle(fontWeight: element == elements.first ? FontWeight.bold : FontWeight.normal))),
                  fourColumns
                      ? pw.Expanded(
                          child: pw.Text(element.itemType!,
                              textAlign: pw.TextAlign.right,
                              style: TextStyle(
                                  fontWeight: element == elements.first ? FontWeight.bold : FontWeight.normal)))
                      : pw.Container(),
                ],
              ),
              pw.SizedBox(height: 15),
            ])
        ],
      ),
    );
  }

  getSumTotal(List<Movimento> items) {
    return items.fold(
        0.0, (previousValue, element) => previousValue + (element.mov_type! ? element.valor! : -element.valor!));
  }
}

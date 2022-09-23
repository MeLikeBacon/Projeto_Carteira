import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: SingleChildScrollView(child: Column()),
      ),
    );
  }
}

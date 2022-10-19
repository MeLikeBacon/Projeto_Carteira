import 'package:flutter/material.dart';
import 'package:projeto_carteira/features/components/lineChartWidget.dart';
import 'package:projeto_carteira/features/components/myAppBar.dart';
import 'package:provider/provider.dart';

import '../components/homeFAB.dart';
import '../stores/movs_store.dart';

class PlotsView extends StatefulWidget {
  const PlotsView({super.key});

  @override
  State<PlotsView> createState() => _PlotsViewState();
}

class _PlotsViewState extends State<PlotsView> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var iconSize = 25 + MediaQuery.of(context).size.width * 0.0075;

    return Scaffold(
        appBar: MyAppBar(
          title: 'Gráficos',
          actions: [
            IconButton(
                onPressed: (() => Navigator.pushReplacementNamed(context, '/search')),
                icon: const Icon(
                  Icons.receipt_long,
                  size: 40,
                  color: Color.fromARGB(255, 10, 57, 95),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              heightFactor: 2,
              child: Column(
                children: [
                  ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: LineChartWidget()),
                ],
              )),
        ),
        floatingActionButton: HomeFAB(iconSize: iconSize));
  }
}

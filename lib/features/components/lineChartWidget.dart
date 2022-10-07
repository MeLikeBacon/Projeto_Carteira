import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/movs_store.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late MovsStore _movsStore;

  bool loaded = false;

  late List<SalesData> chartData = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _movsStore = Provider.of<MovsStore>(context);

    if (!loaded) {
      for (var i = 0; i < _movsStore.movs.length; i++) {
        chartData.add(SalesData(
            _movsStore.movsDates[i], _movsStore.movsValuesPercent[i]));
      }
    }
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: loaded
            ? SfCartesianChart(
                title: ChartTitle(text: 'Saldo ao longo do tempo'),
                legend: Legend(
                    title: LegendTitle(
                  text: 'Saldo Total',
                )),
                primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Data')),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Valor(R\$)'),
                    labelFormat: 'R\$ {value},00'),
                series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<SalesData, DateTime>(
                        xAxisName: 'Data',
                        yAxisName: 'Valor (R\$)',
                        legendItemText: 'Saldo Total',
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.value)
                  ])
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class SalesData {
  SalesData(this.year, this.value);
  final DateTime year;
  final double value;
}

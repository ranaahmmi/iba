import 'package:flutter/material.dart';
import 'package:iba/helper/header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class SaleTargetChart extends StatelessWidget {
  const SaleTargetChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const HeaderWidget(
              title: 'Target Report',
              isShowCart: false,
            ),
            SfCircularChart(
              title: ChartTitle(text: 'Sales Target'),
              series: <CircularSeries>[
                // Renders doughnut chart
                DoughnutSeries<ChartData, String>(
                    dataSource: <ChartData>[
                      ChartData(
                          'David', 25, const Color.fromRGBO(9, 0, 136, 1)),
                      ChartData(
                          'Steve', 38, const Color.fromRGBO(147, 0, 119, 1)),
                      ChartData(
                          'Jack', 34, const Color.fromRGBO(228, 0, 124, 1)),
                      ChartData(
                          'Others', 52, const Color.fromRGBO(255, 189, 57, 1))
                    ],
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    animationDelay: 1000,
                    animationDuration: 2000,
                    explode: true,
                    explodeAll: true,
                    radius: '80%',
                    explodeIndex: 1)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

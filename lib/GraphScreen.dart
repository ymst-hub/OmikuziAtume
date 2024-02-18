import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'DbHelper.dart';
import 'lib.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});
  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  var allData = <Map<String, dynamic>>[];
  @override
  void initState() {
    super.initState();
    //全件を取得
    _countResultAndSelfResult();
  }

  @override
  void didUpdateWidget(covariant GraphScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _countResultAndSelfResult();
  }

  void _countResultAndSelfResult() async {
    DbHelper().getHakkeMainByResultAndSelfResult().then((value) {
      setState(() {
        allData = value;
      });
    });
  }

  double _createRadius(double count) {
    if (count == 0) return 0;
    if (count > 200) return 200;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  child: const Text('当たってない'),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 20, top: 20),
                  child: const Text('当たっている'),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            alignment: Alignment.centerRight,
            child: const Text('大吉'),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(40),
              child: ScatterChart(
                ScatterChartData(
                  minX: -0.5,
                  maxX: lib.selfResultList.length.toDouble() - 0.5,
                  minY: -0.5,
                  maxY: lib.resultList.length.toDouble() - 0.5,
                  scatterSpots: [
                    for (var data in allData)
                      ScatterSpot(
                        data['selfResult'].toDouble(),
                        data['result'].toDouble(),
                        dotPainter: FlDotCirclePainter(
                          color: lib.omikuziColor[data['result']],
                          radius: _createRadius(data['count'].toDouble()),
                          strokeWidth: 1,
                          strokeColor: lib.omikuziColor[data['result']],
                        ),
                      ),
                  ],
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: const FlGridData(
                    show: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                  ),
                  titlesData: const FlTitlesData(
                    show: false,
                  ),
                  scatterTouchData: ScatterTouchData(
                    enabled: true,
                    touchTooltipData: ScatterTouchTooltipData(
                      tooltipBgColor: Colors.white,
                    ),
                  ),
                ),
                swapAnimationDuration:
                    const Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear, // Optional
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              child: const Text('大凶')),
        ],
      ),
    );
  }
}

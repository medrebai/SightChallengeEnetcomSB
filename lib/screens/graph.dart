  import 'package:flutter/material.dart';
  import 'package:syncfusion_flutter_charts/charts.dart';
  import 'package:syncfusion_flutter_charts/sparkcharts.dart';

  class Stats extends StatefulWidget {
    Stats({Key? key}) : super(key: key);

    @override
    _StatsState createState() => _StatsState();
  }

    class _StatsState extends State<Stats> {
      List<_SalesData> data = [
            _SalesData('Jan', 150),
    _SalesData('Feb', 130),
    _SalesData('Mar', 140),
    _SalesData('Apr', 160),
    _SalesData('May', 180),
      ];

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Electricity Consumption by Month'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Electricity Consumption Chart
                  Card(
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Initialize the chart widget
                          SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(text: 'Electricity Consumption kwh/month'),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                dataSource: data,
                                xValueMapper: (_SalesData sales, _) => sales.year,
                                yValueMapper: (_SalesData sales, _) => sales.sales,
                                name: 'Electricity Consumption',
                                color: Colors.green,
                                // Enable data label
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                          // Legend below the chart
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Electricity Consumption',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Sparkline Chart
                  Card(
                    elevation: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Initialize the spark charts widget
                          SfSparkLineChart.custom(
                            // Enable the trackball
                            trackball: const SparkChartTrackball(
                              activationMode: SparkChartActivationMode.tap,
                            ),
                            // Enable marker
                            marker: const SparkChartMarker(
                              displayMode: SparkChartMarkerDisplayMode.all,
                            ),
                            // Enable data label
                            labelDisplayMode: SparkChartLabelDisplayMode.all,
                            xValueMapper: (int index) => data[index].year,
                            yValueMapper: (int index) => data[index].sales,
                            dataCount: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    class _SalesData {
      _SalesData(this.year, this.sales);

      final String year;
      final double sales;
    }
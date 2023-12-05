  import 'package:flutter/material.dart';
  import 'package:syncfusion_flutter_charts/charts.dart';
  import 'package:syncfusion_flutter_charts/sparkcharts.dart';

  class Stats1 extends StatefulWidget {
    Stats1({Key? key}) : super(key: key);

    @override
    _Stats1State createState() => _Stats1State();
  }

    class _Stats1State extends State<Stats1> {
      List<_SalesData> data = [
       _SalesData('Jan', 30),
    _SalesData('Feb', 28),
    _SalesData('Mar', 32),
    _SalesData('Apr', 35),
    _SalesData('May', 40),
      ];

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Water Consumption by Month'),
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
                            title: ChartTitle(text: 'Water Consumption CubicMeter/month'),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                dataSource: data,
                                xValueMapper: (_SalesData sales, _) => sales.year,
                                yValueMapper: (_SalesData sales, _) => sales.sales,
                                name: 'Water Consumption',
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
                                  'Water Consumption',
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
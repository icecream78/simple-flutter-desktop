import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TempToHourChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TempToHourChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory TempToHourChart.withSampleData() {
    return new TempToHourChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  static List<charts.Series<TempToHour, int>> _createSampleData() {
    final data = [
      new TempToHour(0, 5),
      new TempToHour(1, 25),
      new TempToHour(2, 100),
      new TempToHour(3, 75),
    ];

    return [
      new charts.Series<TempToHour, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TempToHour sales, _) => sales.hour,
        measureFn: (TempToHour sales, _) => sales.temp,
        data: data,
      )
    ];
  }

  static List<charts.Series<TempToHour, int>> convertToLiniarData(
      List<TempToHour> data) {
    return [
      new charts.Series<TempToHour, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TempToHour sales, _) => sales.hour,
        measureFn: (TempToHour sales, _) => sales.temp,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class TempToHour {
  final int hour;
  final int temp;

  TempToHour(this.hour, this.temp);
}

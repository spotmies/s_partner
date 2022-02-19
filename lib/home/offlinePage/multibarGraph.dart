import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

multiBarGraph() {
  return BarChart(BarChartData(
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
          border: Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide(width: 0),
        bottom: BorderSide(width: 0),
      )),
      groupsSpace: 10,
      barGroups: [
        BarChartGroupData(x: 1, barRods: [
          BarChartRodData(y: 4, width: 5, colors: [Colors.white]),
          BarChartRodData(y: 3.2, width: 5, colors: [Colors.greenAccent]),
          BarChartRodData(y: 1, width: 5, colors: [Colors.red[400]!]),
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(y: 12, width: 5, colors: [Colors.white]),
          BarChartRodData(y: 6.2, width: 5, colors: [Colors.greenAccent]),
          BarChartRodData(y: 9, width: 5, colors: [Colors.red[400]!]),
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(y: 13, width: 5, colors: [Colors.white]),
          BarChartRodData(y: 9.1, width: 5, colors: [Colors.greenAccent]),
          BarChartRodData(y: 5.3, width: 5, colors: [Colors.red[400]!]),
        ]),
        BarChartGroupData(x: 4, barRods: [
          BarChartRodData(y: 15, width: 5, colors: [Colors.white]),
          BarChartRodData(y: 11, width: 5, colors: [Colors.greenAccent]),
          BarChartRodData(y: 15, width: 5, colors: [Colors.red[400]!]),
        ]),
        BarChartGroupData(x: 5, barRods: [
          BarChartRodData(y: 8, width: 5, colors: [Colors.white]),
          BarChartRodData(y: 9.2, width: 5, colors: [Colors.greenAccent]),
          BarChartRodData(y: 15, width: 5, colors: [Colors.red[400]!]),
        ]),
      ]));
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

lineGraph() {
  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 1.5),
            FlSpot(3, 4),
            FlSpot(4, 5),
            FlSpot(5, 4)
          ],
          isCurved: true,
          barWidth: 4,
          colors: [
            Colors.white,
          ],
          dotData: FlDotData(
            show: true,
          ),
        ),
      ],
      minY: 0,
    ),
    swapAnimationDuration: Duration(milliseconds: 150), // Optional
    // swapAnimationCurve: Curves.linear, // Optional
  );
}

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List<FlSpot> dummyData1 = List.generate(7, (index) {
  return FlSpot(index.toDouble(), index * Random().nextDouble());
});

final List<FlSpot> dummyData2 = List.generate(7, (index) {
  return FlSpot(index.toDouble(), index * Random().nextDouble());
});

final List<FlSpot> dummyData3 = List.generate(7, (index) {
  return FlSpot(index.toDouble(), index * Random().nextDouble());
});

lineGraphBig(hight, width) {
  return LineChart(
    LineChartData(
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '${value.toInt() + 0}';
            },
            getTextStyles: (BuildContext context ,double) {
              return GoogleFonts.josefinSans(
                color: Colors.grey[900],
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              );
            },
            interval: 1.0,
            margin: 8.0),
        bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (BuildContext context, double) {
              return GoogleFonts.josefinSans(
    color: Colors.grey[900],
    fontSize: width * 0.035,
    fontWeight: FontWeight.w600,
  );
            },
            margin: 20,
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'Day 1';
                case 1:
                  return 'Day 2';
                case 2:
                  return 'Day 3';
                case 3:
                  return 'Day 4';
                case 4:
                  return 'Day 5';
                case 5:
                  return 'Day 6';
                case 6:
                  return 'Day 7';
                default:
                  return '';
              }
            }),
      ),
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      borderData: FlBorderData(show: false),
      // titlesData: FlTitlesData(
      //   show: false,
      // ),
      lineBarsData: [
        LineChartBarData(
          spots: dummyData1,
          isCurved: true,
          barWidth: 3,
          colors: [
            Colors.red,
          ],
          dotData: FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: dummyData2,
          isCurved: true,
          barWidth: 3,
          colors: [
            Colors.greenAccent,
          ],
          dotData: FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: dummyData3,
          isCurved: true,
          barWidth: 3,
          colors: [
            Colors.blue[900]!,
          ],
          dotData: FlDotData(
            show: false,
          ),
        )
      ],
      minY: 0,
    ),
    swapAnimationDuration: Duration(milliseconds: 150), // Optional
    // swapAnimationCurve: Curves.linear, // Optional
  );
}

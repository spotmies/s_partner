import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

singleBarChart(hight, width) {
  return BarChart(BarChartData(
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '${value.toInt()}';
            },
            getTextStyles: (BuildContext context, double) {
              return GoogleFonts.josefinSans(
                color: SpotmiesTheme.secondaryVariant,
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              );
            },
            interval: 3.0,
            margin: 8.0),
        bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (BuildContext context, double) {
              return GoogleFonts.josefinSans(
                color: SpotmiesTheme.secondaryVariant,
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              );
            },
            margin: 20,
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return 'Day 1';
                case 2:
                  return 'Day 2';
                case 3:
                  return 'Day 3';
                case 4:
                  return 'Day 4';
                case 5:
                  return 'Day 5';
                case 6:
                  return 'Day 6';
                case 7:
                  return 'Day 7';
                default:
                  return '';
              }
            }),
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
          BarChartRodData(y: 5, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(y: 9, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(y: 4, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 4, barRods: [
          BarChartRodData(y: 15, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 5, barRods: [
          BarChartRodData(y: 3, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 6, barRods: [
          BarChartRodData(y: 11, width: 15, colors: [Colors.greenAccent]),
        ]),
        BarChartGroupData(x: 7, barRods: [
          BarChartRodData(y: 10, width: 15, colors: [Colors.greenAccent]),
        ]),
      ]));
}

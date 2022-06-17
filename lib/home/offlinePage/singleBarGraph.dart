import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

singleBarChart(hight, width) {
  return BarChart(BarChartData(
      titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return TextWid(
                  text: '${value.toInt()}',
                );
              },
              reservedSize: width * 0.035,
              // (BuildContext context, double) {
              //   return GoogleFonts.josefinSans(
              //     color: SpotmiesTheme.secondaryVariant,
              //     fontSize: width * 0.035,
              //     fontWeight: FontWeight.w600,
              //   );
              // },
              interval: 3.0,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: width * 0.035,
                //  (BuildContext context, double) {
                //   return GoogleFonts.josefinSans(
                //     color: SpotmiesTheme.secondaryVariant,
                //     fontSize: width * 0.035,
                //     fontWeight: FontWeight.w600,
                //   );
                // },
                getTitlesWidget: (value, neta) {
                  switch (value.toInt()) {
                    case 0:
                      return TextWid(
                        text: 'Day 1',
                      );
                    case 1:
                      return TextWid(
                        text: 'Day 2',
                      );
                    case 2:
                      return TextWid(
                        text: 'Day 3',
                      );
                    case 3:
                      return TextWid(
                        text: 'Day 4',
                      );
                    case 4:
                      return TextWid(
                        text: 'Day 5',
                      );
                    case 5:
                      return TextWid(
                        text: 'Day 6',
                      );
                    case 6:
                      return TextWid(
                        text: 'Day 7',
                      );
                    default:
                      return TextWid(
                        text: '',
                      );
                  }
                }),
          )),
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
          BarChartRodData(
              fromY: 5, width: 15, color: Colors.greenAccent, toY: 5),
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(
              fromY: 9, width: 15, color: Colors.greenAccent, toY: 9),
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(
              fromY: 4, width: 15, color: Colors.greenAccent, toY: 4),
        ]),
        BarChartGroupData(x: 4, barRods: [
          BarChartRodData(
              fromY: 15, width: 15, color: Colors.greenAccent, toY: 15),
        ]),
        BarChartGroupData(x: 5, barRods: [
          BarChartRodData(
              fromY: 3, width: 15, color: Colors.greenAccent, toY: 3),
        ]),
        BarChartGroupData(x: 6, barRods: [
          BarChartRodData(
              fromY: 11, width: 15, color: Colors.greenAccent, toY: 11),
        ]),
        BarChartGroupData(x: 7, barRods: [
          BarChartRodData(
              fromY: 10, width: 15, color: Colors.greenAccent, toY: 10),
        ]),
      ]));
}

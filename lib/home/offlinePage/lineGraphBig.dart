import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

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
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return TextWid(
                  text: '${value.toInt() + 0}',
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
              interval: 1.0,
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
          color: Colors.red,
          dotData: FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: dummyData2,
          isCurved: true,
          barWidth: 3,
          color: Colors.greenAccent,
          dotData: FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: dummyData3,
          isCurved: true,
          barWidth: 3,
          color: SpotmiesTheme.tertiaryVariant,
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

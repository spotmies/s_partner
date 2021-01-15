import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(Offline());
}

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PercentIndicator(),
    );
  }
}

class PercentIndicator extends StatefulWidget {
  @override
  _PercentIndicatorState createState() => _PercentIndicatorState();
}

class _PercentIndicatorState extends State<PercentIndicator> {
  var perValue = 0.7;
  var accValue = 0.6;

  var total = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: CircularPercentIndicator(
                radius: 140,
                lineWidth: 13,
                animation: true,
                animationDuration: 1000,
                percent: perValue,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.amber,
                circularStrokeCap: CircularStrokeCap.round,
                footer: Text('Rating'),
                center: Text(
                  '$perValue',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            Container(
              child: CircularPercentIndicator(
                radius: 140,
                lineWidth: 13,
                animation: true,
                animationDuration: 1000,
                percent: accValue,
                backgroundColor: Colors.grey[200],
                progressColor: Colors.amber,
                circularStrokeCap: CircularStrokeCap.round,
                footer: Text('Acceptance Ratio'),
                center: Text(
                  '60%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Number of orders done',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w900,
                  )),
              Icon(Icons.arrow_forward),
              Text('58',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
        ),
        SizedBox(height: 30,),
         Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Number of Referencece',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w900,
                  )),
              Icon(Icons.arrow_forward),
              Text('18',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
        )
      ],
    );
  }
}

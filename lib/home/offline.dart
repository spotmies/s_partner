import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:spotmies_partner/localDB/localGet.dart';

class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    // final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
          future: localPartnerDetailsGet(),
          builder: (context, localPartner) {
            var p = localPartner.data;
            return Center(
                child: Container(
              padding: EdgeInsets.all(10),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: _hight * 0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          progressIndicator(p['rate'], 'Rating'),
                          count(p['orders'], 'Completed orders'),
                          count(p['ref'], 'References'),
                          progressIndicator(p['acceptance'], 'Acceptance'),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ));
          }),
    );
  }

  avg(List<dynamic> args) {
    var sum = 0;
    var avg = args;

    for (var i = 0; i < avg.length; i++) {
      sum += avg[i];
    }

    return sum;
  }

  Widget progressIndicator(indicatorValue, String field) {
    final _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: _width * 0.20,
          width: _width * 0.20,
          // padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                new BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 5.0,
                    spreadRadius: 5.0),
              ]),
          child: CircularPercentIndicator(
            radius: _width * 0.14,
            lineWidth: 2,
            animation: true,
            animationDuration: 1000,
            percent: avg(indicatorValue) / 100,
            backgroundColor: Colors.grey[200],
            progressColor: Colors.amber,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              (field == 'Rating'
                      ? (avg(indicatorValue) / 20)
                      : avg(indicatorValue))
                  .toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: _width * 0.03),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: _width * 0.015),
          child: Text(
            field,
            style: TextStyle(fontSize: _width * 0.02),
          ),
        ),
      ],
    );
  }

  Widget count(value, String field) {
    final _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: _width * 0.20,
          width: _width * 0.20,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 1.0,
                ),
              ]),
          child: Container(
            height: _width * 0.09,
            width: _width * 0.09,
            child: Stack(
              children: [
                Center(
                  child: Text((value.length.toString()),
                      style: TextStyle(
                        fontSize: _width * 0.07,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Positioned(
                  right: _width * 0.05,
                  top: _width * 0.06,
                  child: Icon(
                    field == 'References' ? Icons.link : Icons.done_all,
                    size: _width * 0.03,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: _width * 0.015),
          child: Text(
            field,
            style: TextStyle(fontSize: _width * 0.02),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blue[900]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isSwitched ? 'online' : 'offline',
                  style: TextStyle(fontSize: 25,color: Colors.white,),
                ),
                Switch(
                   activeColor: Colors.white,
                   //activeTrackColor: Colors.grey[500],
                   inactiveThumbColor: Colors.grey,
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    })
              ],
            ),
          ),
          Container(
            height: 597,
            width: double.infinity,
           child: isSwitched?Online():Offline(),
            ),
          
        ],
      )),
    );
  }
}










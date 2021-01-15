import 'package:flutter/material.dart';
import 'package:spotmies_partner/orders/completed.dart';
import 'package:spotmies_partner/orders/ongoing.dart';


class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var list = [
    Center(
      child: OnGoing(),
    ),
    Center(
      child: Completed(),
    ),
  ]; 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
            toolbarHeight: 48,
            backgroundColor: Colors.blue[900],
            elevation: 0,
            //title: Text('Tabs'),
            bottom: TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 3.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 45.0)),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon(Icons.view_module, color: Colors.blue[900]),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Ongoing',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: list),
        ));
  }
}

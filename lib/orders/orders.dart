import 'package:flutter/material.dart';
import 'package:spotmies_partner/orders/completed.dart';
import 'package:spotmies_partner/orders/ongoing.dart';
import 'package:spotmies_partner/orders/posts.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var list = [
    Center(child: PostList(orderState: "onGoing")),
    Center(child: PostList(orderState: "complete")),
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
            toolbarHeight: 55,
            backgroundColor: Colors.white,
            elevation: 4,
            //title: Text('Tabs'),
            bottom: TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.grey[800],
                      width: 3.0,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 0.0)),
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
                        TextWid(
                          text: 'OnGoing',
                          weight: FontWeight.bold,
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
                        TextWid(
                          text: 'Completed',
                          weight: FontWeight.bold,
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

import 'package:flutter/material.dart';
import 'package:spotmies_partner/orders/ongoing.dart';
import 'package:spotmies_partner/orders/posts.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var list = [
    Center(child: PostList(orderState: [0, 1, 2, 3, 4, 5, 6, 7, 8])),
    Center(child: PostList(orderState: [9, 10, 11, 12])),
  ];
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
            toolbarHeight: _hight * 0.02,
            backgroundColor: Colors.white,
            elevation: 1,
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
                          text: 'Continuing',
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

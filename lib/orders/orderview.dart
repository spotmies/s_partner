import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';

class OrderView extends StatefulWidget {
  final String value;
  OrderView({this.value});
  @override
  _OrderViewState createState() => _OrderViewState(value);
}

class _OrderViewState extends State<OrderView> {
  String value;
  _OrderViewState(this.value);
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:
          AppBar(backgroundColor: Colors.blue[900], title: Text('Overview')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('partner')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('orders')
              .doc('$value')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            var document = snapshot.data;
            List<String> images = List.from(document['media']);
            return Container(
              child: ListView(
                children: [
                  Container(
                      height: _hight * 0.07,
                      // color: Colors.amber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Order Id:  '),
                          Text(value),
                        ],
                      )),
                  // Divider(
                  //   thickness: 2,
                  //   color: Colors.grey[100],
                  // ),
                  CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (ctx, index, realIdx) {
                        return Container(
                            height: _hight * 0.2,
                            width: _width * 0.8,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[100],
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    // offset: Offset(3, 3)
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.only(
                                left: _width * 0.05,
                                right: _width * 0.05,
                                top: _width * 0.02,
                                bottom: _width * 0.02),
                            child: Image.network(images[index]
                                .substring(0, images[index].length - 1)));
                      },
                      options: CarouselOptions(
                        height: _hight * 0.3,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      )),
                  // Divider(
                  //   thickness: 2,
                  //   color: Colors.grey[200],
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 5),
                    child: Container(
                      height: _hight * 0.1,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                        right: _width * 0.05,
                        // top: _width * 0.02,
                        // bottom: _width * 0.02
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            toBeginningOfSentenceCase(document['problem']),
                            style: TextStyle(fontSize: _width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Container(
                      height: _hight * 0.1,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                        right: _width * 0.05,
                        // top: _width * 0.02,
                        // bottom: _width * 0.02
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price:',
                            style: TextStyle(fontSize: _width * 0.05),
                          ),
                          Text(
                            'Rs. ' + document['money'] + '/-',
                            style: TextStyle(fontSize: _width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Container(
                      height: _hight * 0.1,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                        right: _width * 0.05,
                        // top: _width * 0.02,
                        // bottom: _width * 0.02
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(fontSize: _width * 0.05),
                          ),
                          Text(
                            document['location.add1'],
                            style: TextStyle(fontSize: _width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Container(
                      height: _hight * 0.1,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                        right: _width * 0.05,
                        // top: _width * 0.02,
                        // bottom: _width * 0.02
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Schedule:',
                            style: TextStyle(fontSize: _width * 0.05),
                          ),
                          Text(
                            document['scheduledate'] +
                                '@' +
                                document['scheduletime'],
                            style: TextStyle(fontSize: _width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (document['orderstate'] == 2)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 5),
                      child: Container(
                          height: _hight * 0.1,
                          width: _width * 0.9,
                          decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.only(
                            left: _width * 0.05,
                            right: _width * 0.05,
                            // top: _width * 0.02,
                            // bottom: _width * 0.02
                          ),
                          child: SliderButton(
                              action: () async {
                                CircularProgressIndicator();
                                await FirebaseFirestore.instance
                                    .collection('partner')
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .collection('orders')
                                    .doc(value)
                                    .update({'orderstate': 3});

                                ///Do something here
                                Navigator.of(context).pop();
                              },
                              label: Text(
                                "Slide to Complete Order",
                                style: TextStyle(
                                    color: Color(0xff4a4a4a),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                              icon: Icon(
                                Icons.done,
                                size: _width * 0.09,
                                color: Colors.green,
                              ))),
                    ),
                ],
              ),
            );
          }),
    );
  }
}

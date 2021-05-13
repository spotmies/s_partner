import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetails extends StatefulWidget {
  final String value;
  UserDetails({this.value});
  @override
  _UserDetailsState createState() => _UserDetailsState(value);
}

class _UserDetailsState extends State<UserDetails> {
  String value;
  _UserDetailsState(this.value);
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Customer Details'),
      //   backgroundColor: Colors.blue[900],
      // ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messaging')
              .doc(value)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            var document = snapshot.data;

            return document['upic'] != null
                ? CustomScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.blue[900],
                        stretch: true,
                        onStretchTrigger: () {
                          // Function callback for stretch
                          return Future<void>.value();
                        },
                        pinned: true,
                        title: Text(document['uname']),
                        snap: false,
                        floating: true,
                        expandedHeight: _hight * 0.5,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: <StretchMode>[
                            StretchMode.zoomBackground,
                            StretchMode.fadeTitle,
                          ],
                          background: Container(
                            width: _width * 1,
                            color: Colors.black,
                            child: Image.network(
                              document['upic'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Divider(
                              thickness: 5,
                              color: Colors.white,
                            ),
                            Container(
                              height: _hight * 0.25,
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: _width * 0.03,
                                          top: _width * 0.03,
                                          bottom: _width * 0.03),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'About and Phone Number',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: _width * 0.05),
                                      )),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(
                                      left: _width * 0.03,
                                      top: _width * 0.03,
                                    ),
                                    child: Text('Chating From',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: _width * 0.05)),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(
                                      left: _width * 0.03,
                                      top: _width * 0.01,
                                    ),
                                    child: Text('18th October, 2020',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: _width * 0.04)),
                                  ),
                                  Divider(
                                    indent: _width * 0.04,
                                    endIndent: _width * 0.04,
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: _width * 0.03,
                                              top: _width * 0.01,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  child: Text(
                                                      '+91 ' + '8330933883',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              _width * 0.05)),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: _width * 0.1,
                                                      top: _width * 0.01),
                                                  width: double.infinity,
                                                  child: Text('Mobile',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              _width * 0.04)),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.message,
                                                      color: Colors.blue[900],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.call,
                                                      color: Colors.blue[900],
                                                    ),
                                                    onPressed: () {
                                                      launch(
                                                          "tel://8330933883");
                                                    }),
                                              ],
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 10,
                              color: Colors.grey[300],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: _width * 0.07,
                              ),
                              height: _hight * 0.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        color: Colors.blue[900],
                                      ),
                                      SizedBox(
                                        width: _width * 0.07,
                                      ),
                                      Text(
                                        'Reveal My Profile',
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: _width * 0.05,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                        trackColor: Colors.grey[300],
                                        value: isSwitch,
                                        activeColor: Colors.blue[900],
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitch = value;
                                          });
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 10,
                              color: Colors.grey[300],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: _width * 0.07,
                              ),
                              height: _hight * 0.1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.contact_page,
                                    color: Colors.blue[900],
                                  ),
                                  SizedBox(
                                    width: _width * 0.07,
                                  ),
                                  Text(
                                    'Available on Message',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: _width * 0.05,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),

                            Divider(
                              thickness: 10,
                              color: Colors.grey[300],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: _width * 0.07,
                              ),
                              height: _hight * 0.1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.block,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: _width * 0.07,
                                  ),
                                  Text(
                                    'Block ' +
                                        toBeginningOfSentenceCase(
                                            document['uname']),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: _width * 0.05,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 10,
                              color: Colors.grey[300],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: _width * 0.07,
                              ),
                              height: _hight * 0.1,
                              // decoration: BoxDecoration(boxShadow: [
                              //   BoxShadow(
                              //       color: Colors.grey[200],
                              //       spreadRadius: 0,
                              //       blurRadius: 5)
                              // ]),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.report_problem,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: _width * 0.07,
                                  ),
                                  Text(
                                    'Report on ' +
                                        toBeginningOfSentenceCase(
                                            document['uname']),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: _width * 0.05,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 10,
                              color: Colors.grey[300],
                            ),
                            Container(height: 150.0),
                            // Container(height: 150.0),
                          ],
                        ),
                      )
                    ],
                  )
                : Center(child: Text('User not revealed deatils'));
          }),
    );
  }
}

// ListView(
//                     children: [
//                       Container(
//                         height: _hight * 0.4,
//                         child: Card(
//                             child: Stack(
//                                 alignment: Alignment.bottomLeft,
//                                 children: [
//                               AspectRatio(

//                                   aspectRatio: 16 / 9,
//                                   child: Image.network(document['upic'])),
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 child: Text(
//                                   document['uname'] == null
//                                       ? 'User'
//                                       : document['uname'],
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: _width * 0.07),
//                                 ),
//                               )
//                             ])),
//                       ),
//                     ],
//                   )

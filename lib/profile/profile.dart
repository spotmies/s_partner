import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/login/login.dart';
import 'package:spotmies_partner/profile/settings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //static final String path = "lib/src/pages/settings/settings3.dart";
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: InkWell(
          onTap: () async {
            await FirebaseAuth.instance.signOut().then((action) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }).catchError((e) {
              print(e);
            });
          }, // handle your onTap here
          child: Container(
            height: _hight * 0.0728,
            width: _width * 1,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                    height: _hight * 0.0728,
                    width: _hight * 0.0728,
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      color: Colors.grey[600],
                    )),
                SizedBox(
                  width: _width * 0.05,
                ),
                Container(
                  padding: EdgeInsets.only(top: 13),
                  height: _hight * 0.0728,
                  width: _width * 0.67,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 70,
                // ),
                Container(
                    height: _hight * 0.0728,
                    width: _hight * 0.0728,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey[600],
                    )),
              ],
            ),
          )),
      // StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('partner')
      //         .doc(FirebaseAuth.instance.currentUser.uid)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData)
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       var document = snapshot.data;
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           //crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             InkWell(
      //               onTap: () {
      //                 Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (context) => Setting()));
      //               },
      //               child: Container(
      //                 height: _hight * 0.3,
      //                 width: _width * 0.8,
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(30),
      //                   // boxShadow: kElevationToShadow[1]
      //                 ),
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     CircleAvatar(
      //                       child: ClipOval(
      //                         child: Center(
      //                           child: document['profilepic'] == null
      //                               ? Icon(
      //                                   Icons.person,
      //                                   color: Colors.blue,
      //                                   size: _width * 0.2,
      //                                 )
      //                               : Image.network(
      //                                   document['profilepic'],
      //                                   fit: BoxFit.cover,
      //                                   width:
      //                                       MediaQuery.of(context).size.width,
      //                                 ),
      //                         ),
      //                       ),
      //                       radius: 50,
      //                       backgroundColor: Colors.grey[100],
      //                     ),
      //                     Column(
      //                       children: [
      //                         Text(
      //                           document['name'] == null
      //                               ? 'New User'
      //                               : document['name'],
      //                           style: TextStyle(fontSize: 25),
      //                         ),
      //                         Text(
      //                           document['email'] == null
      //                               ? 'not found'
      //                               : document['email'],
      //                           style: TextStyle(fontSize: 15),
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Container(
      //                 height: _hight * 0.365,
      //                 width: _width * 1,
      //                 color: Colors.white,
      //                 child: Column(
      //                   children: [
      //                     InkWell(
      //                         onTap: () => Share.share(
      //                             'https://play.google.com/store/apps/details?id=com.spotmiespartner'),
      //                         // print(
      //                         //     "Refer & Share"), // handle your onTap here
      //                         child: Container(
      //                           height: _hight * 0.0728,
      //                           width: _width * 1,
      //                           color: Colors.white,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.share,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                               SizedBox(
      //                                 width: _width * 0.05,
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.only(top: 13),
      //                                 height: _hight * 0.0728,
      //                                 width: _width * 0.67,
      //                                 child: Text(
      //                                   'Refer & Share',
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.grey[600],
      //                                   ),
      //                                 ),
      //                               ),
      //                               // SizedBox(
      //                               //   width: 70,
      //                               // ),
      //                               Container(
      //                                  height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.arrow_forward,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                             ],
      //                           ),
      //                         )),
      //                     InkWell(
      //                         onTap: () => Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     PrivacyPolicyWebView())), // handle your onTap here
      //                         child: Container(
      //                           height: _hight * 0.0728,
      //                           width: _width * 1,
      //                           color: Colors.white,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.security,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                               SizedBox(
      //                                 width: _width * 0.05,
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.only(top: 13),
      //                                 height: _hight * 0.0728,
      //                                 width: _width * 0.67,
      //                                 child: Text(
      //                                   'Privacy Policy',
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.grey[600],
      //                                   ),
      //                                 ),
      //                               ),
      //                               // SizedBox(
      //                               //   width: 70,
      //                               // ),
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.arrow_forward,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                             ],
      //                           ),
      //                         )),
      //                     InkWell(
      //                         onTap: () => Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     HelpAndSupport())), // handle your onTap here
      //                         child: Container(
      //                           height: _hight * 0.0728,
      //                           width: _width * 1,
      //                           color: Colors.white,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.chat,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                               SizedBox(
      //                                 width: _width * 0.05,
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.only(top: 13),
      //                                 height: _hight * 0.0728,
      //                                 width: _width * 0.67,
      //                                 child: Text(
      //                                   'Help & Support',
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.grey[600],
      //                                   ),
      //                                 ),
      //                               ),
      //                               // SizedBox(
      //                               //   width: 70,
      //                               // ),
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.arrow_forward,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                             ],
      //                           ),
      //                         )),
      //                     InkWell(
      //                         onTap: () {
      //                           print("Settings");
      //                           Navigator.of(context).push(MaterialPageRoute(
      //                               builder: (context) => Setting()));
      //                         }, // handle your onTap here
      //                         child: Container(
      //                           height: _hight * 0.0728,
      //                           width: _width * 1,
      //                           color: Colors.white,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.settings,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                               SizedBox(
      //                                 width: _width * 0.05,
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.only(top: 13),
      //                                 height: _hight * 0.0728,
      //                                 width: _width * 0.67,
      //                                 child: Text(
      //                                   'Setting',
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.grey[600],
      //                                   ),
      //                                 ),
      //                               ),
      //                               // SizedBox(
      //                               //   width: 70,
      //                               // ),
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.arrow_forward,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                             ],
      //                           ),
      //                         )),
      //                     InkWell(
      //                         onTap: () async {
      //                           await FirebaseAuth.instance
      //                               .signOut()
      //                               .then((action) {
      //                             Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                     builder: (context) => LoginScreen()));
      //                           }).catchError((e) {
      //                             print(e);
      //                           });
      //                         }, // handle your onTap here
      //                         child: Container(
      //                           height: _hight * 0.0728,
      //                           width: _width * 1,
      //                           color: Colors.white,
      //                           child: Row(
      //                             children: [
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.power_settings_new_rounded,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                               SizedBox(
      //                                 width: _width * 0.05,
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.only(top: 13),
      //                                 height: _hight * 0.0728,
      //                                 width: _width * 0.67,
      //                                 child: Text(
      //                                   'Logout',
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     color: Colors.grey[600],
      //                                   ),
      //                                 ),
      //                               ),
      //                               // SizedBox(
      //                               //   width: 70,
      //                               // ),
      //                               Container(
      //                                   height: _hight * 0.0728,
      //                                   width: _hight * 0.0728,
      //                                   child: Icon(
      //                                     Icons.arrow_forward,
      //                                     color: Colors.grey[600],
      //                                   )),
      //                             ],
      //                           ),
      //                         )),
      //                   ],
      //                 )),
      //           ],
      //         ),
      //       );
      //     }),
    );
  }
}

class HelpAndSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                  height: _hight * 0.3,
                  width: _width * 1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          size: 37,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Make Call',
                          style: TextStyle(fontSize: 35),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3,
                          spreadRadius: 4,
                          offset: Offset(1, 1),
                        ),
                        BoxShadow(
                          color: Colors.grey[50],
                          blurRadius: 3,
                          spreadRadius: 0.1,
                          offset: Offset(-1, -1),
                        )
                      ])),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  height: _hight * 0.3,
                  width: _width * 1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          size: 37,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Send Email',
                          style: TextStyle(fontSize: 35),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3,
                          spreadRadius: 4,
                          offset: Offset(1, 1),
                        ),
                        BoxShadow(
                          color: Colors.grey[50],
                          blurRadius: 3,
                          spreadRadius: 0.1,
                          offset: Offset(-1, -1),
                        )
                      ])),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  height: _hight * 0.3,
                  width: _width * 1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_received,
                          size: 37,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Request To Call',
                          style: TextStyle(fontSize: 35),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 3,
                          spreadRadius: 4,
                          offset: Offset(1, 1),
                        ),
                        BoxShadow(
                          color: Colors.grey[50],
                          blurRadius: 3,
                          spreadRadius: 0.1,
                          offset: Offset(-1, -1),
                        )
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}

//privacy policys
class PrivacyPolicyWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: WebView(
        initialUrl:
            'https://www.privacypolicies.com/live/931def21-ec24-4e98-84c9-1a7be3af4c8a',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/login/login.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 330,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                // boxShadow: kElevationToShadow[1]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://images.indulgexpress.com/uploads/user/imagelibrary/2020/1/25/original/MaheshBabuSourceInternet.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                  Column(
                    children: [
                      Text(
                        'Javvadi Rajasekhar',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        'sekharatece@gmail.com',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                height: 250,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                        onTap: () => Share.share('www.hegnus.com'),
                        // print(
                        //     "Refer & Share"), // handle your onTap here
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.grey[600],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 13),
                                height: 50,
                                width: 200,
                                child: Text(
                                  'Refer & Share',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () =>
                            print("Privacy Policy"), // handle your onTap here
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.security,
                                    color: Colors.grey[600],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 13),
                                height: 50,
                                width: 200,
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () => print("Support"), // handle your onTap here
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.chat,
                                    color: Colors.grey[600],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 13),
                                height: 50,
                                width: 200,
                                child: Text(
                                  'Help & Support',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () =>
                            print("Settings"), // handle your onTap here
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.grey[600],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 13),
                                height: 50,
                                width: 200,
                                child: Text(
                                  'Setting',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () async {
                         await FirebaseAuth.instance.signOut().then((action) {
                           Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
                          }).catchError((e) {
                            print(e);
                          });
                        }, // handle your onTap here
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.power_settings_new_rounded,
                                    color: Colors.grey[600],
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 13),
                                height: 50,
                                width: 200,
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.grey[600],
                                  )),
                            ],
                          ),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

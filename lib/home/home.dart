import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotmies_partner/chat/chat.dart';
import 'package:spotmies_partner/home/homeScreen.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/profile/profile.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: HomeScreen(),
    ),
    Center(
      child: Chat(),
    ),
    Center(
      child: Orders(),
    ),
    Center(
      child: Profile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title:"Google NavBar",
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Google NavBar'),
        // ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 15, color: Colors.black.withOpacity(.1)),
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 5),
                  tabBackgroundColor: Colors.blue[900],
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.chat,
                      text: 'Chat',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.explore,
                      text: 'Orders',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                      iconColor: Colors.grey,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotmies_partner/chat/chat_page.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/utilities/custom_drawer/DraweInitiate.dart';
import 'package:spotmies_partner/utilities/tutorial_category/tutorial_category.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: DrawerInitiate(),
    ),
    Center(
      child: ChatHome(),
    ),
    Center(
      child: Orders(),
    ),
    Center(
     // child: Profile(),
     child: TutCategory(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 0, color: Colors.black.withOpacity(0)),
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  activeColor: Colors.grey[800],
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 2),
                  tabBackgroundColor: Colors.white,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.chat_bubble_rounded,
                      text: 'Chat',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.home_repair_service_rounded,
                      text: 'Orders',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.explore,
                      text: 'Explore',
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

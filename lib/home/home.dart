import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/appbar.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/drawer.dart';
import 'package:spotmies_partner/reusable_widgets/zoom_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ZoomDrawer(
            controller: drawerController,
            borderRadius: 24.0,
            showShadow: true,
            backgroundColor: Colors.white,
            slideWidth: MediaQuery.of(context).size.width  * 0.65,
            openCurve: Curves.easeIn,
            angle: 0.0,
            closeCurve: Curves.easeOut,
            style: DrawerStyle.Style1,
            menuScreen: DrawerScreen(drawerController),
            mainScreen: AppBarScreen(drawerController)));
  }
}

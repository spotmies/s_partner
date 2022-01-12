import 'package:flutter/material.dart';
import 'package:spotmies_partner/utilities/custom_drawer/drawer_user_controller.dart';
import 'package:spotmies_partner/utilities/custom_drawer/home_drawer.dart';

class DrawerInitiate extends StatefulWidget {
  @override
  _DrawerInitiateState createState() => _DrawerInitiateState();
}

class _DrawerInitiateState extends State<DrawerInitiate> {
  DrawerIndex? drawerIndex;
  Widget? screenView;
  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    // screenView = AppBarScreen();
    super.initState();
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          // screenView = TutCategory();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          // screenView = TutCategory();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          // screenView = TutCategory();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          // screenView = TutCategory();
        });
      } else {
        //do in your way......
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawerUserController(
        screenIndex: drawerIndex!,
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: (DrawerIndex drawerIndexdata) {
          changeIndex(drawerIndexdata);
          //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
        },
        screenView: screenView!,
        //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
      ),
      
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/login/login.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/custom_drawer/app_theme.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  bool darkMode = false;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
          index: DrawerIndex.Help,
          labelName: 'Help',
          icon: Icon(Icons.headset_mic_rounded)),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'FeedBack',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invite Friend',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: 'Rate the app',
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: Icon(Icons.info),
      ),
    ];
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut().then((action) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).catchError((e) {
      print(e);
    });
  }

  void setMode(darkModeValue) {
    setState(() {
      darkMode = darkModeValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Container(
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: TextWid(
                      //         text: "Details",
                      //         weight: FontWeight.w600,
                      //         size: _width * 0.05),
                      //   ),
                      // ),
                      Row(
                        children: [
                          Visibility(
                            visible: !darkMode,
                            child: IconButton(
                                onPressed: () {
                                  setMode(true);
                                },
                                icon: Icon(
                                  Icons.light_mode_rounded,
                                  size: _width * 0.09,
                                  color: Colors.grey,
                                )),
                          ),
                          Visibility(
                            visible: darkMode,
                            child: IconButton(
                              onPressed: () {
                                setMode(false);
                              },
                              icon: Icon(
                                Icons.dark_mode_rounded,
                                size: _width * 0.08,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: AnimatedBuilder(
                            animation: widget.iconAnimationController,
                            builder: (BuildContext context, Widget child) {
                              return ScaleTransition(
                                scale: AlwaysStoppedAnimation<double>(1.0 -
                                    (widget.iconAnimationController.value) *
                                        0.2),
                                child: RotationTransition(
                                  turns: AlwaysStoppedAnimation<double>(
                                      Tween<double>(begin: 0.0, end: 24.0)
                                              .animate(CurvedAnimation(
                                                  parent: widget
                                                      .iconAnimationController,
                                                  curve: Curves.fastOutSlowIn))
                                              .value /
                                          360),
                                  child: Container(
                                    height: _width * 0.27,
                                    width: _width * 0.27,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey
                                                  .withOpacity(0.6),
                                              offset: const Offset(2.0, 2.0),
                                              blurRadius: 4),
                                        ],
                                        border: Border.all(
                                            width: 1.0, color: Colors.grey)),
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(60.0)),
                                        child: Image.network(
                                            "https://media-exp1.licdn.com/dms/image/C5103AQFRucSLgIFAlw/profile-displayphoto-shrink_200_200/0/1573798441279?e=1630540800&v=beta&t=G1LqAys5hHVqICreo5l-jNop6uzcbcangKxKAFvwQZ8"),
                                      ),
                                      Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            width: 10,
                                            height: 10,
                                          ))
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextWid(
                                    text: "SekharJavvadi",
                                    weight: FontWeight.w600,
                                    size: _width * 0.05),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWid(
                                        text: "KK solutions",
                                        weight: FontWeight.w300,
                                        size: _width * 0.03),
                                    TextWid(
                                        text: "8341980196",
                                        weight: FontWeight.w300,
                                        size: _width * 0.03),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: TextWid(
                                                text: "Computer & Laptop",
                                                weight: FontWeight.w300,
                                                size: _width * 0.025),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Row(
                                              children: [
                                                TextWid(
                                                    text: "4.5",
                                                    weight: FontWeight.w300,
                                                    size: _width * 0.025),
                                                Icon(Icons.star_rate_rounded,
                                                    color: Colors.amber,
                                                    size: _width * 0.035),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                onTap: signOut,
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}

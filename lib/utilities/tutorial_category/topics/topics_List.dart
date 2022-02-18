import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/utilities/tutorial_category/topics/expansionList.dart';

class TopicsList extends StatefulWidget {
  const TopicsList({Key? key}) : super(key: key);

  @override
  _TopicsListState createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  var list = [
    Center(
      child: Text('1'),
    ),
    Center(
      child: Text('2'),
    ),
  ];
  // bool isExpanded = false;
  // bool canTapOnHeader = false;

  @override
  void initState() {
    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: SpotmiesTheme.background,
      appBar: AppBar(
        title: Text(
          'Introduction to Designing',
          style: GoogleFonts.josefinSans(
            color: SpotmiesTheme.onBackground,
            fontSize: _width * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: SpotmiesTheme.primaryVariant,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: _width * 0.05,
          color: SpotmiesTheme.onBackground,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Succussfully Book Marked',
                              style: GoogleFonts.josefinSans(
                                fontSize: _width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                            )
                          ],
                        ),
                        // content: Icon(Icons.verified),
                      );
                    });
              },
              child: CircleAvatar(
                  radius: _width * 0.035,
                  backgroundColor: SpotmiesTheme.background,
                  child: Icon(
                    Icons.bookmark,
                    size: _width * 0.05,
                    color: SpotmiesTheme.secondaryVariant,
                  )),
            ),
          )
        ],
      ),
      body: ListView(children: [
        Container(
          width: _width * 1,
          color: SpotmiesTheme.primaryVariant,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '40% Complete',
                style: GoogleFonts.josefinSans(
                  fontSize: _width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: _hight * 0.01,
              ),
              Container(
                width: _width * 0.35,
                child: LinearProgressIndicator(
                  value: 0.4,
                  color: SpotmiesTheme.background,
                  backgroundColor: SpotmiesTheme.onBackground,
                ),
              ),
              SizedBox(
                height: _hight * 0.06,
              ),
              Container(
                  height: _hight * 0.25,
                  child: SvgPicture.asset('assets/svgs/introBook.svg')),
            ],
          ),
        ),
        Container(
          height: 15,
          color: SpotmiesTheme.primaryVariant,
          child: Container(
              height: 5,
              decoration: BoxDecoration(
                  color: SpotmiesTheme.primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)))),
        ),
        TabBar(
          labelColor: SpotmiesTheme.secondaryVariant,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: SpotmiesTheme.primaryVariant,
          indicatorPadding: EdgeInsets.only(left: 30, right: 30),
          indicatorWeight: 3.0,
          tabs: [
            Tab(
                icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.slow_motion_video_rounded),
                SizedBox(
                  width: _width * 0.02,
                ),
                Text(
                  'Videos',
                  style: GoogleFonts.josefinSans(
                    fontSize: _width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )),
            Tab(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book),
                  SizedBox(
                    width: _width * 0.02,
                  ),
                  Text(
                    'Documents',
                    style: GoogleFonts.josefinSans(
                      fontSize: _width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
          controller: _controller,
        ),
        Container(
          height: _hight * 0.9,
          width: _width,
          child: TabBarView(
              controller: _controller, children: [BuildPanel(), BuildPanel()]),
        )
      ]),
    );
  }
}

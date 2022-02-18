import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
// import 'package:story_view/story_view.dart';

class ReadTopics extends StatefulWidget {
  final String? value;
  ReadTopics({this.value});
  // const ReadTopics({ Key key }) : super(key: key);

  @override
  _ReadTopicsState createState() => _ReadTopicsState(value!);
}

class _ReadTopicsState extends State<ReadTopics> {
  // final storyController = StoryController();

  // @override
  // void dispose() {
  //   storyController.dispose();
  //   super.dispose();
  // }

  String value;
  _ReadTopicsState(this.value);

  List topics = [
    'TV',
    'Computer',
    'Beuty',
    'driver',
    'interial design',
    'plumber'
  ];
  bool mode = true;
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '$value',
            style: GoogleFonts.josefinSans(
              color: !mode ? SpotmiesTheme.background : Color(0xFF121212),
              fontSize: _width * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor:
              mode ? SpotmiesTheme.primaryVariant : Color(0xFF121212),
          elevation: 9,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: _width * 0.05,
              color: !mode ? SpotmiesTheme.background : Color(0xFF121212),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                  radius: _width * 0.045,
                  backgroundColor: SpotmiesTheme.background,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          mode = !mode;
                        });
                      },
                      icon: Icon(
                        !mode ? Icons.light_mode : Icons.dark_mode,
                        size: _width * 0.05,
                        color: SpotmiesTheme.secondaryVariant,
                      ))),
            )
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: Container(
        //   // width: _width,
        //   child:
        // ),
        backgroundColor: mode ? SpotmiesTheme.background : Color(0xFF121212),
        body: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            color: mode ? SpotmiesTheme.background : Color(0xFF121212),
            child: Column(
              children: [
                Container(
                  height: _hight * 0.8,
                  width: _width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          mode ? SpotmiesTheme.background : Color(0xFF121212),
                      boxShadow: [
                        BoxShadow(
                            color: mode
                                ? SpotmiesTheme.surfaceVariant2
                                : Colors.black87,
                            blurRadius: 5,
                            spreadRadius: 3)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: _hight * 0.03,
                        width: _width,
                        padding: EdgeInsets.only(top: 10),
                        child: ListView.builder(
                            itemCount: topics.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext ctx, int index) {
                              return Container(
                                margin: EdgeInsets.all(4),
                                height: _hight * 0.01,
                                width: (_width * 0.75) / topics.length,
                                color: index == 0
                                    ? SpotmiesTheme.primaryVariant
                                    : SpotmiesTheme.secondaryVariant,
                              );
                            }),
                      ),
                      SizedBox(
                        height: _hight * 0.01,
                      ),
                      Container(
                        height: _hight * 0.32,
                        // color: Colors.white,
                        child: Container(
                            height: _hight * 0.22,
                            width: _width * 0.5,
                            child: SvgPicture.asset('assets/svgs/intro.svg')),
                      ),
                      SizedBox(
                        height: _hight * 0.01,
                      ),
                      Container(
                        child: Text(
                          'Introduction',
                          style: GoogleFonts.josefinSans(
                            color: !mode
                                ? SpotmiesTheme.background
                                : SpotmiesTheme.primary,
                            fontSize: _width * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _hight * 0.01,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Lorem ipsum dolor sit amet. Non sint numquam qui dolor dicta est omnis molestiae et corrupti consequatur id nihil voluptatum sed incidunt pariatur. Qui repudiandae unde rem nulla velit quo temporibus ipsa vel distinctio libero ut enim non veniam voluptate aut assumenda vitae. In ipsa pariatur hic inventore eveniet aut culpa aliquam. At omnis ipsa eos nihil necessitatibus est eveniet repudiandae ut magnam quidem ut necessitatibus nihil.',
                          style: GoogleFonts.josefinSans(
                            color: !mode
                                ? SpotmiesTheme.surfaceVariant2
                                : SpotmiesTheme.secondary,
                            fontSize: _width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: _hight * 0.171,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                          heroTag: 'readBack',
                          backgroundColor: mode
                              ? SpotmiesTheme.background
                              : Color(0xFF121212),
                          onPressed: () {},
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.navigate_before_rounded,
                                color: mode
                                    ? SpotmiesTheme.primary
                                    : SpotmiesTheme.background,
                              ),
                              SizedBox(
                                width: _width * 0.02,
                              ),
                              Text(
                                'Back',
                                style: GoogleFonts.josefinSans(
                                  color: mode
                                      ? SpotmiesTheme.primary
                                      : SpotmiesTheme.background,
                                  fontSize: _width * 0.05,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )),
                      FloatingActionButton.extended(
                          heroTag: 'readNext',
                          backgroundColor: mode
                              ? SpotmiesTheme.background
                              : Color(0xFF121212),
                          onPressed: () {},
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Next',
                                style: GoogleFonts.josefinSans(
                                  color: mode
                                      ? SpotmiesTheme.primary
                                      : SpotmiesTheme.background,
                                  fontSize: _width * 0.05,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.02,
                              ),
                              Icon(Icons.navigate_next_rounded,
                                  color: mode
                                      ? SpotmiesTheme.primary
                                      : SpotmiesTheme.background),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            )));
  }
}

// StoryView(storyItems: [
//             StoryItem.text(
//               title:
//                   "I guess you'd love to see more of our food. That's great.",
//               backgroundColor: Colors.indigo[100],
//             ),
//             StoryItem.text(
//               title: "Nice!\n\nTap to continue.",
//               backgroundColor: Colors.red,
//               textStyle: TextStyle(
//                 fontFamily: 'Dancing',
//                 fontSize: 40,
//               ),
//             ),
//             // StoryItem.pageImage(
//             //   url: "https://pbs.twimg.com/media/Ey0G0DYU8AEr1D5.jpg",
//             //   caption: "Still sampling",
//             //   controller: storyController,
//             // ),
//             // StoryItem.pageImage(
//             //     url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
//             //     caption: "Working with gifs",
//             //     controller: storyController),
//             // StoryItem.pageImage(
//             //   url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             //   caption: "Hello, from the other side",
//             //   controller: storyController,
//             // ),
//             // StoryItem.pageImage(
//             //   url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
//             //   caption: "Hello, from the other side2",
//             //   controller: storyController,
//             // ),
//           ], controller: storyController)),

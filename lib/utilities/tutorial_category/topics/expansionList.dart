import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/utilities/tutorial_category/topics/readTopics.dart';

// class Item {
//   String expandedValue;
//   String headerValue;
//   bool isExpanded;
//   Item({
//     this.expandedValue,
//     this.headerValue,
//     this.isExpanded = false,
//   });
// }

// List<Item> generateItems(int numberOfItems) {
//   return List<Item>.generate(numberOfItems, (int index) {
//     return Item(
//       headerValue: topics[index],
//       expandedValue: 'This tutorial for ' + topics[index],
//     );
//   });
// }

List topics = [
  'Topic 1',
  'Topic 2',
  'Topic 3',
  'Topic 4',
  'Topic 5',
  'Topic 6',
  'Topic 7',
  'Topic 8',
  'Topic 9'
];

// final List<Item> _data = generateItems(3);

class BuildPanel extends StatefulWidget {
  const BuildPanel({Key? key}) : super(key: key);

  @override
  _BuildPanelState createState() => _BuildPanelState();
}

class _BuildPanelState extends State<BuildPanel> {
  @override
  Widget build(BuildContext context) {
    // final _hight = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;

    final _width = MediaQuery.of(context).size.width;
    var topicsLength = topics.length * 60;
    var tileHight = double.parse(topicsLength.toString());

    return ListView.builder(
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          // print(tileHight);
          return Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: ExpansionTile(
                backgroundColor: SpotmiesTheme.primaryVariant,
                collapsedBackgroundColor: Colors.indigo[100],
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_list),
                  ],
                ),
                // expandedAlignment: Alignment.center,
                textColor: SpotmiesTheme.primary,
                iconColor: SpotmiesTheme.primary,
                collapsedIconColor: SpotmiesTheme.primary,
                collapsedTextColor: SpotmiesTheme.primary,
                title: Text(
                  'Course ' + '$index',
                  style: GoogleFonts.josefinSans(
                    // color: Colors.white,
                    fontSize: _width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Duration: 16.45 min',
                  style: GoogleFonts.josefinSans(
                    // color: Colors.white,
                    fontSize: _width * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: tileHight,
                      child: ListView.builder(
                          itemCount: topics.length,
                          itemBuilder: (BuildContext ctx, int lineup) {
                            return Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              color: SpotmiesTheme.background,
                              child: ListTile(
                                hoverColor: SpotmiesTheme.primary,
                                onTap: () {
                                  print(topics[lineup]);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ReadTopics(value: topics[lineup]),
                                  ));
                                },
                                leading: Icon(
                                  Icons.video_library,
                                  size: _width * 0.05,
                                  color: SpotmiesTheme.primary,
                                ),
                                trailing: Icon(
                                  Icons.open_in_full,
                                  size: _width * 0.05,
                                  color: SpotmiesTheme.primary,
                                ),
                                title: Text(
                                  topics[lineup],
                                  style: GoogleFonts.josefinSans(
                                    fontSize: _width * 0.04,
                                    color: SpotmiesTheme.secondaryVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        });

    // SingleChildScrollView(
    //   child: Container(
    //     child: ExpansionPanelList(
    //       expansionCallback: (int index, bool isExpanded) {
    //         setState(() {
    //           _data[index].isExpanded = !isExpanded;
    //         });
    //       },
    //       children: _data.map<ExpansionPanel>((Item item) {
    //         return ExpansionPanel(
    //           headerBuilder: (BuildContext context, bool isExpanded) {
    //             return Container(
    //               color: Colors.amber,
    //               child: ListTile(
    //                 title: Text(item.headerValue),
    //               ),
    //             );
    //           },
    //           body: Container(
    //             // color: Colors.amber,
    //             // height: 200,
    //             child: ListTile(
    //               title: Text(item.expandedValue),
    //               subtitle: const Text(
    //                   'To delete this panel, tap the trash can icon'),
    //               // trailing: const Icon(Icons.delete),
    //               // onTap: () {
    //               //   setState(() {
    //               //     _data.removeWhere(
    //               //         (Item currentItem) => item == currentItem);
    //               //   });
    //               // }
    //             ),
    //           ),
    //           isExpanded: item.isExpanded,
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );
  }
}

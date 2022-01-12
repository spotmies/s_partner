
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';


class TutCategory extends StatefulWidget {
  @override
  _TutCategoryState createState() => _TutCategoryState();
}

class _TutCategoryState extends State<TutCategory> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: TextWid(
            text: "Learning",
            color: Colors.grey[900],
            size: _width * 0.05,
            weight: FontWeight.w600,
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              height: height(context) * 0.3,
              width: width(context),
              child: SvgPicture.asset('assets/svgs/introBook.svg')),
          SizedBox(
            height: height(context) * 0.06,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width(context) * 0.04, right: width(context) * 0.03),
            child: TextWid(
              text: 'Coming soon',
              flow: TextOverflow.visible,
              size: width(context) * 0.07,
              align: TextAlign.center,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: height(context) * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width(context) * 0.04, right: width(context) * 0.03),
            child: TextWid(
              text:
                  'To make our spotmies partners the best technicians in the world, we are providing professional courses for all of you and we are working to give you the best experience, it might come in next update. Till then please stay tuned. ',
              flow: TextOverflow.visible,
              size: width(context) * 0.05,
              align: TextAlign.center,
            ),
          ),
          // SizedBox(
          //   height: height(context) * 0.12,
          // ),
        ])
        // body: BodyWidget(),
        );
  }
}

// class BodyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     // double _height = MediaQuery.of(context).size.height;

//     List<Map<String, Object>>? catelog = [
//       {
//         "title": "Development",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.code_rounded,
//         "primaryColor": Colors.red[400]!,
//         "secondaryColor": Colors.red[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Designing",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.design_services_rounded,
//         "primaryColor": Colors.indigo[400]!,
//         "secondaryColor": Colors.indigo[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Tutor",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.person_search_rounded,
//         "primaryColor": Colors.green[400]!,
//         "secondaryColor": Colors.green[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Events",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.celebration,
//         "primaryColor": Colors.amber[700]!,
//         "secondaryColor": Colors.amber[600]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Interior Designer",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.house_siding_rounded,
//         "primaryColor": Colors.blue[400]!,
//         "secondaryColor": Colors.blue[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Photographer",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.videocam_rounded,
//         "primaryColor": Colors.deepOrange[400]!,
//         "secondaryColor": Colors.deepOrange[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Beauty",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.face_retouching_natural,
//         "primaryColor": Colors.pink[400]!,
//         "secondaryColor": Colors.pink[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Driver",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.time_to_leave_rounded,
//         "primaryColor": Colors.teal,
//         "secondaryColor": Colors.teal[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "CC Tv",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.video_call_rounded,
//         "primaryColor": Colors.purple[400]!,
//         "secondaryColor": Colors.purple[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Plumber",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.build,
//         "primaryColor": Colors.indigo[400]!,
//         "secondaryColor": Colors.indigo[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Carpenter",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.carpenter_rounded,
//         "primaryColor": Colors.green[400]!,
//         "secondaryColor": Colors.green[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Computer & Laptop repair",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.laptop_chromebook_rounded,
//         "primaryColor": Colors.deepOrange[400]!,
//         "secondaryColor": Colors.deepOrange[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Tv Repair",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.tv,
//         "primaryColor": Colors.teal[400]!,
//         "secondaryColor": Colors.teal[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Electrician",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.handyman_outlined,
//         "primaryColor": Colors.blue[400]!,
//         "secondaryColor": Colors.blue[300]!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//       {
//         "title": "Catering",
//         "videos": "20",
//         "docs": "15",
//         "icon": Icons.restaurant,
//         "primaryColor": Colors.orange[400]!,
//         "secondaryColor": (Colors.orange[300])!,
//         "helperText": "Popular",
//         "id": "id to navigate"
//       },
//     ];

//     return Center(
//       child: GridView.count(
//         crossAxisCount: 2,
//         children: List.generate(catelog.length, (index) {
//           return Center(
//               child: CatCard(
//             onClick: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TopicsList()),
//               );
//             },
//             width: _width,
//             cardPrimaryCol: catelog[index]['primaryColor'],
//             cardSecondayCol: catelog[index]['secondaryColor'],
//             cardIcon: catelog[index]['icon'],
//             title: catelog[index]['title'],
//             videos: catelog[index]['videos'],
//             helperText: catelog[index]['helperText'],
//             docs: catelog[index]['docs'],
//             id: catelog[index]['id'],
//           ));
//         }),
//       ),
//     );
//   }
// }

// class CatCard extends StatelessWidget {
//   const CatCard(
//       {Key? key,
//       required double width,
//       required this.cardPrimaryCol,
//       required this.cardSecondayCol,
//       required this.cardIcon,
//       required this.title,
//       required this.videos,
//       required this.docs,
//       required this.helperText,
//       required this.onClick,
//       required this.id})
//       : _width = width,
//         super(key: key);

//   final double _width;
//   final Color cardPrimaryCol ;
//   final Color cardSecondayCol;
//   final IconData cardIcon;
//   final String title;
//   final String videos;
//   final String docs;
//   final String helperText;
//   final String id;
//   final VoidCallback onClick;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onClick,
//       child: Container(
//         width: _width * 0.45,
//         height: _width * 0.45,
//         child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(30),
//                   topLeft: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//                 color: cardPrimaryCol,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey,
//                     blurRadius: 10.0,
//                   ),
//                 ]),
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   flex: 4,
//                   child: Container(
//                       width: _width * 0.45,
//                       decoration: BoxDecoration(
//                         // color: cardPrimaryCol,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(30),
//                           topLeft: Radius.circular(20),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Container(
//                                 child: Align(
//                                     alignment: Alignment(-0.4, -0.3),
//                                     child: TextWid(
//                                       text: helperText,
//                                       size: _width * 0.035,
//                                       color: Colors.white,
//                                     ))),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 color: cardSecondayCol,
//                                 borderRadius: BorderRadius.circular(30),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: cardSecondayCol,
//                                     blurRadius: 3.0,
//                                   ),
//                                 ]),
//                             width: _width * 0.15,
//                             height: _width * 0.15,
//                             child: Icon(
//                               cardIcon,
//                               color: Colors.white,
//                             ),
//                           )
//                         ],
//                       )),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     width: _width * 0.45,
//                     child: Container(
//                         padding: EdgeInsets.only(left: _width * 0.04),
//                         child: TextWid(
//                           text: title,
//                           weight: FontWeight.bold,
//                           color: Colors.white,
//                           lSpace: 0.5,
//                           size: _width * 0.048,
//                         )),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20),
//                         ),
//                       ),
//                       width: _width * 0.45,
//                       child: Container(
//                           // padding: EdgeInsets.only(right: 15),
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Container(
//                             // color: Colors.amber,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextWid(
//                                       text: "$docs+",
//                                       color: Colors.white70,
//                                       size: _width * 0.050,
//                                       weight: FontWeight.bold,
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Icon(
//                                       Icons.text_snippet_outlined,
//                                       size: _width * 0.043,
//                                       color: Colors.white,
//                                     ),
//                                     TextWid(
//                                       text: " Docs",
//                                       color: Colors.white70,
//                                       size: _width * 0.030,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             // color: Colors.pink,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextWid(
//                                       text: "$videos+",
//                                       color: Colors.white70,
//                                       size: _width * 0.050,
//                                       weight: FontWeight.bold,
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Icon(
//                                       Icons.slow_motion_video_rounded,
//                                       size: _width * 0.043,
//                                       color: Colors.white,
//                                     ),
//                                     TextWid(
//                                       text: " Videos",
//                                       color: Colors.white70,
//                                       size: _width * 0.030,
//                                     ),
//                                   ],
//                                 ),

//                                 // Row(
//                                 //   mainAxisAlignment: MainAxisAlignment.end,
//                                 //   children: [
//                                 //     Icon(
//                                 //       Icons.text_snippet_outlined,
//                                 //       size: _width * 0.037,
//                                 //       color: Colors.white,
//                                 //     ),
//                                 //     TextWid(
//                                 //       text: " Docs $docs",
//                                 //       color: Colors.white70,
//                                 //       size: _width * 0.030,
//                                 //     ),
//                                 //   ],
//                                 // )
//                               ],
//                             ),
//                           )
//                         ],
//                       )
//                           // Column(

//                           //   crossAxisAlignment: CrossAxisAlignment.end,
//                           //   children: [
//                           //     Row(
//                           //       mainAxisAlignment: MainAxisAlignment.end,
//                           //       children: [
//                           //         TextWid(
//                           //           text: "$videos",
//                           //           color: Colors.white70,
//                           //           size: _width * 0.050,
//                           //         ),
//                           //       ],
//                           //     ),
//                           //     Row(
//                           //       mainAxisAlignment: MainAxisAlignment.end,
//                           //       children: [
//                           //         Icon(
//                           //           Icons.slow_motion_video_rounded,
//                           //           size: _width * 0.043,
//                           //           color: Colors.white,
//                           //         ),
//                           //         TextWid(
//                           //           text: " Videos",
//                           //           color: Colors.white70,
//                           //           size: _width * 0.030,
//                           //         ),
//                           //       ],
//                           //     ),

//                           //     // Row(
//                           //     //   mainAxisAlignment: MainAxisAlignment.end,
//                           //     //   children: [
//                           //     //     Icon(
//                           //     //       Icons.text_snippet_outlined,
//                           //     //       size: _width * 0.037,
//                           //     //       color: Colors.white,
//                           //     //     ),
//                           //     //     TextWid(
//                           //     //       text: " Docs $docs",
//                           //     //       color: Colors.white70,
//                           //     //       size: _width * 0.030,
//                           //     //     ),
//                           //     //   ],
//                           //     // )
//                           //   ],
//                           // ),
//                           )),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }

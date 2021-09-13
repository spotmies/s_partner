import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

bottomOptionsMenu(context, {menuTitle = "Menu", options}) {
  final _width = MediaQuery.of(context).size.width;
  final _height = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    context: context,
    elevation: 22,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        color: Colors.white,
        height: _height * 0.18,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWid(
                  text: menuTitle,
                  color: Colors.grey[800],
                  size: _width * 0.04,
                  weight: FontWeight.w300),
              Divider(
                thickness: _width * 0.005,
                indent: _width * 0.15,
                endIndent: _width * 0.15,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 4,
                    // physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          options[index]['onPress']();
                        },
                        child: Container(
                          // padding: EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            radius: _width * 0.099,
                            backgroundColor: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  options[index]['icon'],
                                  color: Colors.grey[700],
                                ),
                                SizedBox(
                                  height: _height * 0.01,
                                ),
                                TextWid(
                                  text: options[index]['name'],
                                  color: Colors.grey[800],
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    },
  );
}



//options list must be this form

//   List options = [
//   {
//     "name": "view",
//     "icon": Icons.get_app,
//     "onPress": () {
//       print("view");
//     }
//   },
//   {
//     "name": "view2",
//     "icon": Icons.more,
//     "onPress": () {
//       print("view2");
//     }
//   },
//   {
//     "name": "view3",
//     "icon": Icons.phone,
//     "onPress": () {
//       print("view3");
//     }
//   },
//   {
//     "name": "view4",
//     "icon": Icons.computer,
//     "onPress": () {
//       print("view4");
//     }
//   },
// ];

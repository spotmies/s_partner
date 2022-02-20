import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

catelogCard(BuildContext context, cat) {
  return Column(
    children: [
      Container(
        height: height(context) * 0.18,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4, spreadRadius: 2, color: SpotmiesTheme.shadow)
            ],
            color: SpotmiesTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(
            //   height: height(context) * 0.01,
            // ),
            Container(
              // width: width(context) * 0.9,
              // decoration: BoxDecoration(color: SpotmiesTheme.onSurface),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWid(
                    text: 'Recent catelogs',
                    size: width(context) * 0.045,
                    weight: FontWeight.w600,
                    align: TextAlign.left,
                    flow: TextOverflow.ellipsis,
                  ),
                  ElevatedButtonWidget(
                    buttonName: 'View all',
                    height: height(context) * 0.04,
                    minWidth: width(context) * 0.25,
                    bgColor: Colors.transparent,
                    textColor: SpotmiesTheme.secondaryVariant,
                    textSize: width(context) * 0.035,
                    borderRadius: 15.0,
                    // leadingIcon: Icon(
                    //   Icons.visibility,
                    //   size: width(context) * 0.045,
                    //   color: SpotmiesTheme.secondaryVariant,
                    // ),
                    borderSideColor: Colors.transparent,
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Catalog(showCard: true)));
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: TextWid(
                text: toBeginningOfSentenceCase(cat.last['name']).toString(),
                size: width(context) * 0.05,
                weight: FontWeight.w600,
                color: SpotmiesTheme.primary,
                flow: TextOverflow.ellipsis,
              ),
              subtitle: TextWid(
                text: cat.last['description'],
                size: width(context) * 0.04,
                weight: FontWeight.w400,
                // align: TextAlign.left,
              ),
              trailing: ProfilePic(
                  size: width(context) * 0.055,
                  textSize: width(context) * 0.04,
                  profile: cat.last['media'][0]['url'].toString(),
                  name: cat.last['name'].toString()),
            ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       width: width(context) * 0.85,
            //       padding: EdgeInsets.only(bottom: 10, top: 10),
            //       // child: Column(
            //       //   // mainAxisAlignment: MainAxisAlignment.start,
            //       //   crossAxisAlignment: CrossAxisAlignment.start,
            //       //   children: [
            //       //     TextWid(
            //       //       text: toBeginningOfSentenceCase(cat.last['name'])
            //       //           .toString(),
            //       //       size: width(context) * 0.06,
            //       //       weight: FontWeight.w500,
            //       //       // align: TextAlign.left,
            //       //       flow: TextOverflow.ellipsis,
            //       //     ),
            //       //     TextWid(
            //       //       text: cat.last['description'],
            //       //       size: width(context) * 0.04,
            //       //       weight: FontWeight.w400,
            //       //       // align: TextAlign.left,
            //       //     )
            //       //   ],
            //       // ),
            //     ),
            //     // Container(
            //     //   height: height(context) * 0.055,
            //     //   width: width(context) * 0.005,
            //     //   color: Colors.grey[500],
            //     // ),
            //     // Container(
            //     //   width: width(context) * 0.23,
            //     //   padding: EdgeInsets.only(bottom: 10, top: 10),
            //     //   child: Column(
            //     //     children: [
            //     //       TextWid(
            //     //         text: '${cat.length}',
            //     //         size: width(context) * 0.06,
            //     //         weight: FontWeight.w600,
            //     //         align: TextAlign.center,
            //     //       ),
            //     //       TextWid(
            //     //         text: 'Catelogs',
            //     //         size: width(context) * 0.04,
            //     //         weight: FontWeight.w400,
            //     //         align: TextAlign.center,
            //     //       )
            //     //     ],
            //     //   ),
            //     // ),
            //   ],
            // ),
            // ElevatedButtonWidget(
            //   buttonName: 'View all',
            //   height: height(context) * 0.055,
            //   minWidth: width(context) * 0.9,
            //   bgColor: Colors.transparent,
            //   textColor: SpotmiesTheme.secondaryVariant,
            //   textSize: width(context) * 0.04,
            //   borderRadius: 15.0,
            //   borderSideColor: Colors.transparent,
            //   onClick: () {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => Catalog()));
            //   },
            // ),
          ],
        ),
      ),
    ],
  );
}

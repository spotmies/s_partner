import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/catelog_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catelog_post.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  _CatalogState createState() => _CatalogState();
}

PartnerDetailsProvider? partnerDetailsProvider;
CatelogController catelogController = CatelogController();

class _CatalogState extends State<Catalog> {
  @override
  void initState() {
    super.initState();
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextWid(
            text: 'Catelog',
            size: width(context) * 0.05,
            weight: FontWeight.w600,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey[900],
              )),
        ),
        floatingActionButton: ElevatedButtonWidget(
          buttonName: 'Add Service',
          height: height(context) * 0.055,
          minWidth: width(context) * 0.4,
          bgColor: Colors.indigo[900]!,
          textColor: Colors.grey[50]!,
          textSize: width(context) * 0.04,
          allRadius: true,
          leadingIcon: Icon(
            Icons.add_circle,
            color: Colors.grey[50],
            size: width(context) * 0.05,
          ),
          borderRadius: 15.0,
          borderSideColor: Colors.grey[900]!,
          onClick: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CatelogPost()));
          },
        ),
        body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
          var pD = data.getPartnerDetailsFull;
          var cat = pD['catelogs'];
          log(cat.toString());
          if (cat == null) {
            return addCatelog(context);
          }
          return ListView.builder(
              itemCount: cat.length,
              itemBuilder: (context, index) {
                return catelogListCard(context, cat[index], index);
              });
        }));
  }
}

catelogListCard(BuildContext context, cat, int index) {
  return ListTile(
    minVerticalPadding: height(context) * 0.02,
    tileColor: Colors.white,
    title: TextWid(text: cat['name'].toString()),
    subtitle: TextWid(text: cat['description'].toString()),
    leading: ProfilePic(
        profile: cat['media'][0]['url'].toString(),
        name: cat['name'].toString()),
    trailing: FittedBox(
      fit: BoxFit.fill,
      child: Column(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              bottomMenu(context, cat, index);
            },
            icon: Icon(Icons.more_horiz),
          ),
          Switch(
              activeTrackColor: Colors.indigo[100],
              activeColor: Colors.indigo[900],
              value: cat['isActive'],
              onChanged: (val) {
                Map<String, String> body = {
                  "isActive": val.toString(),
                };
                catelogController.updateCatListState(body, cat['_id']);
                partnerDetailsProvider!.setCategoryItemState(val, index);
              }),
        ],
      ),
    ),
  );
}

Future bottomMenu(BuildContext context, cat, int index) {
  return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: height(context) * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButtonWidget(
                    bgColor: Colors.indigo[900]!,
                    minWidth: width(context) * 0.45,
                    height: height(context) * 0.06,
                    textColor: Colors.white,
                    buttonName: 'Edit',
                    textSize: width(context) * 0.05,
                    textStyle: FontWeight.w600,
                    allRadius: true,
                    borderRadius: 15.0,
                    borderSideColor: Colors.indigo[900]!,
                    // trailingIcon: Icon(Icons.share),
                    onClick: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CatelogPost(index: index, cat: cat)));
                    }),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButtonWidget(
                  bgColor: Colors.indigo[50]!,
                  minWidth: width(context) * 0.45,
                  height: height(context) * 0.06,
                  textColor: Colors.grey[900]!,
                  buttonName: 'Delete',
                  textSize: width(context) * 0.05,
                  textStyle: FontWeight.w600,
                  allRadius: true,
                  borderRadius: 15.0,
                  borderSideColor: Colors.indigo[50]!,
                  onClick: () async {
                    var res = await catelogController.deleteCatelog(cat['_id']);
                    if (res == 200 || res == 204) {
                      partnerDetailsProvider!.removeCategoryItem(cat['_id']);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      });
}

addCatelog(BuildContext context) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
        height: height(context) * 0.3,
        width: width(context),
        child: SvgPicture.asset('assets/svgs/catelog.svg')),
    SizedBox(
      height: height(context) * 0.06,
    ),
    Padding(
      padding: EdgeInsets.only(left: width(context) * 0.04),
      child: TextWid(
        text:
            'the day i saw you in the college,i felt like taking a thousands of hugs and lacks kisses from you ,love you my dear ',
        flow: TextOverflow.visible,
        size: width(context) * 0.05,
      ),
    ),
    SizedBox(
      height: height(context) * 0.12,
    ),
    ElevatedButtonWidget(
      buttonName: 'Add Service',
      height: height(context) * 0.055,
      minWidth: width(context) * 0.5,
      bgColor: Colors.indigo[900]!,
      textColor: Colors.grey[50]!,
      textSize: width(context) * 0.04,
      allRadius: true,
      leadingIcon: Icon(
        Icons.add_circle,
        color: Colors.grey[50],
        size: width(context) * 0.05,
      ),
      borderRadius: 15.0,
      borderSideColor: Colors.grey[900]!,
      onClick: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CatelogPost()));
      },
    ),
  ]);
}

catelogCard(BuildContext context, cat) {
  return Column(
    children: [
      Container(
        height: height(context) * 0.22,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(blurRadius: 4, spreadRadius: 2, color: Colors.grey[300]!)
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height(context) * 0.01,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: TextWid(
                text: 'Recent catelog',
                size: width(context) * 0.06,
                weight: FontWeight.w600,
                // align: TextAlign.left,
                flow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: width(context) * 0.85,
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    children: [
                      TextWid(
                        text: cat.last['name'],
                        size: width(context) * 0.06,
                        weight: FontWeight.w500,
                        align: TextAlign.center,
                        flow: TextOverflow.ellipsis,
                      ),
                      TextWid(
                        text: cat.last['description'],
                        size: width(context) * 0.04,
                        weight: FontWeight.w400,
                        align: TextAlign.center,
                      )
                    ],
                  ),
                ),
                // Container(
                //   height: height(context) * 0.055,
                //   width: width(context) * 0.005,
                //   color: Colors.grey[500],
                // ),
                // Container(
                //   width: width(context) * 0.23,
                //   padding: EdgeInsets.only(bottom: 10, top: 10),
                //   child: Column(
                //     children: [
                //       TextWid(
                //         text: '${cat.length}',
                //         size: width(context) * 0.06,
                //         weight: FontWeight.w600,
                //         align: TextAlign.center,
                //       ),
                //       TextWid(
                //         text: 'Catelogs',
                //         size: width(context) * 0.04,
                //         weight: FontWeight.w400,
                //         align: TextAlign.center,
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
            ElevatedButtonWidget(
              buttonName: 'View all',
              height: height(context) * 0.055,
              minWidth: width(context) * 0.9,
              bgColor: Colors.transparent,
              textColor: Colors.grey[900]!,
              textSize: width(context) * 0.04,
              borderRadius: 15.0,
              borderSideColor: Colors.transparent,
              onClick: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Catalog()));
              },
            ),
          ],
        ),
      ),
    ],
  );
}

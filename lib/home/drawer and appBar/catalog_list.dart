import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/catelog_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catelog_post.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/progress_waiter.dart';
import 'package:spotmies_partner/reusable_widgets/store_creating_card.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
// import 'dart:ui' as ui;
import '../../apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';

class Catalog extends StatefulWidget {
  final bool? showCard;
  const Catalog({Key? key, this.showCard}) : super(key: key);

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

  catelogList(BuildContext context, cat, int index) {
    return Container(
        child: index != 0
            ? catelogListCard(context, cat, index)
            : Column(
                children: [
                  widget.showCard! == false
                      ? Container(
                          height: height(context) * 0.21,
                          margin: EdgeInsets.only(bottom: 5),
                          child: SharingCard(
                            provider: partnerDetailsProvider,
                          ),
                        )
                      : SizedBox(),
                  catelogListCard(context, cat, index)
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SpotmiesTheme.background,
        appBar: AppBar(
          backgroundColor: SpotmiesTheme.background,
          elevation: 0,
          title: TextWid(
            text: 'Services Store',
            size: width(context) * 0.045,
            weight: FontWeight.w600,
          ),
          leading: IconButton(
              onPressed: () {
                if (widget.showCard! == true) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                widget.showCard! == true
                    ? Icons.arrow_back
                    : Icons.store_rounded,
                size: widget.showCard! == true
                    ? width(context) * 0.06
                    : width(context) * 0.05,
                color: SpotmiesTheme.secondaryVariant,
              )),
        ),
        floatingActionButton: ElevatedButtonWidget(
          buttonName: 'Add Service',
          height: height(context) * 0.055,
          minWidth: width(context) * 0.45,
          bgColor: SpotmiesTheme.primary,
          textColor: SpotmiesTheme.background,
          textSize: width(context) * 0.04,
          allRadius: true,
          leadingIcon: Icon(
            Icons.add_circle,
            color: SpotmiesTheme.surfaceVariant,
            size: width(context) * 0.05,
          ),
          borderRadius: 15.0,
          borderSideColor: SpotmiesTheme.background,
          onClick: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CatelogPost()));
          },
        ),
        body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
          Map<dynamic, dynamic> pD = data.getPartnerDetailsFull;
          dynamic cat = pD['catelogs'];
          log(cat.toString());
          if (cat == null) {
            return addCatelog(context);
          }

          if (cat.length < 1) {
            return Column(
              children: [
                Container(
                  height: height(context) * 0.21,
                  margin: EdgeInsets.only(bottom: 5),
                  child: SharingCard(
                    provider: partnerDetailsProvider,
                    onClick: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CatelogPost()));
                    },
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  dynamic details = await partnerDetailsFull(
                      partnerDetailsProvider!.currentPid.toString());
                  partnerDetailsProvider!.setPartnerDetails(details);
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cat.length,
                    itemBuilder: (context, index) {
                      return catelogList(context, cat[index], index);
                    }),
              ),
              ProgressWaiter(
                  contextt: context, loaderState: data.catelogListLoader)
            ],
          );
        }));
  }
}

catelogListCard(BuildContext context, cat, int index) {
  return ListTile(
    minVerticalPadding: height(context) * 0.02,
    tileColor: cat["isVerified"]
        ? SpotmiesTheme.background
        : Colors.amber.withOpacity(0.15),
    onTap: () {
      bottomMenu(context, cat, index);
    },
    title: TextWid(
      text: toBeginningOfSentenceCase(cat['name']).toString(),
      size: width(context) * 0.05,
      weight: FontWeight.w600,
    ),
    subtitle: !cat["isVerified"]
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWid(
                  text:
                      toBeginningOfSentenceCase(cat['description'].toString())),
              Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: Colors.red.withOpacity(0.5),
                    size: width(context) * 0.03,
                  ),
                  SizedBox(
                    width: width(context) * 0.02,
                  ),
                  TextWid(
                    text: 'catelog under verification'.toString(),
                    color: Colors.red.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          )
        : TextWid(
            text: toBeginningOfSentenceCase(cat['description'].toString())),
    isThreeLine: cat["isVerified"] ? false : true,
    //  filter: ui.ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
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
              if (cat["isVerified"]) {
                bottomMenu(context, cat, index);
              } else {
                snackbar(context, "Catelog under verification");
              }
            },
            icon: Icon(
              Icons.more_horiz,
              color: SpotmiesTheme.onBackground,
            ),
          ),
          Switch(
              activeTrackColor: SpotmiesTheme.primaryVariant,
              activeColor: SpotmiesTheme.primary,
              value: cat['isActive'],
              onChanged: (val) {
                Map<String, String> body = {
                  "isActive": val.toString(),
                };
                if (cat["isVerified"]) {
                  catelogController.updateCatListState(body, cat['_id']);
                  partnerDetailsProvider!.setCategoryItemState(val, index);
                } else {
                  snackbar(context, "Catelog under verification");
                }
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
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
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
                    bgColor: SpotmiesTheme.primary,
                    minWidth: width(context) * 0.45,
                    height: height(context) * 0.06,
                    textColor: SpotmiesTheme.background,
                    buttonName: 'Edit',
                    textSize: width(context) * 0.05,
                    textStyle: FontWeight.w600,
                    allRadius: true,
                    borderRadius: 15.0,
                    borderSideColor: SpotmiesTheme.primary,
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
                  bgColor: SpotmiesTheme.primaryVariant,
                  minWidth: width(context) * 0.45,
                  height: height(context) * 0.06,
                  textColor: SpotmiesTheme.secondaryVariant,
                  buttonName: 'Delete',
                  textSize: width(context) * 0.05,
                  textStyle: FontWeight.w600,
                  allRadius: true,
                  borderRadius: 15.0,
                  borderSideColor: SpotmiesTheme.primaryVariant,
                  onClick: () async {
                    partnerDetailsProvider?.setCatelogListLoader(true);
                    var res = await catelogController.deleteCatelog(cat['_id']);
                    partnerDetailsProvider?.setCatelogListLoader(false);
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
      bgColor: SpotmiesTheme.primary,
      textColor: SpotmiesTheme.surfaceVariant,
      textSize: width(context) * 0.04,
      allRadius: true,
      leadingIcon: Icon(
        Icons.add_circle,
        color: SpotmiesTheme.surfaceVariant,
        size: width(context) * 0.05,
      ),
      borderRadius: 15.0,
      borderSideColor: SpotmiesTheme.secondaryVariant,
      onClick: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CatelogPost()));
      },
    ),
  ]);
}



//  if (index == 1)
//         Positioned(
//             top: height(context) * 0.005,
//             child: BackdropFilter(
//               filter: ui.ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
//               child: Container(
//                 height: height(context) * 0.09,
//                 width: width(context),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.amber.withOpacity(0.3),
//                 ),
//                 child: TextWid(
//                   text: "Catelog under verification",
//                   color: SpotmiesTheme.onBackground,
//                   weight: FontWeight.w800,
//                   size: width(context) * 0.045,
//                 ),
//               ),
//             ))
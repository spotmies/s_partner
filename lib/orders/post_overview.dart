import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/post_overview_controller.dart';
import 'package:spotmies_partner/internet_calling/calling.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/bottom_options_menu.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/progress_waiter.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/profile_shimmer.dart';
import 'package:timelines/timelines.dart';

class PostOverView extends StatefulWidget {
  final int index;
  PostOverView({this.index});
  @override
  _PostOverViewState createState() => _PostOverViewState();
}

class _PostOverViewState extends StateMVC<PostOverView> {
  PostOverViewController _postOverViewController;
  _PostOverViewState() : super(PostOverViewController()) {
    this._postOverViewController = controller;
  }
  int ordId;
  int _index = 0;
  PartnerDetailsProvider ordersProvider;
  // _PostOverViewState(this.value);
  // int _currentStep = 0;
  void chatWithPatner(responseData) {
    //need display circular indicator with z index
    _postOverViewController.chatWithpatner(responseData);
  }

  @override
  void initState() {
    ordersProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      var d = data.getOrders[widget.index];
      log("ord $d");
      if (data.ordersLoader) return Center(child: profileShimmer(context));

      List<String> images = List.from(d['media']);
      // final coordinates = Coordinates(d['loc'][0], d['loc'][1]);

      return Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: _hight * 0.16,
              // elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey[900],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWid(
                    text: _postOverViewController.jobs
                        .elementAt(d['job'])
                        .toString()
                        .toUpperCase(),
                    size: _width * 0.04,
                    color: Colors.grey[500],
                    lSpace: 1.5,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: _hight * 0.007,
                  ),
                  Row(
                    children: [
                      Icon(
                        _postOverViewController.orderStateIcon(d['ordState']),
                        color: Colors.indigo[900],
                        size: _width * 0.045,
                      ),
                      SizedBox(
                        width: _width * 0.01,
                      ),
                      TextWid(
                          text: _postOverViewController
                              .orderStateText(d['ordState']),
                          color: Colors.grey[700],
                          weight: FontWeight.w700,
                          size: _width * 0.04),
                    ],
                  )
                ],
              ),
              bottom: PreferredSize(
                  child: Container(
                    margin: EdgeInsets.only(bottom: _width * 0.01),
                    height: _hight * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButtonWidget(
                          height: _hight * 0.05,
                          minWidth: _width * 0.4,
                          bgColor: Colors.white,
                          borderSideColor: Colors.grey[200],
                          borderRadius: 10.0,
                          buttonName: 'Cancel',
                          textSize: _width * 0.04,
                          leadingIcon: Icon(
                            Icons.cancel,
                            color: Colors.grey[900],
                            size: _width * 0.045,
                          ),
                        ),
                        ElevatedButtonWidget(
                          height: _hight * 0.05,
                          minWidth: _width * 0.55,
                          bgColor: Colors.indigo[900],
                          borderSideColor: Colors.grey[200],
                          borderRadius: 10.0,
                          buttonName: 'Re-schedule',
                          textColor: Colors.white,
                          textSize: _width * 0.04,
                          trailingIcon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: _width * 0.045,
                          ),
                        )
                      ],
                    ),
                  ),
                  preferredSize: Size.fromHeight(4.0)),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.help,
                      color: Colors.grey[700],
                    )),
                IconButton(
                    onPressed: () {
                      bottomOptionsMenu(context,
                          options: _postOverViewController.options);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[900],
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    color: Colors.white,
                  ),
                  (d['ordState'] == 'onGoing')
                      ? TextWid(
                          text: 'Service was started on ' +
                              getDate(d['schedule']) +
                              "-" +
                              getTime(d['schedule']),
                          align: TextAlign.center,
                        )
                      : (d['ordState'] == 'completed')
                          ? TextWid(
                              text: 'Service was completed on ' +
                                  getDate(d['schedule']) +
                                  "-" +
                                  getTime(d['schedule']),
                              align: TextAlign.center,
                            )
                          : TextWid(
                              text: 'Service will start soon',
                              align: TextAlign.center,
                            ),
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
                    // height: _hight * 0.45,
                    width: _width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWid(
                                text: 'Service Details :',
                                size: _width * 0.055,
                                weight: FontWeight.w600,
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {},
                                  icon: Icon(Icons.edit))
                            ],
                          ),
                        ),
                        serviceDetailsListTile(
                          _width,
                          _hight,
                          'Issue/Problem',
                          Icons.settings,
                          d['problem'],
                        ),
                        serviceDetailsListTile(
                          _width,
                          _hight,
                          'Schedule',
                          Icons.schedule,
                          getDate(d['schedule']) + "-" + getTime(d['schedule']),
                        ),
                        serviceDetailsListTile(
                            _width,
                            _hight,
                            'Location',
                            Icons.location_on,
                            '10-134, NH16, Pothinamallayya Palem, Visakhapatnam, Andhra Pradesh 530041'),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  images.isNotEmpty
                      ? mediaView(_hight, _width, images)
                      : TextWid(
                          text: 'No media files found',
                          align: TextAlign.center,
                        ),
                  Divider(
                    color: Colors.white,
                  ),
                  warrentyCard(_hight, _width),
                  Divider(
                    color: Colors.white,
                  ),
                  (d['ordState'] == 'onGoing' || d['ordState'] == 'completed')
                      ? Container(
                          // height: _hight * 0.3,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWid(
                                      text: 'User Details :',
                                      size: _width * 0.055,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              userDetails(_hight, _width, context,
                                  _postOverViewController, d, chatWithPatner),
                            ],
                          ))
                      : Container(),
                  Container(
                    height: 500,
                    padding: EdgeInsets.only(left: 30, bottom: 50),
                    // width: _width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(child: _Timeline2(context)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          ProgressWaiter(contextt: context, loaderState: data.orderViewLoader),
        ],
      );
    });
  }

  serviceDetailsListTile(
    width,
    hight,
    title,
    icon,
    subtitle,
  ) {
    return ListTile(
        tileColor: Colors.redAccent,
        leading: Icon(
          icon,
          size: width * 0.045,
        ),
        title: TextWid(
          text: title,
          size: width * 0.045,
          weight: FontWeight.w600,
          color: Colors.grey[900],
          lSpace: 1.5,
        ),
        subtitle: TextWid(
          text: subtitle,
          size: width * 0.04,
          flow: TextOverflow.visible,
          weight: FontWeight.w600,
          color: Colors.grey[600],
          lSpace: 1,
        ),
        trailing: Container(
          width: width * 0.07,
        ));
  }

  mediaView(hight, width, images) {
    return Container(
      height: hight * 0.22,
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWid(
                  text: 'Media Files :',
                  size: width * 0.055,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Container(
            height: hight * 0.11,
            child: ListView.builder(
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Container(
                        child: images[index].contains('jpg')
                            ? InkWell(
                                onTap: () {
                                  imageslider(images, hight, width);
                                },
                                child: Container(
                                  width: width * 0.11,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(images[index]))),
                                ),
                              )
                            : images[index].contains('mp4')
                                ? TextWid(
                                    text: 'Video',
                                  )
                                : TextWid(text: 'Audio'),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  warrentyCard(hight, width) {
    return Container(
      height: hight * 0.2,
      width: width,
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.indigo[900],
          border: Border.all(color: Colors.indigo[900]),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            // alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 15, left: 20, right: 10),
            width: width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWid(
                  text: 'Warranty Card',
                  color: Colors.white,
                  size: width * 0.05,
                  weight: FontWeight.w600,
                ),
                SizedBox(
                  height: hight * 0.02,
                ),
                TextWid(
                  text: 'VALID TILL',
                  color: Colors.indigo[200],
                  size: width * 0.035,
                  weight: FontWeight.w600,
                ),
                TextWid(
                  text: '09 Oct,2021',
                  color: Colors.white,
                  size: width * 0.04,
                  weight: FontWeight.w600,
                ),
                SizedBox(
                  height: hight * 0.045,
                ),
                TextWid(
                  text: 'Claim Warranty >>',
                  color: Colors.white,
                  size: width * 0.045,
                  weight: FontWeight.w600,
                )
              ],
            ),
          ),
          Container(
            width: width * 0.3,
            child: SvgPicture.asset('assets/like.svg'),
          )
        ],
      ),
    );
  }

  // rating() {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true, // set to false if you want to force a rating
  //       builder: (context) {
  //         return RatingDialog(
  //           icon: Icon(
  //             Icons.rate_review,
  //             size: 100,
  //             color: Colors.blue[800],
  //           ),
  //           // const FlutterLogo(
  //           //   size: 100,
  //           // ), // set your own image/icon widget
  //           title: "Rate Your Technician!",
  //           description: "Express Your Experience By Tapping \nOn Stars",
  //           submitButton: "SUBMIT",
  //           alternativeButton: "Contact us instead?", // optional
  //           positiveComment: "We are so happy to hear :)", // optional
  //           negativeComment: "We're sad to hear :(", // optional
  //           accentColor: Colors.blue[800], // optional
  //           onSubmitPressed: (int rating) {
  //             print("onSubmitPressed: rating = $rating");
  //           },
  //           onAlternativePressed: () {
  //             print("onAlternativePressed: do something");
  //           },
  //         );
  //       });
  // }

  imageslider(List<String> images, double hight, double width) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            actions: [
              Container(
                  height: hight * 0.35,
                  width: width * 1,
                  child: CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (ctx, index, realIdx) {
                      return Container(
                          child: Image.network(images[index]
                              .substring(0, images[index].length - 1)));
                    },
                    options: CarouselOptions(
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlay: false,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                  ))
            ],
          );
        });
  }
}

userDetails(hight, width, BuildContext context, controller, orderDetails,
    chatWithPatner) {
  return Container(
    height: hight * 0.24,
    child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfilePic(
                  profile: orderDetails['uDetails']['pic'],
                  name: orderDetails['uDetails']['name'],
                  size: hight * 0.05,
                ),
                SizedBox(
                  width: width * 0.07,
                ),
                Container(
                  height: hight * 0.11,
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              TextWid(
                                text: toBeginningOfSentenceCase(
                                  orderDetails['uDetails']['name'] ?? 'Unknown',
                                ),
                                size: width * 0.04,
                                weight: FontWeight.w600,
                                color: Colors.grey[900],
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextWid(
                                  text: controller.jobs.elementAt(4) + ' | ',
                                  size: width * 0.025,
                                  weight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                                TextWid(
                                  // text: pDetails['rate'][0].toString(),
                                  text: '4.5',
                                  size: width * 0.025,
                                  weight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: width * 0.025,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Telugu | ',
                              style: fonts(width * 0.03, FontWeight.w600,
                                  Colors.grey[900]),
                            ),
                            Text(
                              'English | ',
                              style: fonts(width * 0.03, FontWeight.w600,
                                  Colors.grey[900]),
                            ),
                            Text(
                              'Hindi',
                              style: fonts(width * 0.03, FontWeight.w600,
                                  Colors.grey[900]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.45,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              size: width * 0.03,
                            ),
                            Text(
                              'Vizag',
                              style: fonts(width * 0.03, FontWeight.w600,
                                  Colors.grey[900]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: hight * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyCalling(
                          ordId: orderDetails['ordId'].toString(),
                          uId: orderDetails['uDetails']['uId'],
                          pId: orderDetails['pDetails']['pId'],
                          isIncoming: false,
                          name: orderDetails['uDetails']['name'].toString(),
                          profile: orderDetails['uDetails']['pic'].toString(),
                        )));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: width * 0.06,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.call,
                      color: Colors.grey[900],
                      size: width * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: hight * 0.01,
                  ),
                  TextWid(
                    text: 'Call',
                    size: width * 0.04,
                    weight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                chatWithPatner(orderDetails);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: width * 0.06,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.grey[900],
                      size: width * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: hight * 0.01,
                  ),
                  TextWid(
                    text: 'Message',
                    size: width * 0.04,
                    weight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

enum _TimelineStatus { request, accept, started, completed, feedback }

const kTileHeight = 90.0;

class _Timeline2 extends StatelessWidget {
  final BuildContext contextt;
  _Timeline2(this.contextt);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(contextt).size.width;
    final data = _TimelineStatus.values;
    return Flexible(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
            space: 20,
            color: Color(0xffd3d3d3),
          ),
          indicatorTheme: IndicatorThemeData(
            size: _width * 0.06,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        builder: TimelineTileBuilder.connected(
          contentsBuilder: (_, index) {
            return TimeLineTitle(index, contextt);
          },
          connectorBuilder: (_, index, connectorType) {
            if (index == 0) {
              return SolidLineConnector(
                color: Colors.indigo[700],
                indent: connectorType == ConnectorType.start ? 0 : 2.0,
                endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
              );
            } else {
              return SolidLineConnector(
                indent: connectorType == ConnectorType.start ? 0 : 2.0,
                endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
              );
            }
          },
          indicatorBuilder: (_, index) {
            switch (data[index]) {
              case _TimelineStatus.request:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.work_rounded,
                    color: Colors.grey[300],
                    size: _width * 0.035,
                  ),
                );
              case _TimelineStatus.accept:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.how_to_reg_rounded,
                    size: _width * 0.035,
                    color: Colors.grey[300],
                  ),
                );
              case _TimelineStatus.started:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.build,
                    size: _width * 0.035,
                    color: Colors.grey[300],
                  ),
                );
              case _TimelineStatus.completed:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.verified_rounded,
                    size: _width * 0.035,
                    color: Colors.grey[300],
                  ),
                );
              case _TimelineStatus.feedback:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.reviews,
                    size: _width * 0.035,
                    color: Colors.grey[300],
                  ),
                );
              default:
                return DotIndicator(
                  color: Colors.indigo[900],
                  child: Icon(
                    Icons.verified_rounded,
                    size: _width * 0.035,
                    color: Colors.white,
                  ),
                );
            }
          },
          itemExtentBuilder: (_, __) => kTileHeight,
          itemCount: data.length,
        ),
      ),
    );
  }
}

class TimeLineTitle extends StatelessWidget {
  final int index;
  final BuildContext contextt;
  TimeLineTitle(this.index, this.contextt);
  getStatus() {
    switch (index) {
      case 0:
        return "Service Requested";
      case 1:
        return "Order Accepted";
      case 2:
        return "Service Started";
      case 3:
        return "Service Completed";
      case 4:
        return "Feedback";
      default:
        return "Something Went wrong";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(contextt).size.width;
    return Container(
        padding: EdgeInsets.only(left: _width * 0.03),
        child: TextWid(
            text: getStatus(), size: _width * 0.04, weight: FontWeight.w600));
  }
}
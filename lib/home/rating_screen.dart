import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class RatingScreen extends StatefulWidget {
  final dynamic rating;
  // const RatingScreen({Key? key, this.rating}) : super(key: key);

  RatingScreen(this.rating);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SpotmiesTheme.background,
        elevation: 0,
        title: TextWid(
          text: 'Reviews',
          size: width(context) * 0.05,
          weight: FontWeight.w600,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: SpotmiesTheme.secondaryVariant,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: widget.rating.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: width(context) * 0.08,
                        backgroundColor: SpotmiesTheme.surfaceVariant2,
                        child: TextWid(
                          // text: widget.rating[index]['uDetails']?['name'][0],
                          text: 'S',
                          size: width(context) * 0.06,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextWid(
                                text: (widget.rating[index]['feedBackDetails']
                                            ?['rating'] /
                                        20)
                                    .toString(),
                                size: width(context) * 0.06,
                                weight: FontWeight.w600,
                                align: TextAlign.center,
                                flow: TextOverflow.ellipsis,
                              ),
                              Container(
                                  width: width(context) * 0.5,
                                  child: LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 500,
                                    progressColor: Colors.amber,
                                    percent: widget.rating[index]
                                            ['feedBackDetails']?['rating'] /
                                        100,
                                    backgroundColor: SpotmiesTheme.shadow,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: height(context) * 0.003,
                          ),
                          Container(
                            width: width(context) * 0.6,
                            child: TextWid(
                              // text: widget.rating[index]['uDetails']?['name'],
                              text: '',
                              size: width(context) * 0.03,
                              weight: FontWeight.w600,
                              flow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.012,
                          ),
                          Container(
                            width: width(context) * 0.6,
                            child: TextWid(
                              text: reviewDesc(
                                  widget.rating[index]['feedBackDetails']
                                      ?['description'],
                                  widget.rating[index]['feedBackDetails']
                                      ?['rating']),
                              size: width(context) * 0.05,
                              weight: FontWeight.w500,
                              flow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height(context) * 0.01,
                  ),
                  if (index != 2)
                    Divider(
                      thickness: 1,
                      color: SpotmiesTheme.shadow,
                      indent: width(context) * 0.07,
                      endIndent: width(context) * 0.02,
                    ),
                  if (index == 2)
                    SizedBox(
                      height: height(context) * 0.01,
                    ),
                  SizedBox(
                    height: height(context) * 0.01,
                  )
                ],
              );
            }),
      ),
    );
  }
}

//offline page card

reviewMsgs(BuildContext context, rating) {
  log(rating.toString());
  var len = rating.length > 3 ? 3 : rating.length;

  // if (rating[0]['feedBackDetails'] == null) {
  //   return Container();
  // }

  return Container(
    // height: (len * (height(context) * 0.19)) + height(context) * 0.1,
    width: width(context),
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 4, spreadRadius: 2, color: SpotmiesTheme.shadow)
        ],
        color: SpotmiesTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(15.0)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWid(
                text: 'Recent reviews',
                size: width(context) * 0.045,
                weight: FontWeight.w600,
                align: TextAlign.center,
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
                borderSideColor: Colors.transparent,
                onClick: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RatingScreen(rating)));
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: height(context) * 0.02,
        ),
        Container(
          height: (len * (height(context) * 0.11)) + height(context) * 0.09,
          width: width(context),
          child: ListView.builder(
              itemCount: len,
              itemBuilder: (context, index) {
                // var r = rating[index]['feedBackDetails'];
                // if (rating[index]['feedBackDetails']?['rating'] == null)
                //   return Container();
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // if (rating[index]['feedBackDetails']?['rating'] != null)
                        CircleAvatar(
                          radius: width(context) * 0.07,
                          backgroundColor: SpotmiesTheme.surfaceVariant2,
                          child: TextWid(
                            text: rating[index]['uDetails']['name'][0],
                            // text: 'S',
                            size: width(context) * 0.06,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                // if (rating[index]?['feedBackDetails'] != null)
                                TextWid(
                                  text: ((rating[index]['feedBackDetails']
                                              ?['rating']) /
                                          20)
                                      .toString(),
                                  size: width(context) * 0.06,
                                  weight: FontWeight.w600,
                                  align: TextAlign.center,
                                  flow: TextOverflow.ellipsis,
                                ),
                                Container(
                                    width: width(context) * 0.5,
                                    child: LinearPercentIndicator(
                                      animation: true,
                                      animationDuration: 500,
                                      progressColor: Colors.amber,
                                      percent: rating[index]['feedBackDetails']
                                              ?['rating']! /
                                          100,
                                      backgroundColor: SpotmiesTheme.shadow,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: height(context) * 0.003,
                            ),
                            // Container(
                            //   width: width(context) * 0.6,
                            //   child: TextWid(
                            //     text: rating[index]['uDetails']['name']
                            //         .toString(),
                            //     size: width(context) * 0.03,
                            //     weight: FontWeight.w600,
                            //     flow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: height(context) * 0.012,
                            // ),
                            Container(
                              width: width(context) * 0.6,
                              child: TextWid(
                                text: reviewDesc(
                                    rating[index]['feedBackDetails']
                                        ?['description'],
                                    rating[index]['feedBackDetails']
                                        ?['rating']),
                                size: width(context) * 0.05,
                                weight: FontWeight.w500,
                                flow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(context) * 0.01,
                    ),
                    if (index != 2)
                      Divider(
                        thickness: 1,
                        color: SpotmiesTheme.shadow,
                        indent: width(context) * 0.07,
                        endIndent: width(context) * 0.02,
                      ),
                    if (index == len - 1)
                      SizedBox(
                        height: height(context) * 0.01,
                      ),
                    // if (index == len - 1)
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
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => RatingScreen(rating)));
                    //   },
                    // ),
                    // SizedBox(
                    //   height: height(context) * 0.01,
                    // )
                  ],
                );
              }),
        ),
      ],
    ),
  );
}

reviewDesc(desc, int rate) {
  if (desc == '') {
    if (rate >= 80) return 'Excellent';
    if (rate >= 60) return 'Good';
    if (rate >= 40) return 'Not bad';
    if (rate >= 20) return 'Bad';
    if (rate >= 0) return 'Very bad';
  } else {
    return desc;
  }
}

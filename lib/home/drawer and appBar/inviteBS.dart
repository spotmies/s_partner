import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/dottedBorder.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

Future invites(BuildContext context, double hight, double width, pr) {
  return showModalBottomSheet(
      context: context,
      elevation: 22,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: hight * 0.7,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30),
                  height: hight * 0.22,
                  child: SvgPicture.asset('assets/share.svg')),
              Container(
                padding: EdgeInsets.all(10),
                // color: Colors.amber,
                child: DottedBorder(
                    dashPattern: [6, 3, 2, 3],
                    color: Colors.black,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(30),
                    padding: EdgeInsets.all(0),
                    strokeWidth: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: width * 0.8,
                      height: hight * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            referalCode(pr),
                            textAlign: TextAlign.center,
                            style: fonts(width * 0.06, FontWeight.w600,
                                Colors.grey[900]),
                          ),
                          Text(
                            'Share Your Referal Code With New Spotmies Users and Get Exciting Benifits',
                            textAlign: TextAlign.center,
                            style: fonts(width * 0.03, FontWeight.w500,
                                Colors.grey[900]),
                          )
                        ],
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                height: hight * 0.1,
                // color: Colors.amber,
                child: Center(
                  child: Text(
                    'Invite Your Friend and Get Benifits on Spotmies Partner App',
                    textAlign: TextAlign.center,
                    style:
                        fonts(width * 0.05, FontWeight.w600, Colors.grey[900]),
                  ),
                ),
              ),
              Container(
                // height: hight * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButtonWidget(
                        bgColor: Colors.indigo[900],
                        minWidth: width,
                        height: hight * 0.06,
                        textColor: Colors.white,
                        buttonName: 'Invite my friend',
                        textSize: width * 0.05,
                        textStyle: FontWeight.w600,
                        borderRadius: 5.0,
                        borderSideColor: Colors.indigo[900],
                        // trailingIcon: Icon(Icons.share),
                        onClick: () async {
                          String referal = await referalCode(pr);
                          Share.share(
                              "Install and explore the SPOTMIES PARTNER app to get unlimited freelancing service requests and earn organic money.\n\nreferal code = '$referal' \n\nhttps://play.google.com/store/apps/details?id=com.spotmiespartner",
                              subject: 'Spotmies partner app');
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButtonWidget(
                        bgColor: Colors.indigo[50],
                        minWidth: width,
                        height: hight * 0.06,
                        textColor: Colors.grey[900],
                        buttonName: 'Close',
                        textSize: width * 0.05,
                        textStyle: FontWeight.w600,
                        borderRadius: 5.0,
                        borderSideColor: Colors.indigo[50],
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // elevatedButton(context, width, 'Invite My Friend',
                    //     Colors.indigo[700], Colors.white, 'Data','InviteYes'),
                    // elevatedButton(context, width, 'Close', Colors.indigo[50],
                    //     Colors.indigo[900], 'Data','InviteNo')
                  ],
                ),
              )
            ],
          ),
        );
      });
}

referalCode(pr) {
  String code = pr['name'].toString().substring(0, 4).toUpperCase() +
      getDate(int.parse(pr['dob'])).toString().substring(
          getDate(int.parse(pr['dob'])).toString().length - 4,
          getDate(int.parse(pr['dob'])).toString().length);
  return code;
}

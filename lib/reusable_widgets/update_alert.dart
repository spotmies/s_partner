import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

 updateAlert(BuildContext context,) {
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
          height: height(context) * 0.45,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30),
                  height: height(context) * 0.22,
                  child: SvgPicture.asset('assets/update_alert.svg')),
              Container(
                height: height(context) * 0.06,
                child: Center(
                  child: Text(
                    'Letest version of Spotmies Partner app is available now.please update to letest version to get new features abd best experience',
                    style:
                        fonts(width(context) * 0.04, FontWeight.w600, Colors.grey[900]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   Container(
                    child: ElevatedButtonWidget(
                      bgColor: Colors.indigo[50],
                      minWidth: width(context)*0.25,
                      height: height(context) * 0.06,
                      textColor: Colors.grey[900],
                      buttonName: 'Close',
                      textSize: width(context) * 0.05,
                      textStyle: FontWeight.w600,
                      borderRadius: 5.0,
                      borderSideColor: Colors.indigo[50],
                      onClick: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    child: ElevatedButtonWidget(
                        bgColor: Colors.indigo[900],
                        minWidth: width(context)*0.7,
                        height: height(context) * 0.06,
                        textColor: Colors.white,
                        buttonName: 'Update',
                        textSize: width(context) * 0.05,
                        textStyle: FontWeight.w600,
                        borderRadius: 5.0,
                        borderSideColor: Colors.indigo[900],
                        // trailingIcon: Icon(Icons.share),
                        onClick: () async {}),
                  ),
                ],
              ),
             
            ],
          ),
        );
      });
}

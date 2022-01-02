import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help&supportBS.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class VerifictionInProgress extends StatelessWidget {
  final Map pd;
  VerifictionInProgress(this.pd);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            height: height(context) * 0.3,
            width: width(context),
            child: SvgPicture.asset('assets/svgs/catelog.svg')),
        SizedBox(
          height: height(context) * 0.06,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: width(context) * 0.04, right: width(context) * 0.03),
          child: TextWid(
            text:
                'You are successfully sumbitted your business profile to spotmies,your account has been under security verification process.it might take upto 24 to 48 hours,till then please keep checking your app every 6 hours',
            flow: TextOverflow.visible,
            size: width(context) * 0.05,
            align: TextAlign.center,
          ),
        ),
        SizedBox(
          height: height(context) * 0.12,
        ),
        ElevatedButtonWidget(
          buttonName: 'Need Help',
          height: height(context) * 0.055,
          minWidth: width(context) * 0.5,
          bgColor: Colors.indigo[900],
          textColor: Colors.grey[50],
          textSize: width(context) * 0.04,
          trailingIcon: Icon(
            Icons.help,
            color: Colors.grey[50],
            size: width(context) * 0.05,
          ),
          borderRadius: 15.0,
          borderSideColor: Colors.grey[900],
          onClick: () {
            helpAndSupport(context, height(context), width(context), pd);
          },
        ),
      ]),
    );
  }
}

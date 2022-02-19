import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/orders/post_overview.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

Future history(BuildContext context, double hight, double width,
    PartnerDetailsProvider partnerDetailsProvider) {
  // List<Map<String, Object>> data = [
  //   {
  //     "service": "teacher",
  //     "problem": "Need Maths Teacher",
  //     "pic": Icons.home_repair_service,
  //     "date": '24th Aug,2021',
  //     "time": '04:30 PM',
  //   },
  // ];
  return showModalBottomSheet(
      backgroundColor: SpotmiesTheme.background,
      context: context,
      elevation: 22,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Consumer<PartnerDetailsProvider>(
            builder: (context, data, child) {
          var o = data.getOrders;

          return Container(
              height: hight * 0.95,
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: ListView(children: [
                Container(
                    padding: EdgeInsets.only(top: 30),
                    height: hight * 0.22,
                    child: SvgPicture.asset('assets/history.svg')),
                Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                  child: Text(
                    'Spotmies Journey',
                    textAlign: TextAlign.center,
                    style: fonts(width * 0.05, FontWeight.w600,
                        SpotmiesTheme.secondaryVariant),
                  ),
                ),
                Container(
                  height: hight * 0.63,
                  child: ListView.builder(
                      itemCount: o.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<String> images = List.from(o[index]['media']);
                        dynamic orderData = o[index];
                        return Container(
                          height: hight * 0.15,
                          width: width,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: SpotmiesTheme.surfaceVariant2,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: SpotmiesTheme.background,
                                radius: width * 0.08,
                                child: (images.length == 0)
                                    ? Icon(
                                        Icons.engineering,
                                        color: SpotmiesTheme.secondaryVariant,
                                      )
                                    : Image.network(images.first),
                              ),
                              Container(
                                width: width * 0.52,
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWid(
                                      text: data
                                          .getServiceNameById(o[index]['job']),
                                      size: width * 0.04,
                                      weight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      height: hight * 0.02,
                                    ),
                                    TextWid(
                                        text: toBeginningOfSentenceCase(
                                                o[index]['problem'])
                                            .toString(),
                                        flow: TextOverflow.ellipsis,
                                        size: width * 0.04),
                                    SizedBox(
                                      height: hight * 0.01,
                                    ),
                                    TextWid(
                                      text: getDate(o[index]['schedule']) +
                                          ' - ' +
                                          getTime(o[index]['schedule']),
                                      color: SpotmiesTheme.secondary,
                                      size: width * 0.02,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => PostOverView(
                                            orderId:
                                                orderData['ordId'].toString(),
                                          ),
                                        ));
                                      },
                                      child: Text(
                                        'More',
                                        style: fonts(width * 0.04,
                                            FontWeight.w500, Colors.grey[500]),
                                      )))
                            ],
                          ),
                        );
                      }),
                )
              ]));
        });
      });
}

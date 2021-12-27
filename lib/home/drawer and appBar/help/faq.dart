import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/faqList.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

PartnerDetailsProvider partnerDetailsProvider;
GlobalKey exKey = GlobalKey();

apiHit() async {
  dynamic faq = await faqData();
  if (faq != null) partnerDetailsProvider.setFAQ(faq);
}

class _FAQState extends State<FAQ> {
  @override
  void initState() {
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    apiHit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[900],
            )),
        title: TextWid(
          text: 'Frequently Asked Questions',
          size: width(context) * 0.055,
          weight: FontWeight.w600,
        ),
      ),
      body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
        log(data.freqAskQue.toString());
        var faq = data.freqAskQue;
        if (faq == null)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView.builder(
            itemCount: faq.length,
            itemBuilder: (context, index) {
              var body = faq[index]['body'];
              return Column(
                children: [
                  SizedBox(
                    height: height(context) * 0.02,
                  ),
                  Container(
                    width: width(context) * 0.95,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        textColor: Colors.grey[900],
                        iconColor: Colors.grey[900],
                        collapsedIconColor: Colors.indigo[900],
                        collapsedTextColor: Colors.indigo[900],
                        title: TextWid(
                          text: faq[index]['title'],
                          size: width(context) * 0.05,
                          weight: FontWeight.w500,
                          flow: TextOverflow.visible,
                        ),
                        subtitle: TextWid(
                          text: faq[index]['description'],
                          size: width(context) * 0.03,
                          weight: FontWeight.w500,
                          flow: TextOverflow.visible,
                        ),
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: Container(
                              height: body.length <= 2
                                  ? height(context) * 0.25
                                  : body.length * (height(context) * 0.09),
                              child: ListView.builder(
                                  itemCount: body.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: ExpansionTile(
                                        // key: exKey,
                                        backgroundColor: Colors.white,
                                        collapsedBackgroundColor: Colors.white,
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.help),
                                          ],
                                        ),
                                        // expandedAlignment: Alignment.center,
                                        textColor: Colors.indigo[900],
                                        iconColor: Colors.indigo[900],
                                        collapsedIconColor: Colors.indigo[900],
                                        collapsedTextColor: Colors.indigo[900],
                                        title: TextWid(
                                          text: body[index]['question'],
                                          size: width(context) * 0.05,
                                          weight: FontWeight.w500,
                                          flow: TextOverflow.visible,
                                          color: Colors.indigo[900],
                                        ),

                                        children: [
                                          Container(
                                            // alignment: Alignment.centerRight,
                                            width: width(context) * 0.6,
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: TextWid(
                                              text: body[index]['answer'],
                                              flow: TextOverflow.visible,
                                              weight: FontWeight.w500,
                                              color: Colors.grey[700],
                                              lineSpace:
                                                  height(context) * 0.002,
                                              lSpace: 0.4,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}

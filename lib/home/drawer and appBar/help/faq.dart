import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/faqList.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

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
            onPressed: () {
              Navigator.pop(context);
            },
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
                        textColor: Colors.indigo[900],
                        iconColor: Colors.indigo[900],
                        collapsedIconColor: Colors.grey[900],
                        collapsedTextColor: Colors.grey[900],
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
      floatingActionButton: Container(
        padding: EdgeInsets.all(5),
        child: ElevatedButtonWidget(
          bgColor: Colors.indigo[900],
          minWidth: width(context) * 0.6,
          height: height(context) * 0.06,
          textColor: Colors.white,
          buttonName: 'Rise Query',
          textSize: width(context) * 0.05,
          textStyle: FontWeight.w600,
          borderRadius: 10.0,
          trailingIcon: Icon(Icons.question_answer),
          borderSideColor: Colors.indigo[900],
          onClick: () {
            var pD = partnerDetailsProvider.partnerDetailsFull;
            log(pD["_id"]);
            newQuery(context, onSubmit: (String output) {
              submitQuery(output, pD["_id"], context);
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

newQuery(BuildContext context,
    {Function onSubmit,
    String type = "text",
    String heading = "Rise a new query",
    String hint = "Ask Question",
    String defaultContent = ""}) {
  TextEditingController queryControl =
      TextEditingController(text: defaultContent);
  GlobalKey<FormState> queryForm = GlobalKey<FormState>();
  // bool loader = false;
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
        // if (loader)
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        return Container(
          height: height(context) * 0.47,
          margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: queryForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextWid(
                    text: heading,
                    size: width(context) * 0.06,
                    weight: FontWeight.w600,
                    flow: TextOverflow.visible,
                    align: TextAlign.center),
                TextFieldWidget(
                  label: hint,
                  hint: hint,
                  enableBorderColor: Colors.grey,
                  focusBorderColor: Colors.indigo[900],
                  enableBorderRadius: 15,
                  controller: queryControl,
                  isRequired: true,
                  focusBorderRadius: 15,
                  errorBorderRadius: 15,
                  focusErrorRadius: 15,
                  autofocus: true,
                  type: type,
                  maxLength: 500,
                  validateMsg: 'Please check above text',
                  maxLines: type == "text" ? 9 : 1,
                  // postIcon: Icon(Icons.change_circle),
                  postIconColor: Colors.indigo[900],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButtonWidget(
                    bgColor: Colors.indigo[900],
                    minWidth: width(context),
                    height: height(context) * 0.06,
                    textColor: Colors.white,
                    buttonName: 'Submit',
                    textSize: width(context) * 0.05,
                    textStyle: FontWeight.w600,
                    borderRadius: 10.0,
                    borderSideColor: Colors.indigo[50],
                    onClick: () async {
                      if (queryForm.currentState.validate()) {
                        if (onSubmit != null) {
                          onSubmit(queryControl.text);
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

submitQuery(subject, pDID, BuildContext context, {String suggestionFor}) async {
  Map<String, String> body = {
    "subject": subject.toString(),
    "suggestionFor": suggestionFor ?? "faq",
    "suggestionFrom": "partnerApp",
    "pId": API.pid.toString(),
    "pDetails": pDID.toString(),
  };
  dynamic response = await Server().postMethod(API.suggestions, body);
  // print("36 $response");
  if (response.statusCode == 200 || response.statusCode == 204) {
    log(response.body.toString());
    snackbar(context, 'Done');
    // loader = false;
  } else if (response.statusCode == 404) {
    log(response.body.toString());
    snackbar(context, 'Something went wrong');
    // loader = false;
  } else {
    log(response.body.toString());
    snackbar(context, 'server error');
    // loader = false;
  }
}

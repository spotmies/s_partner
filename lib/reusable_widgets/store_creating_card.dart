import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/editDetailsBS.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class SharingCard extends StatefulWidget {
  final PartnerDetailsProvider? provider;
  const SharingCard({Key? key, this.provider}) : super(key: key);
  @override
  _SharingCardState createState() => _SharingCardState();
}

class _SharingCardState extends State<SharingCard> {
  bool loading = false;
  List<dynamic>? getText() {
    Map<dynamic, dynamic>? partnerFull = widget.provider?.partnerDetailsFull;
    Map<dynamic, dynamic>? partner = widget.provider?.profileDetails;
    if (partnerFull?['catelogs'].length < 1) {
      return [
        "Create your Online Store",
        "List all your services to be requested the user",
        "spotmies.com/store",
        Icons.store_outlined,
        "Create now",
        0
      ];
    }
    if (partner?["storeId"] == null || partner?["storeId"] == "") {
      return [
        "Go Online!",
        "Share your web store's link on social media to attract more customers for your service",
        "spotmies.com/store/your_store_name",
        Icons.edit,
        "Create now",
        1
      ];
    }
    return [
      "Share More to Earn More",
      "Share your own web store's link on Social media to attract more customers to your service",
      "spotmies.com/store/${partner?["storeId"]}",
      Icons.share,
      "Share",
      2,
      "https://www.spotmies.com/store/${partner?["storeId"]}"
    ];
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    TextEditingController storeIdControl = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: SpotmiesTheme.background,
            buttonPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: TextWid(
              text: "Name your Online Store",
              size: width(context) * 0.045,
              weight: FontWeight.w600,
            ),
            content: StoreIdFormField(
                onChange: (String val) {
                  storeIdControl.text = val;
                },
                text: widget.provider?.partnerDetailsFull!['storeId'] ?? "",
                hint: widget.provider?.partnerDetailsFull!['businessName']),
            actions: [
              ElevatedButtonWidget(
                  onClick: () async {
                    Map<String, String> body = {"storeId": storeIdControl.text};
                    setState(() {
                      loading = true;
                    });
                    dynamic result =
                        await updatePartnerDetails(widget.provider!, body);
                    setState(() {
                      loading = false;
                    });
                    if (result.statusCode == 200) {
                      snackbar(context,
                          "Your online store has been created. Now you can share it with your customers!");
                      Navigator.pop(context);
                    }
                  },
                  // allRadius: true,
                  bottomLeftRadius: 20,
                  bottomRightRadius: 20,
                  textSize: width(context) * 0.045,
                  height: height(context) * 0.065,
                  minWidth: width(context),
                  bgColor: SpotmiesTheme.primary,
                  borderSideColor: SpotmiesTheme.primary,
                  buttonName: "Save",
                  textColor: SpotmiesTheme.background,
                  trailingIcon: loading
                      ? CircularProgressIndicator(
                          color: SpotmiesTheme.background,
                        )
                      : null),
            ],
          );
          // });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width(context) * 0.9,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: SpotmiesTheme.surfaceVariant,
          boxShadow: [
            BoxShadow(
                blurRadius: 4, spreadRadius: 2, color: SpotmiesTheme.shadow)
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextWid(
            text: getText()![0],
            weight: FontWeight.bold,
            size: width(context) * 0.05,
          ),
          TextWid(text: getText()![1], maxlines: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWid(
                text: getText()![2],
                weight: FontWeight.w700,
                color: SpotmiesTheme.primary,
              ),
              ElevatedButtonWidget(
                height: height(context) * 0.045,
                buttonName: getText()![4],
                allRadius: true,
                borderRadius: 10,
                textSize: width(context) * 0.04,
                bgColor: SpotmiesTheme.primary,
                textColor: SpotmiesTheme.background,
                trailingIcon: Icon(
                  getText()![3],
                  color: SpotmiesTheme.background,
                  size: width(context) * 0.045,
                ),
                onClick: () {
                  switch (getText()![5]) {
                    case 0:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Catalog(
                                    showCard: true,
                                  )));
                      break;

                    case 1:
                      _displayTextInputDialog(context);
                      break;
                    case 2:
                      Share.share(getText()![6],
                          subject: "Check my online store");

                      break;
                    default:
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

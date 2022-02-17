import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/catelog_controller.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class CatelogPost extends StatefulWidget {
  final int? index;
  final Map? cat;
  const CatelogPost({Key? key, this.index, this.cat}) : super(key: key);

  @override
  _CatelogPostState createState() => _CatelogPostState();
}

CatelogController catelogController = CatelogController();
PartnerDetailsProvider? partnerDetailsProvider;

class _CatelogPostState extends State<CatelogPost> {
  // var cate;
  // // var netcatelogPic;
  @override
  void initState() {
    super.initState();
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    if (widget.cat != null) {
      catelogController.fillAllForms(widget.cat);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (partnerDetailsProvider!.offlineScreenLoader == true)
      return circleProgress();
    return Scaffold(
      body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
        // var pD = data.getPartnerDetailsFull;
        // var cat = pD['catelogs'];
        return Container(
          padding: EdgeInsets.only(
              left: width(context) * 0.05, right: width(context) * 0.05),
          // height: height(context) * 1.2,
          child: Form(
            key: catelogController.catformkey,
            child: ListView(
              children: [
                SizedBox(
                  height: height(context) * 0.07,
                ),
                widget.cat != null
                    ? Stack(
                        children: [
                          Container(
                            height: height(context) * 0.2,
                            width: width(context),
                            decoration: BoxDecoration(
                                // shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(catelogController
                                        .netcatelogPic
                                        .toString()))),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: width(context) * 0.05,
                                backgroundColor: SpotmiesTheme.surfaceVariant2,
                                child: IconButton(
                                    onPressed: () async {
                                      await catelogController.catelogImage();
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.sync,
                                      size: width(context) * 0.05,
                                      color: SpotmiesTheme.secondaryVariant,
                                    )),
                              ))
                        ],
                      )
                    : catelogController.catelogPic != null
                        ? Stack(
                            children: [
                              Container(
                                height: height(context) * 0.2,
                                width: width(context),
                                decoration: BoxDecoration(
                                    // shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            catelogController.catelogPic!))),
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: width(context) * 0.05,
                                    backgroundColor:
                                        SpotmiesTheme.surfaceVariant2,
                                    child: IconButton(
                                        onPressed: () async {
                                          await catelogController
                                              .catelogImage();
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.sync,
                                          size: width(context) * 0.05,
                                          color: SpotmiesTheme.secondaryVariant,
                                        )),
                                  ))
                            ],
                          )
                        : Container(
                            height: height(context) * 0.2,
                            width: width(context),
                            decoration: BoxDecoration(
                              color: SpotmiesTheme.background,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              // border: Border.all()
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  await catelogController.catelogImage();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.image,
                                  size: width(context) * 0.2,
                                  color: Colors.grey,
                                ))),
                SizedBox(
                  height: height(context) * 0.02,
                ),
                TextFieldWidget(
                  hint: 'Enter Service Name',
                  label: 'Service Name',
                  controller: catelogController.catNameControl,
                  enableBorderColor: Colors.grey,
                  focusBorderColor: SpotmiesTheme.secondaryVariant,
                  enableBorderRadius: 15,
                  focusBorderRadius: 15,
                  errorBorderRadius: 15,
                  isRequired: true,
                  focusErrorRadius: 15,
                  validateMsg: 'Enter Valid Money',
                  maxLines: 1,
                  postIcon: Icon(Icons.home_repair_service),
                  postIconColor: SpotmiesTheme.secondaryVariant,
                ),
                SizedBox(
                  height: height(context) * 0.02,
                ),
                TextFieldWidget(
                  controller: catelogController.catPriceControl,
                  hint: 'Price',
                  label: 'Basic Price',
                  type: "number",
                  enableBorderColor: Colors.grey,
                  keyBoardType: TextInputType.number,
                  formatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  focusBorderColor: SpotmiesTheme.secondaryVariant,
                  enableBorderRadius: 15,
                  focusBorderRadius: 15,
                  errorBorderRadius: 15,
                  focusErrorRadius: 15,
                  isRequired: true,
                  validateMsg: 'Enter Valid Money',
                  maxLines: 1,
                  prefix: '₹  ',
                  postIcon: Icon(Icons.attach_money),
                  postIconColor: SpotmiesTheme.background,
                ),
                SizedBox(
                  height: height(context) * 0.02,
                ),
                TextFieldWidget(
                  controller: catelogController.catDescControl,
                  hint: 'Description',
                  label: 'Add Description...',
                  enableBorderColor: Colors.grey,
                  isRequired: true,

                  focusBorderColor: SpotmiesTheme.secondaryVariant,
                  enableBorderRadius: 15,
                  focusBorderRadius: 15,
                  errorBorderRadius: 15,
                  focusErrorRadius: 15,
                  validateMsg: 'Enter Valid Money',
                  maxLines: 8,
                  // maxLength: 150,
                  postIcon: Icon(Icons.info),
                  postIconColor: SpotmiesTheme.secondaryVariant,
                ),
                SizedBox(height: height(context) * 0.1),
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
                  borderRadius: 10.0,
                  borderSideColor: SpotmiesTheme.secondaryVariant,
                  onClick: () async {
                    if (catelogController.catformkey.currentState!.validate()) {
                      setState(() {
                        partnerDetailsProvider!.offlineScreenLoader = true;
                      });

                      int itemCode = partnerDetailsProvider!
                          .partnerDetailsFull!['catelogs'].length;
                      int job =
                          partnerDetailsProvider!.partnerDetailsFull!['job'];

                      // log(cat[widget.index]["_id"].toString());
                      var res;
                      var resp;
                      if (widget.cat == null) {
                        res = await catelogController.addCatlogList(
                            itemCode, job, context);
                      } else {
                        resp = await catelogController.updateCat(
                            widget.cat!["_id"], context);
                      }

                      log(res.toString());
                      log(resp.toString());
                      if (res != null) {
                        if (res != null)
                          partnerDetailsProvider!.setCategoryItem(res);

                        setState(() {
                          partnerDetailsProvider!.offlineScreenLoader = false;
                          catelogController.catDescControl.clear();
                          catelogController.catNameControl.clear();
                          catelogController.catPriceControl.clear();
                          catelogController.catelogPic = null;
                        });

                        Navigator.pop(context);
                      }

                      if (resp != null) {
                        if (resp != null)
                          partnerDetailsProvider!
                              .updateCategoryItem(resp, widget.index);
                        setState(() {
                          partnerDetailsProvider!.offlineScreenLoader = false;
                        });

                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

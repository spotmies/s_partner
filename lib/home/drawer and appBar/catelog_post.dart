import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/catelog_controller.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
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
    catelogController.resetForm();
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    if (widget.cat != null) {
      catelogController.editAllFields(widget.cat);
    }
    if (widget.cat == null) {
      catelogController.fillAllForms();
    }
  }

  changePickedImage() async {
    log("onclick 2");
    await catelogController.catelogImage();

    setState(() {});
  }

  Stack pickedLocalImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height(context) * 0.2,
          width: width(context),
          decoration: BoxDecoration(
              // shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(catelogController.catelogPic!))),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: width(context) * 0.05,
              backgroundColor: SpotmiesTheme.surfaceVariant2,
              child: IconButton(
                  onPressed: changePickedImage,
                  icon: Icon(
                    Icons.sync,
                    size: width(context) * 0.05,
                    color: SpotmiesTheme.secondaryVariant,
                  )),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
          var pD = data.getPartnerDetailsFull;
          // log(pD["_id"].toString());
          if (data.offlineScreenLoader) return circleProgress();
          return Scaffold(
            backgroundColor: SpotmiesTheme.background,
            body: Container(
              padding: EdgeInsets.only(
                  left: width(context) * 0.05, right: width(context) * 0.05),
              // height: height(context) * 1.2,
              child: Form(
                key: catelogController.catformkey,
                child: ListView(
                  children: [
                    // SizedBox(
                    //   height: height(context) * 0.07,
                    // ),
                    // widget.cat != null
                    //     ? onlineImage(context)
                    //     : catelogController.catelogPic != null
                    //         ? pickedLocalImage(context)
                    //         : emptyImagePlaceHolder,
                    Visibility(
                      visible: widget.cat != null && !widget.cat?['isVerified'],
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: Colors.amber[700],
                              size: width(context) * 0.05,
                            ),
                            SizedBox(
                              width: width(context) * 0.02,
                            ),
                            Container(
                              width: width(context) * 0.8,
                              child: TextWid(
                                text: widget.cat?["errorMessage"] ??
                                    'catelog under verification'.toString(),
                                color: Colors.amber[700],
                                size: width(context) * 0.05,
                                weight: FontWeight.w500,
                                maxlines: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    Container(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: catelogController.netCatelogPics.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 200,
                              margin: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: catelogController.netCatelogPics[index]
                                                ['type'] ==
                                            "online" ||
                                        catelogController.netCatelogPics[index]
                                                ['type'] ==
                                            "placeHolder"
                                    ? InkWell(
                                        onTap: () async {
                                          await catelogController
                                              .pickCatelogImage(index);
                                          setState(() {});
                                        },
                                        child: catelogController
                                                        .netCatelogPics[index]
                                                    ['type'] ==
                                                "online"
                                            ? Image.network(
                                                catelogController
                                                        .netCatelogPics[index]
                                                    ['path'],
                                                fit: BoxFit.cover,
                                                width: 1000.0)
                                            : Container(
                                                height: height(context) * 0.2,
                                                width: width(context),
                                                decoration: BoxDecoration(
                                                  color: SpotmiesTheme.dull,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                  // border: Border.all()
                                                ),
                                                child: Icon(
                                                  Icons.image,
                                                  size: width(context) * 0.26,
                                                  color: Colors.grey,
                                                )),
                                      )
                                    : Image.file(catelogController
                                        .netCatelogPics[index]['path']),
                              ),
                            );
                          }),
                      height: 220,
                      padding: EdgeInsets.only(bottom: 10),
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
                      // postIcon: Icon(Icons.home_repair_service),
                      // postIconColor: SpotmiesTheme.secondaryVariant,
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
                      // postIcon: Icon(Icons.attach_money),
                      // postIconColor: SpotmiesTheme.background,
                    ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    TextFieldWidget(
                      controller: catelogController.catOfferPrice,
                      hint: 'Offer Price (optional)',
                      label: 'Offer Price (optional)',
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
                      isRequired: false,
                      validateMsg: 'Enter Valid Money',
                      maxLines: 1,
                      prefix: '₹  ',
                      // postIcon: Icon(Icons.attach_money),
                      // postIconColor: SpotmiesTheme.background,
                    ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    TextWid(
                      text: " Time to complete work",
                      weight: FontWeight.w500,
                      size: width(context) * 0.045,
                    ),
                    SizedBox(
                      height: height(context) * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context) * 0.42,
                          child: TextFieldWidget(
                            controller: catelogController.days,
                            hint: 'Days',
                            label: 'Days',
                            enableBorderColor: Colors.grey,
                            keyBoardType: TextInputType.number,
                            formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            focusBorderColor: SpotmiesTheme.secondaryVariant,
                            enableBorderRadius: 15,
                            focusBorderRadius: 15,
                            errorBorderRadius: 15,
                            focusErrorRadius: 15,
                            isRequired: true,
                            validateMsg: 'Enter Valid Text',
                            maxLines: 1,
                            type: "number",
                            // postIcon: Icon(Icons.attach_money),
                            // postIconColor: SpotmiesTheme.background,
                          ),
                        ),
                        SizedBox(
                          width: width(context) * 0.42,
                          child: TextFieldWidget(
                            controller: catelogController.hours,
                            hint: 'Hours',
                            label: 'Hours',
                            enableBorderColor: Colors.grey,
                            keyBoardType: TextInputType.number,
                            formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            focusBorderColor: SpotmiesTheme.secondaryVariant,
                            enableBorderRadius: 15,
                            focusBorderRadius: 15,
                            errorBorderRadius: 15,
                            focusErrorRadius: 15,
                            isRequired: true,
                            validateMsg: 'Enter Valid Text',
                            maxLines: 1,
                            type: "number",
                            // postIcon: Icon(Icons.attach_money),
                            // postIconColor: SpotmiesTheme.background,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(context) * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWid(
                              text: " Is under warranty",
                              weight: FontWeight.w500,
                              size: width(context) * 0.045,
                            ),
                            Switch(
                                value: catelogController.isWarranty,
                                activeColor: SpotmiesTheme.primary,
                                onChanged: (value) {
                                  setState(() {
                                    catelogController.isWarranty = value;
                                  });
                                }),
                          ],
                        ),
                        if (catelogController.isWarranty == true)
                          SizedBox(
                            width: width(context) * 0.5,
                            child: TextFieldWidget(
                              controller: catelogController.warrantyVal,
                              hint: 'Warranty Validity',
                              label: 'Warranty Validity',
                              enableBorderColor: Colors.grey,
                              keyBoardType: TextInputType.number,
                              formatter: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              focusBorderColor: SpotmiesTheme.secondaryVariant,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              isRequired: true,
                              validateMsg: 'Enter Valid Text',
                              maxLines: 1,
                              // postIcon: Icon(Icons.attach_money),
                              // postIconColor: SpotmiesTheme.background,
                            ),
                          ),
                      ],
                    ),
                    if (catelogController.isWarranty == true)
                      SizedBox(
                        height: height(context) * 0.02,
                      ),
                    if (catelogController.isWarranty == true)
                      TextFieldWidget(
                        controller: catelogController.warrantyDet,
                        hint: 'Warranty Details',
                        label: 'Warranty details',
                        enableBorderColor: Colors.grey,
                        keyBoardType: TextInputType.name,
                        // formatter: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        // ],
                        focusBorderColor: SpotmiesTheme.secondaryVariant,
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        isRequired: true,
                        validateMsg: 'Enter Valid Text',
                        maxLines: 1,
                        // postIcon: Icon(Icons.attach_money),
                        // postIconColor: SpotmiesTheme.background,
                      ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    TextFieldWidget(
                      controller: catelogController.wI,
                      hint: 'What includes',
                      label: 'What includes',
                      enableBorderColor: Colors.grey,
                      keyBoardType: TextInputType.name,
                      // formatter: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // ],
                      focusBorderColor: SpotmiesTheme.secondaryVariant,
                      enableBorderRadius: 15,
                      focusBorderRadius: 15,
                      errorBorderRadius: 15,
                      focusErrorRadius: 15,
                      isRequired: true,
                      validateMsg: 'Enter Valid Text',
                      maxLines: 1,
                      // postIcon: Icon(Icons.attach_money),
                      // postIconColor: SpotmiesTheme.background,
                    ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    TextFieldWidget(
                      controller: catelogController.wNI,
                      hint: 'What not includes',
                      label: 'What not includes',
                      enableBorderColor: Colors.grey,
                      keyBoardType: TextInputType.name,
                      // formatter: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // ],
                      focusBorderColor: SpotmiesTheme.secondaryVariant,
                      enableBorderRadius: 15,
                      focusBorderRadius: 15,
                      errorBorderRadius: 15,
                      focusErrorRadius: 15,
                      isRequired: true,
                      validateMsg: 'Enter Valid Text',
                      maxLines: 1,
                      // postIcon: Icon(Icons.attach_money),
                      // postIconColor: SpotmiesTheme.background,
                    ),
                    SizedBox(
                      height: height(context) * 0.02,
                    ),
                    TextFieldWidget(
                      controller: catelogController.catTAC,
                      hint: 'Terms&Conditions',
                      label: 'Terms&Conditions',
                      enableBorderColor: Colors.grey,
                      keyBoardType: TextInputType.name,
                      // formatter: <TextInputFormatter>[
                      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // ],

                      focusBorderColor: SpotmiesTheme.secondaryVariant,
                      enableBorderRadius: 15,
                      focusBorderRadius: 15,
                      errorBorderRadius: 15,
                      focusErrorRadius: 15,
                      isRequired: true,
                      validateMsg: 'Enter Valid Text',
                      maxLines: 1,
                      // postIcon: Icon(Icons.attach_money),
                      // postIconColor: SpotmiesTheme.onBackground,
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
                      validateMsg: 'Enter Description Here',
                      maxLines: 8,
                      // maxLength: 150,
                      // postIcon: Icon(Icons.info),
                      // postIconColor: SpotmiesTheme.secondaryVariant,
                    ),
                    SizedBox(height: height(context) * 0.1),
                  ],
                ),
              ),
            ),
            floatingActionButton: ElevatedButtonWidget(
                buttonName: widget.cat != null ? "Update" : 'Add Service',
                height: height(context) * 0.055,
                minWidth: width(context) * 0.9,
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
                borderSideColor: SpotmiesTheme.background,
                onClick: () async {
                  // if (catelogController.catelogPic == null &&
                  //     !catelogController.isEditForm) {
                  //   return snackbar(context, "Please upload image");
                  // }

                  if (catelogController.catformkey.currentState!.validate() ==
                      false) {
                    return;
                  }
                  partnerDetailsProvider?.setOffileLoader(true);
                  if (!await catelogController.checkAndUploadImages(context)) {
                    partnerDetailsProvider?.setOffileLoader(false);
                    return;
                  }

                  int itemCode = partnerDetailsProvider!
                      .partnerDetailsFull!['catelogs'].length;
                  int job = partnerDetailsProvider!.partnerDetailsFull!['job'];

                  var res;
                  var resp;
                  if (widget.cat == null) {
                    res = await catelogController.addCatlogList(
                        itemCode, job, context, pD["_id"]);
                    log(res.toString());
                    partnerDetailsProvider?.setOffileLoader(false);
                  } else {
                    resp = await catelogController.updateCat(
                        widget.cat!["_id"], context);
                    partnerDetailsProvider?.setOffileLoader(false);
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
                    if (widget.cat != null) Navigator.pop(context);
                  }

                  if (resp != null) {
                    if (resp != null)
                      partnerDetailsProvider!
                          .updateCategoryItem(resp, widget.index);

                    Navigator.pop(context);
                    if (widget.cat != null) Navigator.pop(context);
                  }
                }),
          );
        }),
      ),
    );
  }

  Stack onlineImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height(context) * 0.2,
          width: width(context),
          decoration: BoxDecoration(
              // shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              image: catelogController.catelogPic != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(catelogController.catelogPic!))
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          catelogController.netcatelogPic.toString()))),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: width(context) * 0.05,
              backgroundColor: SpotmiesTheme.surfaceVariant2,
              child: IconButton(
                  onPressed: changePickedImage,
                  icon: Icon(
                    Icons.sync,
                    size: width(context) * 0.05,
                    color: SpotmiesTheme.secondaryVariant,
                  )),
            ))
      ],
    );
  }
}

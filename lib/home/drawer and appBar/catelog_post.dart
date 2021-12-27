import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/catelog_controller.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class CatelogPost extends StatefulWidget {
  const CatelogPost({Key key}) : super(key: key);

  @override
  _CatelogPostState createState() => _CatelogPostState();
}

CatelogController catelogController = CatelogController();
PartnerDetailsProvider partnerDetailsProvider;

class _CatelogPostState extends State<CatelogPost> {
  @override
  void initState() {
    super.initState();
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (partnerDetailsProvider.offlineScreenLoader == true)
      return circleProgress();
    return Scaffold(
      body: Container(
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
              catelogController.catelogPic != null
                  ? Container(
                      height: height(context) * 0.2,
                      width: width(context),
                      decoration: BoxDecoration(
                          // shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(catelogController.catelogPic))),
                    )
                  : Container(
                      height: height(context) * 0.2,
                      width: width(context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        // border: Border.all()
                      ),
                      child: IconButton(
                          onPressed: () {
                            catelogController.catelogImage();
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
                focusBorderColor: Colors.grey[900],
                enableBorderRadius: 15,
                focusBorderRadius: 15,
                errorBorderRadius: 15,
                isRequired: true,
                focusErrorRadius: 15,
                validateMsg: 'Enter Valid Money',
                maxLines: 1,
                postIcon: Icon(Icons.home_repair_service),
                postIconColor: Colors.grey[900],
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
                focusBorderColor: Colors.grey[900],
                enableBorderRadius: 15,
                focusBorderRadius: 15,
                errorBorderRadius: 15,
                focusErrorRadius: 15,
                isRequired: true,
                validateMsg: 'Enter Valid Money',
                maxLines: 1,
                prefix: '₹  ',
                postIcon: Icon(Icons.attach_money),
                postIconColor: Colors.white,
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

                focusBorderColor: Colors.grey[900],
                enableBorderRadius: 15,
                focusBorderRadius: 15,
                errorBorderRadius: 15,
                focusErrorRadius: 15,
                validateMsg: 'Enter Valid Money',
                maxLines: 8,
                // maxLength: 150,
                postIcon: Icon(Icons.info),
                postIconColor: Colors.grey[900],
              ),
              SizedBox(height: height(context) * 0.1),
              ElevatedButtonWidget(
                buttonName: 'Add Service',
                height: height(context) * 0.055,
                minWidth: width(context) * 0.5,
                bgColor: Colors.indigo[900],
                textColor: Colors.grey[50],
                textSize: width(context) * 0.04,
                leadingIcon: Icon(
                  Icons.add_circle,
                  color: Colors.grey[50],
                  size: width(context) * 0.05,
                ),
                borderRadius: 10.0,
                borderSideColor: Colors.grey[900],
                onClick: () async {
                  if (catelogController.catformkey.currentState.validate()) {
                    setState(() {
                      partnerDetailsProvider.offlineScreenLoader = true;
                    });

                    int itemCode = partnerDetailsProvider
                        .partnerDetailsFull['catelogs'].length;
                    int job = partnerDetailsProvider.partnerDetailsFull['job'];

                    var res =
                        await catelogController.addCatlogList(itemCode, job);

                    log(res.toString());
                    if (res != null) {
                      partnerDetailsProvider.setCategoryItem(res);
                      setState(() {
                        partnerDetailsProvider.offlineScreenLoader = false;
                      });
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

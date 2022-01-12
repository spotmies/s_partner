import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

Widget step1UI(
    BuildContext context,
    double width,
    double hight,
    ScrollController scrollController,
    StepperController stepperController,
    String type,
    dynamic termsAndConditions) {
  return Column(
    children: [
      Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          height: hight * 0.75,
          child:
              // var document = snapshot.data;
              Container(
            height: hight * 0.7,
            child: ListView.builder(
                controller: scrollController,
                itemCount: termsAndConditions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      TextWid(
                        text: "${index + 1}.  " + termsAndConditions[index],
                        size: width * 0.06,
                        flow: TextOverflow.visible,
                      ),
                      if (index != 7)
                        Divider(
                          color: Colors.grey[400],
                          indent: width * 0.1,
                          endIndent: width * 0.1,
                        ),
                      if (index == termsAndConditions.length - 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                activeColor: Colors.teal,
                                checkColor: Colors.white,
                                value: stepperController.accept,
                                shape: CircleBorder(),
                                onChanged: (bool? value) {
                                  stepperController.accept = value;
                                  if (stepperController.accept == true) {
                                    stepperController.tca = 'accepted';
                                  }
                                  stepperController.refresh();
                                }),
                            Text(
                              'I agree to accept the terms and Conditions',
                              style: TextStyle(fontSize: width * 0.03),
                            ),
                          ],
                        ),
                    ],
                  );
                }),
          )),
    ],
  );
}

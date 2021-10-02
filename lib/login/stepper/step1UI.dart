import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

List terms = [
  "Spotmies partner not supposed to Save customer details,as well as not supposed to give contact information to customer",
  "Spotmies partners are not supposed to share customer details to others,it will be considered as an illegal activity",
  "we do not Entertain any illegal activities.if perform severe actions will be taken",
  "partners are responsible for the damages done during the services and they bare whole forfeit",
  "we do not provide  any kind of training,equipment/material and  labor to perform any Service",
  "We do not provide any shipping charges,travelling fares",
  "partner should take good care of their appearance ,language ,behaviour while they perform service",
  "partner should fellow all the covid regulations",
];

Widget step1UI(BuildContext context, double width, double hight,
    ScrollController scrollController, StepperController stepperController, String type) {
  return Column(
    children: [
      Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        height: hight * 0.75,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('terms')
                .doc('eXiU3vxjO7qeVObTqvmQ')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              // var document = snapshot.data;
              return Container(
                height: hight * 0.7,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: terms.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          TextWid(
                            text: "${index + 1}.  " + terms[index],
                            size: width * 0.06,
                            flow: TextOverflow.visible,
                          ),
                          if (index != 7)
                            Divider(
                              color: Colors.grey[400],
                              indent: width * 0.1,
                              endIndent: width * 0.1,
                            ),
                          if (index == 7)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                    activeColor: Colors.teal,
                                    checkColor: Colors.white,
                                    value: stepperController.accept,
                                    shape: CircleBorder(),
                                    onChanged: (bool value) {
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
              );
            }),
      ),
    ],
  );
}

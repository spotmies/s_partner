import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class Step1 extends StatefulWidget {
  final ScrollController? scrollController;
  final String? type;
  final dynamic termsAndConditions;
  final StepperController? stepperController;
  const Step1({
    Key? key,
    this.scrollController,
    this.type,
    this.termsAndConditions,
    this.stepperController,
  }) : super(key: key);

  @override
  _Step1State createState() => _Step1State();
}

// StepperController? stepperController = StepperController();

class _Step1State extends State<Step1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            // padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            height: height(context) * 0.72,
            child:
                // var document = snapshot.data;
                Container(
              // height: height(context) * 0.65,
              child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: widget.termsAndConditions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        TextWid(
                          text: "${index + 1}.  " +
                              widget.termsAndConditions[index],
                          size: width(context) * 0.06,
                          flow: TextOverflow.visible,
                        ),
                        if (index != 7)
                          Divider(
                            color: Colors.grey[400],
                            indent: width(context) * 0.1,
                            endIndent: width(context) * 0.1,
                          ),
                        if (index == widget.termsAndConditions.length - 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        SpotmiesTheme.primary.withOpacity(0.5)),
                                child: Checkbox(
                                    activeColor: Colors.teal,
                                    checkColor: Colors.white,
                                    value: widget.stepperController?.accept,
                                    shape: CircleBorder(),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.stepperController?.accept =
                                            value!;

                                        if (widget.stepperController?.accept ==
                                            true) {
                                          widget.stepperController?.tca =
                                              'accepted';
                                        }
                                      });
                                      widget.stepperController?.refresh();
                                    }),
                              ),
                              Text(
                                'I agree to accept the terms and Conditions',
                                style: TextStyle(
                                    fontSize: width(context) * 0.03,
                                    color: SpotmiesTheme.onBackground),
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
}





// Widget step1UI(
//     BuildContext context,
//     double? width,
//     double? hight,
//     ScrollController? scrollController,
//     StepperController? stepperController,
//     String? type,
//     dynamic termsAndConditions) {
//   return Column(
//     children: [
//       Container(
//           // padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               // color: Colors.white,
//               borderRadius: BorderRadius.circular(10)),
//           height: hight! * 0.75,
//           child:
//               // var document = snapshot.data;
//               Container(
//             height: hight * 0.7,
//             child: ListView.builder(
//                 controller: scrollController,
//                 itemCount: termsAndConditions.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       TextWid(
//                         text: "${index + 1}.  " + termsAndConditions[index],
//                         size: width! * 0.06,
//                         flow: TextOverflow.visible,
//                       ),
//                       if (index != 7)
//                         Divider(
//                           color: Colors.grey[400],
//                           indent: width * 0.1,
//                           endIndent: width * 0.1,
//                         ),
//                       if (index == termsAndConditions.length - 1)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Checkbox(
//                                 activeColor: Colors.teal,
//                                 checkColor: Colors.white,
//                                 value: stepperController?.accept,
//                                 shape: CircleBorder(),
//                                 onChanged: (bool? value) {
//                                   stepperController!.accept = value;
//                                   if (stepperController.accept == true) {
//                                     stepperController.tca = 'accepted';
//                                   }
//                                   stepperController.refresh();
//                                 }),
//                             Text(
//                               'I agree to accept the terms and Conditions',
//                               style: TextStyle(fontSize: width * 0.03),
//                             ),
//                           ],
//                         ),
//                     ],
//                   );
//                 }),
//           )),
//     ],
//   );
// }
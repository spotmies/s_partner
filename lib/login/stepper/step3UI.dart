import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/login/stepper/step2UI.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/dottedBorder.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class Step3 extends StatefulWidget {
  final String? type;
  final StepperController? stepperController;
  final PartnerDetailsProvider? provider;
  const Step3({Key? key, this.type, this.stepperController, this.provider})
      : super(key: key);

  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.72,
      child: Form(
        key: widget.stepperController?.step3Formkey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: width(context) * 0.03,
                  right: width(context) * 0.00,
                  bottom: width(context) * 0.03),
              height: height(context) * 0.08,
              width: height(context) * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // alignment: WrapAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: widget.provider?.getServiceListFromServer,
                    child: TextWid(
                      text: 'Business type:',
                      color: SpotmiesTheme.secondaryVariant,
                      size: width(context) * 0.05,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: width(context) * 0.03,
                          right: width(context) * 0.03),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: SpotmiesTheme.shadow,
                                blurRadius: 3,
                                spreadRadius: 1)
                          ],
                          color: SpotmiesTheme.background,
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton(
                        underline: SizedBox(),
                        value: widget.stepperController?.dropDownValue,
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          size: width(context) * 0.06,
                          color: SpotmiesTheme.primary,
                        ),
                        items: widget.provider?.getServiceList
                            .where(
                                (element) => element['isMainService'] == true)
                            .map((location) {
                          return DropdownMenuItem(
                            child: TextWid(
                              text: location['nameOfService'],
                              color: SpotmiesTheme.secondaryVariant,
                              size: width(context) * 0.04,
                              weight: FontWeight.w500,
                            ),
                            value: location['serviceId'],
                          );
                        }).toList(),
                        hint: TextWid(
                          text: 'Select Service',
                          color: SpotmiesTheme.secondaryVariant,
                          size: width(context) * 0.04,
                          weight: FontWeight.w500,
                        ),
                        onChanged: (newVal) {
                          setState(() {
                            widget.stepperController?.dropDownValue =
                                newVal as int;
                          });
                          //  widget. stepperController?.refresh();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            registrationField(
                context,
                widget.stepperController!,
                widget.type != 'student' ? 'Business Name' : 'College Name',
                'Enter Valid Business Name',
                widget.type == "student"
                    ? widget.stepperController?.collegeNameTf
                    : widget.stepperController?.businessNameTf,
                Icons.business,
                'text',
                TextInputType.name,
                30),
            registrationField(
                context,
                widget.stepperController!,
                'Years of experience',
                'Enter Valid Experience',
                widget.stepperController?.experienceTf,
                Icons.work,
                'number',
                TextInputType.number,
                2),
            // UploadUI(
            //   imageType: 'front',
            //   stepperController: widget.stepperController,
            //   condition: widget.stepperController?.adharfront == null,
            //   onClick: () async {
            //     await widget.stepperController?.adharfrontpage();

            //     setState(() {});
            //   },
            // ),
            // UploadUI(
            //   imageType: 'back',
            //   stepperController: widget.stepperController,
            //   condition: widget.stepperController?.adharback == null,
            //   onClick: () async {
            //     await widget.stepperController?.adharBack();

            //     setState(() {});
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class UploadUI extends StatefulWidget {
  final String? imageType;
  final StepperController? stepperController;
  final bool? condition;
  final VoidCallback? onClick;
  const UploadUI(
      {Key? key,
      this.imageType,
      this.stepperController,
      this.condition,
      this.onClick})
      : super(key: key);

  @override
  _UploadUIState createState() => _UploadUIState();
}

class _UploadUIState extends State<UploadUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadiusDirectional.circular(15)),
      child: widget.condition!
          ? DottedBorder(
              color: SpotmiesTheme.onBackground,
              radius: Radius.circular(30),
              borderType: BorderType.RRect,
              child: Container(
                height: height(context) * 0.2,
                width: width(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print("ontap >>>>>>>");
                        return widget.onClick!();
                      },
                      child: Icon(
                        Icons.cloud_upload,
                        size: width(context) * 0.2,
                        color: Colors.teal,
                      ),
                    ),
                    TextWid(
                      text: widget.imageType == 'front'
                          ? 'Aadhar Front'
                          : widget.imageType == 'back'
                              ? 'Aadhar Back'
                              : 'College Identity',
                      size: width(context) * 0.045,
                    )
                  ],
                ),
              ))
          : Stack(
              children: [
                Container(
                  height: height(context) * 0.2,
                  width: width(context) * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage((widget.imageType == 'front'
                              ? widget.stepperController?.adharfront!
                              : widget.imageType == 'back'
                                  ? widget.stepperController?.adharback!
                                  : widget.stepperController?.clgId!)!))),
                ),
                Positioned(
                    bottom: 0,
                    right: width(context) * 0.1,
                    child: CircleAvatar(
                      backgroundColor: SpotmiesTheme.shadow,
                      radius: width(context) * 0.05,
                      child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () async {
                            return widget.onClick!();
                            // if (widget.imageType == 'front')
                            //   await widget.stepperController?.adharfrontpage();
                            // if (widget.imageType == 'back')
                            //   await widget.stepperController?.adharBack();
                            // if (widget.imageType == 'clgId')
                            //   await widget.stepperController?.clgIdImage();
                            // setState(() {});
                          },
                          icon: Icon(
                            Icons.change_circle,
                            color: SpotmiesTheme.secondaryVariant,
                            size: width(context) * 0.055,
                          )),
                    ))
              ],
            ),
    );
  }

  // onTap() async {
  //   if (widget.imageType == 'front')
  //     await widget.stepperController?.adharfrontpage();
  //   if (widget.imageType == 'back') await widget.stepperController?.adharBack();
  //   if (widget.imageType == 'clgId')
  //     await widget.stepperController?.clgIdImage();
  // }
}

// uploadUI(
//   imageType,
//   StepperController stepperController,
//   bool condition,
//   BuildContext context,
// ) {
//   void onTap() {
//     if (imageType == 'front') stepperController.adharfrontpage();
//     if (imageType == 'back') stepperController.adharBack();
//     if (imageType == 'clgId') stepperController.clgIdImage();
//   }

//   return Container(
//     padding: const EdgeInsets.all(8.0),
//     decoration:
//         BoxDecoration(borderRadius: BorderRadiusDirectional.circular(15)),
//     child: condition
//         ? DottedBorder(
//             radius: Radius.circular(30),
//             borderType: BorderType.RRect,
//             child: Container(
//               height: height(context) * 0.2,
//               width: width(context),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: onTap,
//                     child: Icon(
//                       Icons.cloud_upload,
//                       size: width(context) * 0.2,
//                       color: Colors.teal,
//                     ),
//                   ),
//                   TextWid(
//                     text: imageType == 'front'
//                         ? 'Aadhar Front'
//                         : imageType == 'back'
//                             ? 'Aadhar Back'
//                             : 'College Identity',
//                     size: width(context) * 0.045,
//                   )
//                 ],
//               ),
//             ))
//         : Stack(
//             children: [
//               Container(
//                 height: height(context) * 0.2,
//                 width: width(context) * 0.70,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     shape: BoxShape.rectangle,
//                     image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: FileImage(imageType == 'front'
//                             ? stepperController.adharfront!
//                             : imageType == 'back'
//                                 ? stepperController.adharback!
//                                 : stepperController.clgId!))),
//               ),
//               Positioned(
//                   bottom: 0,
//                   right: width(context) * 0.1,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.grey[300],
//                     radius: width(context) * 0.05,
//                     child: IconButton(
//                         padding: EdgeInsets.all(0.0),
//                         onPressed: onTap,
//                         icon: Icon(
//                           Icons.change_circle,
//                           color: Colors.grey[900],
//                           size: width(context) * 0.055,
//                         )),
//                   ))
//             ],
//           ),
//   );
// }
// Widget step3UI(BuildContext context, StepperController stepperController,
//     double _hight, double _width, String type,
//     {PartnerDetailsProvider? provider}) {
//   return Container(
//     height: _hight * 0.75,
//     child: Form(
//       key: stepperController.step3Formkey,
//       child: ListView(
//         children: [
//           Container(
//             padding: EdgeInsets.only(
//                 left: _width * 0.03,
//                 right: _width * 0.00,
//                 bottom: _width * 0.03),
//             height: _hight * 0.08,
//             width: _width * 0.8,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: provider!.getServiceListFromServer,
//                   child: TextWid(
//                     text: 'Business type:',
//                     color: Colors.grey[900]!,
//                     size: _width * 0.05,
//                     weight: FontWeight.w600,
//                   ),
//                 ),
//                 Flexible(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                         left: _width * 0.03, right: _width * 0.03),
//                     decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey[300]!,
//                               blurRadius: 3,
//                               spreadRadius: 1)
//                         ],
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15)),
//                     child: DropdownButton(
//                       underline: SizedBox(),
//                       value: stepperController.dropDownValue,
//                       icon: Icon(
//                         Icons.arrow_drop_down_circle,
//                         size: _width * 0.06,
//                         color: Colors.indigo[900],
//                       ),
//                       items: provider.getServiceList.map((location) {
//                         return DropdownMenuItem(
//                           child: TextWid(
//                             text: location['nameOfService'],
//                             color: Colors.grey[900]!,
//                             size: _width * 0.04,
//                             weight: FontWeight.w500,
//                           ),
//                           value: location['serviceId'],
//                         );
//                       }).toList(),
//                       onChanged: (newVal) {
//                         log(newVal.toString());
//                         stepperController.dropDownValue = newVal as int;
//                         stepperController.refresh();
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           registrationField(
//               context,
//               stepperController,
//               type != 'student' ? 'Business Name' : 'College Name',
//               'Enter Valid Business Name',
//               type == "student"
//                   ? stepperController.collegeNameTf
//                   : stepperController.businessNameTf,
//               Icons.business,
//               'text',
//               TextInputType.name,
//               30),
//           registrationField(
//               context,
//               stepperController,
//               'Years of experience',
//               'Enter Valid Experience',
//               stepperController.experienceTf,
//               Icons.work,
//               'number',
//               TextInputType.number,
//               2),
//           uploadUI(_hight, _width, 'front', stepperController,
//               stepperController.adharfront == null),
//           uploadUI(_hight, _width, 'back', stepperController,
//               stepperController.adharback == null),
//           // type == "student"
//           //     ? uploadUI(_hight, _width, 'clgId', stepperController,
//           //         stepperController.clgId == null)
//           //     : Container(),
//         ],
//       ),
//     ),
//   );
// }
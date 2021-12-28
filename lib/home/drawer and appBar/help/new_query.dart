// import 'package:flutter/material.dart';
// import 'package:spotmies_partner/controllers/faq_controller.dart';
// import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
// import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
// import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';
// import 'package:spotmies_partner/utilities/app_config.dart';

// newQuery(BuildContext context, pDID, FAQController faqController) {
//   TextEditingController queryControl = TextEditingController();
//   var queryForm = GlobalKey<FormState>();

//   return showModalBottomSheet(
//       context: context,
//       elevation: 22,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       builder: (BuildContext context) {
//         // if (faqController.loader == true)
//         //   return Center(
//         //     child: CircularProgressIndicator(),
//         //   );
//         return Container(
//           height: height(context) * 0.47,
//           margin: EdgeInsets.only(
//               left: 10,
//               right: 10,
//               top: 10,
//               bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Form(
//             key: queryForm,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextWid(
//                     text: 'Rise a new query',
//                     size: width(context) * 0.06,
//                     weight: FontWeight.w600,
//                     flow: TextOverflow.visible,
//                     align: TextAlign.center),
//                 TextFieldWidget(
//                   label: "Ask Question",
//                   hint: 'Ask Question',
//                   enableBorderColor: Colors.grey,
//                   focusBorderColor: Colors.indigo[900],
//                   enableBorderRadius: 15,
//                   controller: queryControl,
//                   isRequired: true,
//                   focusBorderRadius: 15,
//                   errorBorderRadius: 15,
//                   focusErrorRadius: 15,
//                   autofocus: true,
//                   maxLength: 500,
//                   validateMsg: 'Enter Valid Email address',
//                   maxLines: 9,
//                   // postIcon: Icon(Icons.change_circle),
//                   postIconColor: Colors.indigo[900],
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(5),
//                   child: ElevatedButtonWidget(
//                     bgColor: Colors.indigo[900],
//                     minWidth: width(context),
//                     height: height(context) * 0.06,
//                     textColor: Colors.white,
//                     buttonName: 'Submit',
//                     textSize: width(context) * 0.05,
//                     textStyle: FontWeight.w600,
//                     borderRadius: 10.0,
//                     borderSideColor: Colors.indigo[50],
//                     onClick: () {
//                       if (queryForm.currentState.validate()) {
//                         faqController.submitQuery(queryControl.text, pDID);
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }

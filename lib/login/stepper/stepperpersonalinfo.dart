 
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/login/stepper/step1UI.dart';
import 'package:spotmies_partner/login/stepper/step2UI.dart';
import 'package:spotmies_partner/login/stepper/step3UI.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progress_waiter.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class StepperPersonalInfo extends StatefulWidget {
  final String? phone;
  final String? type;
  final Map<dynamic, dynamic>? coordinates;
  StepperPersonalInfo(
      {required this.phone, required this.type, this.coordinates});
  @override
  _StepperPersonalInfoState createState() => _StepperPersonalInfoState();
}

class _StepperPersonalInfoState extends StateMVC<StepperPersonalInfo> {
  StepperController? _stepperController = StepperController();
  PartnerDetailsProvider? partnerProvider;
  // _StepperPersonalInfoState() : super(StepperController()) {
  //   this._stepperController = controller;
  // }

  void initState() {
    super.initState();
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    _stepperController!.pickedDate = DateTime.now();
    _stepperController!.pickedTime = TimeOfDay.now();

    _stepperController!.workLocation =
        widget.coordinates as Map<String, double>;
    _stepperController!.verifiedNumber = widget.phone.toString();
    // print("76 ${FirebaseAuth.instance.currentUser.uid}");
    // partnerProvider.getServiceListFromServer();
    partnerProvider!.setCurrentConstants("welcome");
  }

  @override
  Widget build(BuildContext context) {
    // print(_stepperController.value);
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    // if (_stepperController.isProcess == true) return onPending(_hight, _width);
    // if (_stepperController.isFail == true)
    //   return onFail(_hight, _width, context, _stepperController);
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      // if (data.registrationInProgress)
      //   return onPending(_hight, _width, scafffoldKey: _scaffoldKey);
      return Stack(
        children: [
          Scaffold(
            key: _stepperController!.scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: TextWid(
                text: _stepperController!
                    .pagename(_stepperController!.currentStep),
                size: _width * 0.051,
                weight: FontWeight.w600,
                lSpace: 1.0,
              ),
              backgroundColor: Colors.grey[50],
              elevation: 0,
            ),
            backgroundColor: Colors.grey[50],
            body: Theme(
              data: ThemeData(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: Colors.indigo[900]),
              ),
              child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: _stepperController!.currentStep,
                  onStepTapped: (int step) =>
                      setState(() => _stepperController!.currentStep = step),
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButtonWidget(
                            height: _hight * 0.05,
                            minWidth: _width * 0.35,
                            bgColor: Colors.indigo[900]!,
                            buttonName: 'Back',
                            textColor: Colors.white,
                            textSize: _width * 0.04,
                            allRadius: true,
                            leadingIcon: Icon(Icons.navigate_before,
                                size: _width * 0.04),
                            borderRadius: 10.0,
                            onClick: () {
                              controls.onStepCancel!();
                            },
                          ),
                          ElevatedButtonWidget(
                            height: _hight * 0.05,
                            minWidth: _width * 0.35,
                            bgColor: Colors.indigo[900]!,
                            allRadius: true,
                            buttonName: _stepperController!.currentStep == 2
                                ? 'Finish'
                                : 'Next',
                            textColor: Colors.white,
                            textSize: _width * 0.04,
                            trailingIcon:
                                Icon(Icons.navigate_next, size: _width * 0.04),
                            borderRadius: 10.0,
                            onClick: () {
                              switch (_stepperController?.currentStep) {
                                case 0:
                                  controls.onStepContinue!();
                                  break;
                                case 1:
                                  if (_stepperController?.profilepics == null)
                                    return snackbar(context,
                                        'please add your profile picture');
                                  if ((_stepperController?.localLang?.length)! <
                                      1)
                                    return snackbar(
                                        context, "select your known language");
                                  controls.onStepContinue!();
                                  break;
                                case 2:
                                  _stepperController?.step3(
                                      context,
                                      widget.type!,
                                      widget.phone!,
                                      widget.coordinates!);
                                  break;
                                default:
                                  snackbar(context, "notthing");
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  onStepContinue: _stepperController!.currentStep == 0
                      ? () => setState(() {
                            _stepperController?.step1(
                              context,
                            );
                          })
                      : _stepperController!.currentStep == 1
                          ? () => setState(() {
                                _stepperController?.step2(context);
                              })
                          : _stepperController!.currentStep == 2
                              ? () => setState(() {
                                    _stepperController?.step3(
                                        context,
                                        widget.type!,
                                        widget.phone!,
                                        widget.coordinates!);
                                  })
                              : null,
                  onStepCancel: _stepperController!.currentStep > 0
                      ? () =>
                          setState(() => _stepperController?.currentStep -= 1)
                      : null,
                  steps: <Step>[
                    Step(
                      title: TextWid(
                        text: 'Step 1',
                        size: _width * 0.045,
                        weight: FontWeight.w700,
                      ),
                      subtitle: TextWid(
                        text: 'Terms',
                        size: _width * 0.025,
                      ),
                      content: Container(
                          child: Step1(
                              scrollController:
                                  _stepperController!.scrollController!,
                              type: widget.type!,
                              termsAndConditions: partnerProvider!
                                      .getValue("terms_and_conditions") ??
                                  _stepperController!.offlineTermsAndConditions,
                              stepperController: _stepperController)),
                      isActive: _stepperController!.currentStep >= 0,
                      state: _stepperController!.currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: TextWid(
                        text: 'Step 2',
                        size: _width * 0.045,
                        weight: _stepperController!.currentStep > 0
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      subtitle: TextWid(
                        text: 'Personal Details',
                        size: _width * 0.025,
                      ),
                      content: Container(
                          child: Step2(
                              type: widget.type!,
                              stepperController: _stepperController)),
                      isActive: _stepperController!.currentStep >= 1,
                      state: _stepperController!.currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: TextWid(
                        text: 'Step 3',
                        size: _width * 0.045,
                        weight: _stepperController!.currentStep > 1
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      subtitle: TextWid(
                        text: 'Business Details',
                        size: _width * 0.025,
                      ),
                      content: Step3(
                        type: widget.type!,
                        stepperController: _stepperController,
                        provider: partnerProvider,
                      ),
                      // step3UI(context, _stepperController!, _hight,
                      //     _width, widget.type!,
                      //     provider: partnerProvider),
                      isActive: _stepperController!.currentStep >= 2,
                      state: _stepperController!.currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ]),
            ),
          ),
          ProgressWaiter(
              contextt: context, loaderState: data.registrationInProgress)
        ],
      );
    });
  }
}

class Register {
  Docs? docs;

  Register({this.docs});

  Register.fromJson(Map<String, dynamic> json) {
    docs = json['docs'] != null ? new Docs.fromJson(json['docs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docs != null) {
      data['docs'] = this.docs!.toJson();
    }
    return data;
  }
}

class Docs {
  String? adharF;
  String? adharB;

  Docs({this.adharF, this.adharB});

  Docs.fromJson(Map<String, dynamic> json) {
    adharF = json['adharF'];
    adharB = json['adharB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adharF'] = this.adharF;
    data['adharB'] = this.adharB;
    return data;
  }
}






  // ElevatedButtonWidget(
  //                     height: _hight * 0.05,
  //                     minWidth: _width * 0.35,
  //                     bgColor: Colors.indigo[900],
  //                     buttonName: 'Back',
  //                     textColor: Colors.white,
  //                     textSize: _width * 0.04,
  //                     leadingIcon:
  //                         Icon(Icons.navigate_before, size: _width * 0.04),
  //                     borderRadius: 10.0,
  //                     onClick: () {
  //                       onStepCancel();
  //                     },
  //                   ),
  //                   ElevatedButtonWidget(
  //                     height: _hight * 0.05,
  //                     minWidth: _width * 0.35,
  //                     bgColor: Colors.indigo[900],
  //                     buttonName: _stepperController.currentStep == 2
  //                         ? 'Finish'
  //                         : 'Next',
  //                     textColor: Colors.white,
  //                     textSize: _width * 0.04,
  //                     trailingIcon:
  //                         Icon(Icons.navigate_next, size: _width * 0.04),
  //                     borderRadius: 10.0,
  //                     onClick: () {
  //                       _stepperController.currentStep == 2
  //                           ? _stepperController.step4(context)
  //                           : onStepContinue();
  //                     },
  //                   ),




  //                   Step(
  //               title: TextWid(
  //                 text: 'Step 1',
  //                 size: _width * 0.045,
  //                 weight: FontWeight.w700,
  //               ),
  //               subtitle: TextWid(
  //                 text: 'Terms',
  //                 size: _width * 0.025,
  //               ),
  //               content: Container(
  //                   child: step1UI(
  //                       context,
  //                       _width,
  //                       _hight,
  //                       _stepperController.scrollController,
  //                       _stepperController)),
  //               isActive: _stepperController.currentStep >= 0,
  //               state: _stepperController.currentStep >= 0
  //                   ? StepState.complete
  //                   : StepState.disabled,
  //             ),
  //             Step(
  //               title: TextWid(
  //                 text: 'Step 2',
  //                 size: _width * 0.045,
  //                 weight: _stepperController.currentStep > 0
  //                     ? FontWeight.w700
  //                     : FontWeight.w500,
  //               ),
  //               subtitle: TextWid(
  //                 text: 'Business Details',
  //                 size: _width * 0.025,
  //               ),
  //               content: Container(
  //                   child:
  //                       // step2UI(context, _stepperController, _hight, _width)
  //                       step2(context, _stepperController, _hight, _width)),
  //               isActive: _stepperController.currentStep >= 1,
  //               state: _stepperController.currentStep >= 1
  //                   ? StepState.complete
  //                   : StepState.disabled,
  //             ),
  //             Step(
  //               title: TextWid(
  //                 text: 'Step 3',
  //                 size: _width * 0.045,
  //                 weight: _stepperController.currentStep > 1
  //                     ? FontWeight.w700
  //                     : FontWeight.w500,
  //               ),
  //               subtitle: TextWid(
  //                 text: 'Business Details',
  //                 size: _width * 0.025,
  //               ),
  //               content: step3UI(context, _stepperController),
  //               isActive: _stepperController.currentStep >= 2,
  //               state: _stepperController.currentStep >= 2
  //                   ? StepState.complete
  //                   : StepState.disabled,
  //             ),
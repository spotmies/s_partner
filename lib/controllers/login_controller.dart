import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/login/accountType.dart';
import 'package:spotmies_partner/login/onboard.dart';
import 'package:spotmies_partner/login/otp.dart';
import 'package:spotmies_partner/maps/onLine_placesSearch.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/timer_provider.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class LoginPageController extends ControllerMVC {
  // TimeProvider timerProvider;
  // PartnerDetailsProvider partnerProvider;

  GlobalKey scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var formkey1 = GlobalKey<FormState>();

  TextEditingController loginnum = TextEditingController();

  String _verificationCode = "";
  // @override
  // void initState() {
  //   timerProvider = Provider.of<TimeProvider>(context, listen: false);
  //   partnerProvider =
  //       Provider.of<PartnerDetailsProvider>(context, listen: false);

  //   super.initState();
  // }

  dataToOTP(
    BuildContext context,
    TimeProvider timerProvider,
    PartnerDetailsProvider partnerProvider,
  ) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      timerProvider.setPhNumber(loginnum.text.toString());

      verifyPhone(context, timerProvider, partnerProvider);
    }
  }

  verifyPhone(BuildContext context, TimeProvider timerProvider,
      PartnerDetailsProvider partnerProvider,
      {navigate = true}) async {
    timerProvider.resetTimer();
    timerProvider.setLoader(true, loadingValue: "Sending OTP .....");
    log("phnum ${timerProvider.phNumber}");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91${timerProvider.phNumber}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                print("user already login");
                // checkUserRegistered(value.user.uid);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OnlinePlaceSearch()),
                //     (route) => false);
                timerProvider.setLoader(true,
                    loadingValue: "Checking OTP .....");
                String resp = await checkPartnerRegistered(value.user!.uid);
                partnerProvider.setCurrentPid(value.user!.uid);

                timerProvider.setLoader(false);
                saveNumber(timerProvider.phNumber);
                if (resp == "false") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnlinePlaceSearch(
                              heading: "Select your business location",
                              onSave: (cords, fullAddress) {
                                log("onsave $cords $fullAddress");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountType(
                                            coordinates: cords,
                                            phoneNumber: timerProvider.phNumber,
                                          )),
                                  // (route) => false
                                );
                              })),
                      (route) => false);
                } else if (resp == "true") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => NavBar()),
                      (route) => false);
                } else {
                  snackbar(
                      context, "Something went wrong please try again later");
                }
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            log(e.message.toString());
            snackbar(context, e.message.toString());
            timerProvider.setLoader(false);
          },
          codeSent: (String? verficationID, int? resendToken) {
            timerProvider.setLoader(false);
            snackbar(context, "OTP sent successfully.");

            _verificationCode = verficationID!;
            timerProvider.setVerificationCode(verficationID);
            log("verfication code $_verificationCode");

            if (navigate) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OTPScreen(loginnum.text, verficationID)));
            }
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            _verificationCode = verificationID;
            timerProvider.setVerificationCode(verificationID);
            log("verfication code $_verificationCode");
          },
          timeout: Duration(seconds: 85));
    } catch (e) {
      log(e.toString());
      snackbar(context, e.toString());
      timerProvider.setLoader(false);
    }
  }

  loginUserWithOtp(
      otpValue,
      BuildContext context,
      PartnerDetailsProvider partnerProvider,
      TimeProvider timerProvider) async {
    log("verfication code ${timerProvider.verificationCode}");
    log(otpValue.toString());
    timerProvider.setLoader(true);
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: timerProvider.verificationCode,
              smsCode: otpValue))
          .then((value) async {
        if (value.user != null) {
          log("${value.user}");
          // log("$value");
          log("114 ${timerProvider.phNumber}");
          timerProvider.setPhoneNumber(timerProvider.phNumber.toString());
          // print("user already login");
          String resp = await checkPartnerRegistered(value.user!.uid);
          timerProvider.setLoader(false);
          partnerProvider.setCurrentPid(value.user!.uid);
          saveNumber(timerProvider.phNumber);
          if (resp == "false") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OnlinePlaceSearch(onSave: (cords, fullAddress) {
                          log("onsave $cords $fullAddress");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountType(
                                      coordinates: cords,
                                      phoneNumber: timerProvider.phNumber,
                                    )),
                            // (route) => false
                          );
                        })),
                (route) => false);
          } else if (resp == "true") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => NavBar()),
                (route) => false);
          } else {
            snackbar(context, "Something went wrong please try again later");
          }
        } else {
          timerProvider.setLoader(false);
          snackbar(context, "Something went wrong");
        }
      });
    } catch (e) {
      FocusScope.of(context).unfocus();
      log(e.toString());
      timerProvider.setLoader(false);
      snackbar(context, "Invalid OTP");
    }
  }

  splashScreenNavigation(
      BuildContext context, PartnerDetailsProvider partnerProvider) async {
    if (FirebaseAuth.instance.currentUser != null) {
      partnerProvider.setCurrentPid(FirebaseAuth.instance.currentUser!.uid);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
      log(FirebaseAuth.instance.currentUser!.uid.toString());
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
          (route) => false);
    }
  }

  // StreamBuilder(
  //       stream: Connectivity().onConnectivityChanged,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<ConnectivityResult>? snapshot) {
  //         if (snapshot != null &&
  //             snapshot.hasData &&
  //             snapshot.data != ConnectivityResult.none) {
  //           return nav(partnerProvider, context);
  //         } else {
  //           return NoInternet();
  //         }
  //       });

  // getConstants(BuildContext context,{bool alwaysHit = false}) async {
  //   if (alwaysHit == false) {
  //     dynamic constantsFromSf = await getAppConstants();
  //     if (constantsFromSf != null) {
  //       partnerProvider.setAllConstants(constantsFromSf);

  //       log("constants already in sf");
  //       return;
  //     }
  //   }

  //   dynamic appConstants = await constantsAPI();
  //   if (appConstants != null) {
  //     partnerProvider.setAllConstants(appConstants);
  //     snackbar(context, "new settings imported");
  //   }
  //   return;
  // }

  // getServiceList({bool alwaysHit = false}) async {
  //   partnerProvider.fetchServiceList(alwaysHit: alwaysHit);
  // }
}

checkPartnerRegistered(pId) async {
  dynamic deviceToken = await FirebaseMessaging.instance.getToken();
  Map<String, String> obj = {
    "lastLogin": DateTime.now().millisecondsSinceEpoch.toString(),
    "partnerDeviceToken": deviceToken?.toString() ?? "",
    "isActive": true.toString(),
    "pId": pId.toString()
  };
  dynamic response = await Server().postMethod(API.loginApi, obj);
  if (response.statusCode == 200 || response.statusCode == 204)
    return "true";
  else if (response.statusCode == 404)
    return "false";
  else
    return "server_error";
}

logoutUser() async {
  Map<String, String> body = {"pId": pId};
  await Server().postMethod(API.logoutApi, body);
  return;
}

constantsAPI({String which = "constants"}) async {
  dynamic response = await Server().getMethod(API.cloudConstants);
  if (response.statusCode == 200) {
    dynamic appConstants = jsonDecode(response?.body);
    log(appConstants.toString());
    setAppConstants(appConstants);
    dynamic currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      log("confirming all costanst downloaded");

      /* -------------- CONFIRM ALL CONSTANTS AND SETTINGS DOWNLOADED ------------- */
      Map<String, String> body = {"appConfig": "false"};
      Server()
          .editMethod(API.partnerDetails + currentUser.uid.toString(), body);
    }
    return appConstants;
  } else {
    log("something went wrong status code ${response.statusCode}");
    return null;
  }
}

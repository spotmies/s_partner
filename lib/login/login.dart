import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/login_controller.dart';
import 'package:spotmies_partner/providers/timer_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {
  LoginPageController _loginPageController;
  TimeProvider timerProvider;
  _LoginScreenState() : super(LoginPageController()) {
    this._loginPageController = controller;
  }

  @override
  void initState() {
    super.initState();
    timerProvider = Provider.of<TimeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Consumer<TimeProvider>(builder: (context, data, child) {
      return Scaffold(
          key: _loginPageController.scaffoldkey,
          backgroundColor: Colors.white,
          body: ListView(children: [
            Form(
              key: _loginPageController.formkey,
              child: Container(
                // height: _hight * 1.06,
                width: _width * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: _width * 0.07, bottom: _width * 0.07),
                              child: Row(
                                children: [
                                  Container(
                                      height: _hight * 0.05,
                                      margin: EdgeInsets.only(
                                          left: _width * 0.05,
                                          right: _width * 0.03),
                                      child: Image.asset('assets/logo.png')),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWid(
                                        text: 'SPOTMIES PARTNER',
                                        weight: FontWeight.w600,
                                        size: _width * 0.06,
                                        color: Colors.indigo[900],
                                        lSpace: 1.0,
                                      ),
                                      TextWid(
                                          text: 'BECOME A BOSE TO YOUR WORLD',
                                          weight: FontWeight.w600,
                                          size: _width * 0.019,
                                          color: Colors.grey[900],
                                          lSpace: 4.0),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              height: _hight * 0.35,
                              child: SvgPicture.asset('assets/login.svg')),
                          SizedBox(
                            height: _hight * 0.02,
                          ),
                          Container(
                            width: _width,
                            margin: EdgeInsets.only(
                                left: _width * 0.05, right: _width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWid(
                                  text: 'LOGIN',
                                  weight: FontWeight.w600,
                                  size: _width * 0.06,
                                  color: Colors.indigo[900],
                                  lSpace: 1.0,
                                ),
                                SizedBox(
                                  height: _hight * 0.01,
                                ),
                                TextWid(
                                  text: 'Please login to continue',
                                  weight: FontWeight.w600,
                                  size: _width * 0.035,
                                  color: Colors.grey[500],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _hight * 0.05,
                          ),
                          Container(
                            height: _hight * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(
                                      minHeight: _hight * 0.10,
                                      maxHeight: _hight * 0.15),
                                  margin: EdgeInsets.only(
                                      top: 0, right: 5, left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 5, left: 5),
                                    width: _width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextFormField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      // onSaved: (item) => _loginPageController
                                      //     .loginModel.loginnum,
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        suffixIcon: Icon(
                                          Icons.phone_android,
                                          color: Colors.indigo[900],
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.white)),
                                        hintStyle: fonts(_width * 0.045,
                                            FontWeight.w600, Colors.grey[400]),
                                        hintText: 'Phone number',
                                        prefix: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Text('+91'),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.length != 10) {
                                          return 'Please Enter Valid Mobile Number';
                                        }
                                        return null;
                                      },
                                      maxLength: 10,
                                      keyboardAppearance: Brightness.dark,
                                      buildCounter: (BuildContext context,
                                              {int currentLength,
                                              int maxLength,
                                              bool isFocused}) =>
                                          null,
                                      keyboardType: TextInputType.number,
                                      controller: _loginPageController.loginnum,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                    Container(
                        margin: EdgeInsets.all(10),
                        // width: _width * 0.6,
                        // height: _hight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // child: ElevatedButtonWidget(
                        //   height: _hight * 0.06,
                        //   // minWidth: _width * 1,
                        // ),
                        child: FloatingActionButton(
                            backgroundColor: Colors.indigo[900],
                            child: data.loader
                                ? CircularProgressIndicator(color: Colors.white)
                                : Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              // _loginPageController.dataToOTP();
                              if (data.loader) return;
                              _loginPageController.dataToOTP();
                            })

                        // child: ElevatedButton(
                        //   style: ButtonStyle(
                        //       backgroundColor:
                        //           MaterialStateProperty.all(Colors.blue[900])),
                        //   onPressed: () {
                        //     _loginPageController.dataToOTP();
                        //   },
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'Verify',
                        //         style: TextStyle(color: Colors.white, fontSize: 18),
                        //       ),
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Icon(
                        //         Icons.verified_user,
                        //         color: Colors.lightGreen,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        ),
                  ],
                ),
              ),
            ),
          ]));
    });
  }
}

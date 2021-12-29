import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/controllers/incomingOrders_controller.dart';
import 'package:spotmies_partner/orders/post_overview.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';

class Online extends StatefulWidget {
  Online(pr);

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends StateMVC<Online> {
  IncomingOrdersController _incomingOrdersController;
  PartnerDetailsProvider partnerProvider;
  Map<dynamic, dynamic> partnerProfile;
  _OnlineState() : super(IncomingOrdersController()) {
    this._incomingOrdersController = controller;
  }

  @override
  void initState() {
    _incomingOrdersController.incomingOrdersProvider =
        Provider.of<IncomingOrdersProvider>(context, listen: false);
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);

    // _incomingOrdersController.incomingOrdersProvider.localOrdersGet();
    // partnerProvider.addListener(() {
    //      if(partnerProvider.reloadIncomingOrders == true){
    //   _incomingOrdersController.incomingOrders(notify: false);
    // }
    // });

    super.initState();
    _incomingOrdersController.pickedDate = DateTime.now();
    _incomingOrdersController.pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _incomingOrdersController.incomingscaffoldkey,
        backgroundColor: Colors.grey[50],
        body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
          List<dynamic> ld = data.getIncomingOrder;
          List<dynamic> o = List.from(ld.reversed);
          partnerProfile = data.getProfileDetails;
          // if (data.reloadIncomingOrders == true)
          //   _incomingOrdersController.incomingOrders(notify: false);
          return Stack(
            children: [
              Container(
                  child: RefreshIndicator(
                onRefresh: _incomingOrdersController.incomingOrders,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: o.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (BuildContext ctxt, int index) {
                      var u = o[index]['uDetails'];
                      List<String> images = List.from(o[index]['media']);

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostOverView(
                                onBottomSheet: () {
                                  bidSendingBottomSheet(
                                      _hight,
                                      _width,
                                      o[index]["uId"],
                                      o[index],
                                      o[index]["ordId"],
                                      o[index]["pId"],
                                      u['_id'],
                                      partnerProfile['_id'],
                                      from: "outside");
                                },
                                orderId: o[index]['ordId'].toString(),
                                from: "incomingOrders",
                                onclick: (orderData, pDetailsId, responseType) {
                                  print("onclick>>>>>>>");
                                  _incomingOrdersController.respondToOrder(
                                      orderData, pDetailsId, responseType);
                                }),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ],
                            //  boxShadow: kElevationToShadow[1],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15, right: 10),
                                height: _hight * 0.11,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    boxShadow: kElevationToShadow[0]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWid(
                                          text: partnerProvider
                                              .getServiceNameById(
                                                  o[index]['job']),
                                          size: _width * 0.04,
                                          color: Colors.grey[900],
                                          weight: FontWeight.w600,
                                        ),
                                        Row(
                                          children: [
                                            o[index]['orderState'] > 6
                                                ? takeOverWid(_width)
                                                : Container(),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.grey[900],
                                                ),
                                                onPressed: () {
                                                  onlineOrdersButtomMenu(
                                                      o[index]['uId'],
                                                      o[index],
                                                      o[index]['ordId'],
                                                      o[index]['pId'],
                                                      u['_id'],
                                                      partnerProfile['_id'],
                                                      _hight,
                                                      _width);
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // width: _width * 0.45,
                                            // color: Colors.red,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  color: Colors.grey[900],
                                                  size: _width * 0.045,
                                                ),
                                                SizedBox(
                                                  width: _width * 0.01,
                                                ),
                                                TextWid(
                                                  text: getDate(
                                                      o[index]['schedule']),
                                                  color: Colors.grey[900],
                                                  size: _width * 0.04,
                                                ),
                                                TextWid(
                                                  text: '-' +
                                                      getTime(
                                                          o[index]['schedule']),
                                                  color: Colors.grey[900],
                                                  size: _width * 0.04,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: _width * 0.35,
                                          //  color: Colors.amber,
                                          alignment: Alignment.centerRight,
                                          child: o[index]['money'] != null
                                              ? TextWid(
                                                  text: 'Rs:  ' +
                                                      o[index]['money']
                                                          .toString() +
                                                      ' /-',
                                                  color: Colors.grey[900],
                                                  size: _width * 0.04,
                                                )
                                              : TextWid(
                                                  text: "Rs: Not mentioned"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.all(10),
                                height: _hight * 0.21,
                                // width: _width * 0.88,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],

                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  // boxShadow: kElevationToShadow[0]
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: _hight * 0.11,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                                // height: _hight * 0.15,
                                                width: _width * 0.13,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: images == null
                                                      ? NetworkImage(
                                                          images.first)
                                                      : Icon(
                                                          Icons
                                                              .home_repair_service_outlined,
                                                          color:
                                                              Colors.grey[900],
                                                        ),
                                                )),
                                          ),
                                          Container(
                                            // color: Colors.amber,
                                            width: _width * 0.53,
                                            child: TextWid(
                                              text: toBeginningOfSentenceCase(
                                                o[index]['problem'].toString(),
                                              ),
                                              align: TextAlign.center,
                                              flow: TextOverflow.visible,
                                              size: _width * 0.04,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.info,
                                                color: Colors.grey[400],
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _hight * 0.015,
                                    ),

                                    // o[index]['orderState'] < 7
                                    //     ?
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButtonWidget(
                                              buttonName: 'Reject',
                                              height: _hight * 0.05,
                                              minWidth: _width * 0.3,
                                              bgColor: Colors.grey[200],
                                              textColor: Colors.grey[900],
                                              textSize: _width * 0.04,
                                              leadingIcon: Icon(
                                                Icons.close,
                                                color: Colors.grey[900],
                                                size: _width * 0.04,
                                              ),
                                              borderRadius: 15.0,
                                              borderSideColor: Colors.grey[50],
                                              onClick: () {
                                                _incomingOrdersController
                                                    .respondToOrder(
                                                        o[index],
                                                        partnerProfile['_id'],
                                                        "reject");
                                              },
                                            ),
                                            ElevatedButtonWidget(
                                              buttonName: 'Accept',
                                              height: _hight * 0.05,
                                              minWidth: _width * 0.55,
                                              bgColor: Colors.grey[900],
                                              textColor: Colors.white,
                                              textSize: _width * 0.04,
                                              trailingIcon: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: _width * 0.04,
                                              ),
                                              borderRadius: 15.0,
                                              borderSideColor: Colors.grey[100],
                                              onClick: () async {
                                                _incomingOrdersController
                                                    .respondToOrder(
                                                        o[index],
                                                        partnerProfile['_id'],
                                                        "accept");
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    // : TextWid(
                                    //     text: 'Order Accepted',
                                    //     size: _width * 0.05,
                                    //     weight: FontWeight.w600,
                                    //   )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _hight * 0.01,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )),
              Visibility(
                visible: data.inComingLoader,
                child: Positioned.fill(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Center(child: CircularProgressIndicator()),
                  // Container(color: Colors.grey[100].withOpacity(0))
                )),
              ),
            ],
          );
          // });
        }));
  }

  Container takeOverWid(double _width) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.indigo[200]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey[900],
            size: _width * 0.04,
          ),
          SizedBox(
            width: _width * 0.01,
          ),
          TextWid(
              text: "Take over by Someone else",
              color: Colors.grey[900],
              weight: FontWeight.w600,
              size: _width * 0.03)
        ],
      ),
    );
  }

  onlineOrdersButtomMenu(uid, ordDetails, ordid, pid, uDetails, pDetails,
      double hight, double width) {
    showModalBottomSheet(
        context: context,
        elevation: 22,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: hight * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: width * 0.06,
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    TextWid(
                      text: 'Close',
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PostOverView(
                              onBottomSheet: () {
                                bidSendingBottomSheet(
                                    hight,
                                    width,
                                    uid,
                                    ordDetails,
                                    ordid,
                                    pid,
                                    ordDetails['uDetails']['_id'],
                                    partnerProfile['_id'],
                                    from: "outside");
                              },
                              orderId: ordid.toString(),
                              from: "incomingOrders",
                              onclick: (orderData, pDetailsId, responseType) {
                                print("onclick>>>>>>>");
                                _incomingOrdersController.respondToOrder(
                                    orderData, pDetailsId, responseType);
                              }),
                        ));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: width * 0.06,
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    TextWid(
                      text: 'View',
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        bidSendingBottomSheet(
                          hight,
                          width,
                          uid,
                          ordDetails,
                          ordid,
                          pid,
                          uDetails,
                          pDetails,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: width * 0.06,
                        child: Icon(
                          Icons.receipt,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    TextWid(
                      text: 'Bid',
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  bidSendingBottomSheet(double hight, double width, uid, ordDetails, ordid, pid,
      uDetails, pDetails,
      {from = "inside"}) {
    return showModalBottomSheet(
        context: context,
        elevation: 22,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: hight * 0.35,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStatee) {
              return Form(
                key: _incomingOrdersController.updateFormKey,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: TextWid(
                        text: 'Create Bid',
                        size: width * 0.055,
                        weight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _incomingOrdersController.pickedDateandTime(
                            setStatee: setStatee);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                        alignment: Alignment.center,
                        height: hight * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey)),
                        child: TextWid(
                          text: 'Schedule:  ' +
                              ' ${_incomingOrdersController.pickedDate.day}/${_incomingOrdersController.pickedDate.month}/${_incomingOrdersController.pickedDate.year}' +
                              '@' +
                              '${_incomingOrdersController.pickedTime.hour}:${_incomingOrdersController.pickedTime.minute}',
                          size: width * 0.045,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: TextFieldWidget(
                        controller: _incomingOrdersController.moneyController,
                        hint: 'Money',
                        type: "number",
                        enableBorderColor: Colors.grey,
                        formatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        focusBorderColor: Colors.grey[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Money',
                        maxLines: 1,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.grey[900],
                      ),
                    ),
                    SizedBox(
                      height: hight * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 11, right: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButtonWidget(
                            bgColor: Colors.grey[300],
                            minWidth: width * 0.3,
                            height: hight * 0.06,
                            borderRadius: 15.0,
                            textColor: Colors.grey[900],
                            textSize: width * 0.04,
                            buttonName: 'Close',
                            leadingIcon: Icon(
                              Icons.close,
                              color: Colors.grey[900],
                            ),
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButtonWidget(
                            bgColor: Colors.grey[900],
                            borderSideColor: Colors.white,
                            minWidth: width * 0.55,
                            height: hight * 0.06,
                            borderRadius: 15.0,
                            textSize: width * 0.04,
                            textColor: Colors.white,
                            buttonName: 'Change',
                            trailingIcon: Icon(Icons.send),
                            onClick: () {
                              if (_incomingOrdersController
                                  .updateFormKey.currentState
                                  .validate()) {
                                Navigator.pop(context);
                                _incomingOrdersController.respondToOrder(
                                    ordDetails, partnerProfile['_id'], "bid");
                                if (from == "outside") {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  moredialogue(uid, ordDetails, ordid, pid, uDetails, pDetails) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: Text('Update your possible prices and time'),
              // message: Text('data'),
              actions: [
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Customize'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        _incomingOrdersController
                                            .pickedDateandTime();
                                      },
                                      child: Container(
                                        //padding: EdgeInsets.all(10),
                                        height: 60,
                                        width: 380,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                'Date:  ${_incomingOrdersController.pickedDate.day}/${_incomingOrdersController.pickedDate.month}/${_incomingOrdersController.pickedDate.year}',
                                                style: TextStyle(fontSize: 15)),
                                            Text(
                                                'Time:  ${_incomingOrdersController.pickedTime.hour}:${_incomingOrdersController.pickedTime.minute}',
                                                style: TextStyle(fontSize: 15))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //padding: EdgeInsets.all(10),
                                      height: 60,
                                      width: 380,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: TextField(
                                        cursorColor: Colors.amber,
                                        keyboardType: TextInputType.phone,
                                        //maxLines: 2,
                                        //maxLength: 20,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: 17),
                                          hintText: 'Money',
                                          suffixIcon: Icon(
                                            Icons.change_history,
                                            color: Colors.blue[800],
                                          ),
                                          //border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                        ),
                                        onChanged: (value) {
                                          _incomingOrdersController.pmoney =
                                              value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: ElevatedButton(
                                      // color: Colors.blue[800],
                                      child: Text('Done'),
                                      onPressed: () async {
                                        var body = {
                                          "money": _incomingOrdersController
                                              .pmoney
                                              .toString(),
                                          "schedule": _incomingOrdersController
                                              .pickedDate.millisecondsSinceEpoch
                                              .toString(),
                                          "uId": uid.toString(),
                                          "pId": API.pid.toString(),
                                          "ordId": ordid.toString(),
                                          "orderDetails": ordDetails.toString(),
                                          "responseId": DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          "join": DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          "loc.0": 17.236.toString(),
                                          "loc.1": 83.697.toString(),
                                          "uDetails": uDetails.toString(),
                                          "pDetails": pDetails.toString()
                                        };
                                        //print(uDetails);
                                        Server()
                                            .postMethod(API.updateOrder, body);
                                      }),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text('Update Bid',
                        style: TextStyle(color: Colors.black))),
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  )),
            ));
  }

  // Container(
  //   margin: EdgeInsets.only(
  //       top: 5, bottom: 10),
  //   padding: EdgeInsets.all(5),
  //   height: _hight * 0.07,
  //   decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius:
  //           BorderRadius.circular(10)),
  //   child: Row(
  //     mainAxisAlignment:
  //         MainAxisAlignment
  //             .spaceBetween,
  //     children: [
  //       Flexible(
  //         flex: 2,
  //         // width: _width * 0.4,
  //         child: Column(
  //           mainAxisAlignment:
  //               MainAxisAlignment
  //                   .spaceBetween,
  //           crossAxisAlignment:
  //               CrossAxisAlignment
  //                   .start,
  //           children: [
  //             Row(
  //               mainAxisAlignment:
  //                   MainAxisAlignment
  //                       .start,
  //               children: [
  //                 TextWid(
  //                   text: 'Money: ',
  //                   size: _width * 0.03,
  //                   weight:
  //                       FontWeight.w600,
  //                 ),
  //                 SizedBox(
  //                   width:
  //                       _width * 0.05,
  //                 ),
  //                 TextWid(
  //                   text: o[index]
  //                           ['money']
  //                       .toString(),
  //                   size: _width * 0.03,
  //                 )
  //               ],
  //             ),
  //             Row(
  //               mainAxisAlignment:
  //                   MainAxisAlignment
  //                       .start,
  //               children: [
  //                 TextWid(
  //                   text: 'Location: ',
  //                   size: _width * 0.03,
  //                   weight:
  //                       FontWeight.w600,
  //                 ),
  //                 SizedBox(
  //                   width:
  //                       _width * 0.02,
  //                 ),
  //                 TextWid(
  //                   text: o[index]['loc']
  //                               [0]
  //                           .toString() +
  //                       "," +
  //                       o[index]['loc']
  //                               [1]
  //                           .toString(),
  //                   size: _width * 0.03,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         width: _width * 0.3,
  //         child: Column(
  //           mainAxisAlignment:
  //               MainAxisAlignment
  //                   .spaceBetween,
  //           crossAxisAlignment:
  //               CrossAxisAlignment
  //                   .start,
  //           children: [
  //             Row(
  //               mainAxisAlignment:
  //                   MainAxisAlignment
  //                       .spaceBetween,
  //               children: [
  //                 TextWid(
  //                   text: 'Date: ',
  //                   size: _width * 0.04,
  //                   weight:
  //                       FontWeight.w600,
  //                 ),
  //                 TextWid(
  //                   text: o[index]
  //                           ['schedule']
  //                       .toString(),
  //                   size: _width * 0.03,
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               mainAxisAlignment:
  //                   MainAxisAlignment
  //                       .spaceBetween,
  //               children: [
  //                 TextWid(
  //                   text: 'Time: ',
  //                   size: _width * 0.04,
  //                   weight:
  //                       FontWeight.w600,
  //                 ),
  //                 TextWid(
  //                   text: o[index]
  //                           ['schedule']
  //                       .toString(),
  //                   size: _width * 0.03,
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // ),

  // storeNewData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   log('somthing');
  //   var newOrder = List.from(localData)..addAll(socketincomingorder);
  //   if (socketincomingorder != null)
  //     prefs.setString('inComingOrders', jsonEncode(newOrder)).then((value) {
  //       if (value == true) {
  //         setState(() {});
  //       }
  //       log('$value');
  //     });
  // }

  // FutureBuilder<Object>(
  //     future: localGet(),
  //     builder: (context, localOrders) {
  //       localData = localOrders.data;

  //       // if (socketincomingorder == null) {
  //       //   socketincomingorder.add(localData);
  //       //   // storeNewData();
  //       //   // socketincomingorder.clear();
  //       // }
  //       // socketincomingorder.clear();
  //       // setState(() {});
  //       // if (snap.data == null) return CircularProgressIndicator();
  //       return StreamBuilder(
  //           stream: stream,
  //           builder: (context, orderSocket) {
  //             var neworders = orderSocket.data;
  //             // log(localData.toString());
  //             log(localData.last['ordId'].toString());
  //             if (orderSocket.data != null)
  //               log(neworders['ordId'].toString());
  //             if (orderSocket.data != null) {
  //               log('line225');
  //               if (localData.last['ordId'] != neworders['ordId']) {
  //                 log('true');
  //                 WidgetsBinding.instance.addPostFrameCallback((_) async {
  //                   final prefs = await SharedPreferences.getInstance();
  //                   prefs.setString(
  //                       'inComingOrders',
  //                       jsonEncode(List.from(localData)
  //                         ..addAll([orderSocket.data])));
  //                   setState(() {});
  //                 });
  //               }
  //             }

  //             // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //             //   final prefs = await SharedPreferences.getInstance();
  //             //   prefs.setString(
  //             //       'inComingOrders',
  //             //       jsonEncode(List.from(localData)
  //             //         ..addAll([orderSocket.data])));
  //             //   // setState(() {});
  //             // });
  //             // if (orderSocket.data != null)
  //             //   socketincomingorder.add(orderSocket.data);
  //             // print(socketincomingorder.toString());

  //             // prefs.setString('inComingOrders', jsonEncode(newOrder));

  //             // if (socketincomingorder.isNotEmpty) {
  //             //   for (var i = [orderSocket.data].length; i > 0; i--) {
  //             //     log('Item $i');
  //             //     storeNewData();

  //             //   }

  //             // log('satish');
  //             // log(socketincomingorder.toString());

  //             //}
  //             // // log(localData.toString());
  //             // log(socketincomingorder.toString());
  //             // socketincomingorder.clear();
  //             // var s = ['oko'];
  //             // if (localData != null && s != null) {
  //             //   var i;
  //             //   print('something');
  //             //   print(orderSocket.data);
  //             //   // test(localData);
  //             //   //for (i = s.length - 1; i >= 0; i--) {
  //             //   log('objects');
  //             //   // qwerty(localData, s);
  //             //   //}
  //             //   //qwerty(localData, s);
  //             // }
  //             // test(localData);
  //             // socketincomingorder.removeLast();

  //             // print('satish');
  //             // print(socketOrders);
  //             // print('satish');

  //             // print(orderSocket.data);
  //             //if (localData != null && socketOrders != null) {
  //             //socketOrders.clear();
  //             // storeNewData(localData, socketOrders);
  //             // }
  //             // socketOrders.clear();
  //             // dispose();
  //             return ListView(
  //               children: [
  //                 Text(localOrders.data.toString()),
  //                 IconButton(
  //                     onPressed: () async {
  //                       List da = ['three'];
  //                       var newList = new List.from(localOrders.data)
  //                         ..addAll(da);

  //                       // da.add('satish');
  //                       SharedPreferences prefs =
  //                           await SharedPreferences.getInstance();
  //                       prefs.setString(
  //                           'inComingOrders', jsonEncode(newList));
  //                       setState(() {});
  //                     },
  //                     icon: Icon(Icons.ac_unit))
  //               ],
  //             );
  //           });
  //     })

  // FirebaseFirestore
  //     .instance
  //     .collection(
  //         'partner')
  //     .doc(FirebaseAuth
  //         .instance
  //         .currentUser
  //         .uid)
  //     .collection(
  //         'orders')
  //     .doc(document[
  //         'orderid'])
  //     .update({
  //   'request':
  //       false,
  // });
  // var pid = [
  //   FirebaseAuth
  //       .instance
  //       .currentUser
  //       .uid,
  // ];
  // FirebaseFirestore
  //     .instance
  //     .collection(
  //         'allads')
  //     .doc(document[
  //         'orderid'])
  //     .update({
  //   'request':
  //       false,
  //   'reject': FieldValue
  //       .arrayUnion(
  //           pid)
  // });

  // image(){
  //   return showDialog(
  //                                           context: context,
  //                                           builder: (BuildContext context) {
  //                                             return AlertDialog(
  //                                               backgroundColor:
  //                                                   Colors.transparent,
  //                                               insetPadding: EdgeInsets.zero,
  //                                               contentPadding: EdgeInsets.zero,
  //                                               clipBehavior:
  //                                                   Clip.antiAliasWithSaveLayer,
  //                                               actions: [
  //                                                 Container(
  //                                                     height: _hight * 0.35,
  //                                                     width: _width * 1,
  //                                                     child: CarouselSlider
  //                                                         .builder(
  //                                                       itemCount:
  //                                                           images.length,
  //                                                       itemBuilder: (ctx,
  //                                                           index, realIdx) {
  //                                                         return Container(
  //                                                             child: Image.network(images[
  //                                                                     index]
  //                                                                 .substring(
  //                                                                     0,
  //                                                                     images[index]
  //                                                                             .length -
  //                                                                         1)));
  //                                                       },
  //                                                       options:
  //                                                           CarouselOptions(
  //                                                         autoPlayInterval:
  //                                                             Duration(
  //                                                                 seconds: 3),
  //                                                         autoPlayAnimationDuration:
  //                                                             Duration(
  //                                                                 milliseconds:
  //                                                                     800),
  //                                                         autoPlay: false,
  //                                                         aspectRatio: 2.0,
  //                                                         enlargeCenterPage:
  //                                                             true,
  //                                                       ),
  //                                                     ))
  //                                               ],
  //                                             );
  //                                           });

  // }
}

// FirebaseFirestore
//     .instance
//     .collection(
//         'partner')
//     .doc(FirebaseAuth
//         .instance
//         .currentUser
//         .uid)
//     .collection(
//         'orders')
//     .doc(document[
//         'orderid'])
//     .update(
//   {
//     'request':
//         true,
//     'orderstate':
//         2
//   },
// );

// FirebaseFirestore
//     .instance
//     .collection(
//         'allads')
//     .doc(document[
//         'orderid'])
//     .update({
//   'request':
//       true,
//   'pname': prodoc[
//       'name'],
//   'partnerid':
//       FirebaseAuth
//           .instance
//           .currentUser
//           .uid,
//   'ppic': prodoc[
//       'profilepic'],
//   'time':
//       DateTime
//           .now(),
//   'msgid': FirebaseAuth
//           .instance
//           .currentUser
//           .uid +
//       document[
//           'orderid'],
//   'rating': 5,
//   'distance': 1,
//   'orderstate':
//       2
// });

// // for messaging

// String
//     timestamp =
//     DateTime.now()
//         .millisecondsSinceEpoch
//         .toString();
// var msgData = {
//   'msg':
//       'Hello',
//   'timestamp':
//       timestamp,
//   'sender': 'p',
//   'type': 'text'
// };
// String temp =
//     jsonEncode(
//         msgData);
// FirebaseFirestore
//     .instance
//     .collection(
//         'messaging')
//     .doc(FirebaseAuth
//             .instance
//             .currentUser
//             .uid +
//         document[
//             'orderid'])
//     .set({
//   'createdAt':
//       DateTime
//           .now(),
//   'orderid':
//       document[
//           'orderid'],
//   'partnerid':
//       FirebaseAuth
//           .instance
//           .currentUser
//           .uid,
//   'id': FirebaseAuth
//           .instance
//           .currentUser
//           .uid +
//       document[
//           'orderid'],
//   'pname': prodoc[
//       'name'],
//   'ppic': prodoc[
//       'profilepic'],
//   'pnum': prodoc[
//       'pnum'],
//   'location':
//       prodoc[
//           'location.add1'],
//   'revealprofile':
//       false,
//   'body': FieldValue
//       .arrayUnion([
//     temp
//   ]),
//   'chatbuild':
//       true,
//   'pread': 0,
//   'uread': 0,
//   'umsgcount':
//       0,
//   'pmsgcount':
//       0,
//   'rating': 5,
//   'orderstate':
//       2,
//   'uname': null,
//   'upic': null,
//   'userid':
//       document[
//           'userid']
// });
// FirebaseFirestore
//     .instance
//     .collection(
//         'users')
//     .doc(document[
//         'userid'])
//     .collection(
//         'adpost')
//     .doc(document[
//         'orderid'])
//     .update({
//   'orderstate':
//       2
// });

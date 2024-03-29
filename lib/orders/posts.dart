import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/orders_controller.dart';
import 'package:spotmies_partner/orders/post_overview.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/constants.dart';
import 'package:spotmies_partner/utilities/profile_shimmer.dart';

class PostList extends StatefulWidget {
  final bool orderCompleted;

  PostList({@required this.orderCompleted});
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends StateMVC<PostList> {
  OrdersController _ordersController;
  PartnerDetailsProvider partnerProvider;
  _PostListState() : super(OrdersController()) {
    this._ordersController = controller;
  }
  List filter = ["All", "Today", "Tommorrow", "This week", "This month"];
  @override
  void initState() {
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _ordersController.scaffoldkey,
        body: Column(
          children: [
            // orderFilters(),
            Expanded(
              child: Container(
                // padding: EdgeInsets.all(10),
                height: _hight * 1,
                width: _width * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Consumer<PartnerDetailsProvider>(
                  builder: (context, data, child) {
                    var o = data.getOrders;
                    if (data.ordersLoader)
                      return Center(child: profileShimmer(context));
                    if (o.length < 1)
                      return Center(
                        child: TextWid(
                          text: "Not yet started",
                          size: _width * 0.045,
                        ),
                      );

                    return RefreshIndicator(
                      onRefresh: _ordersController.getOrderFromDB,
                      child: ListView.builder(
                          itemCount: o.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            List<String> images = List.from(o[index]['media']);
                            dynamic orderData = o[index];

                            if (widget.orderCompleted !=
                                o[index]['isOrderCompletedByPartner'])
                              return Container();

                            print(o[index]['ordId']);

                            return Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostOverView(
                                      orderId: orderData['ordId'].toString(),
                                    ),
                                  ));
                                },
                                child: Container(
                                    height: _hight * 0.265,
                                    width: _width * 1,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      // borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: _hight * 0.09,
                                          width: _width * 1,
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey[50],
                                            // borderRadius: BorderRadius.only(
                                            //     topLeft: Radius.circular(15),
                                            //     topRight: Radius.circular(15)),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: _hight * 0.08,
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextWid(
                                                          text: partnerProvider
                                                              .getServiceNameById(
                                                                  o[index]
                                                                      ['job']),
                                                          size: _width * 0.045,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5,
                                                                  left: 5),
                                                          height:
                                                              _hight * 0.032,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                orderStateIcon(
                                                                    ordState: o[index]
                                                                            [
                                                                            'isOrderCompletedByPartner']
                                                                        ? 9
                                                                        : o[index]
                                                                            [
                                                                            'orderState']),
                                                                color: Colors
                                                                        .indigo[
                                                                    900],
                                                                size: _width *
                                                                    0.04,
                                                              ),
                                                              SizedBox(
                                                                width: _width *
                                                                    0.01,
                                                              ),
                                                              TextWid(
                                                                  text: _ordersController.orderStateText(o[
                                                                              index][
                                                                          'isOrderCompletedByPartner']
                                                                      ? 9
                                                                      : o[index][
                                                                          'orderState']),
                                                                  color: Colors
                                                                          .indigo[
                                                                      900],
                                                                  weight:
                                                                      FontWeight
                                                                          .w600,
                                                                  size: _width *
                                                                      0.03)
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    TextWid(
                                                      text: getDate(o[index]
                                                              ['schedule']) +
                                                          ' - ' +
                                                          getTime(o[index]
                                                              ['schedule']),
                                                      color: Colors.grey[600],
                                                      size: _width * 0.03,
                                                      weight: FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: _hight * 0.06,
                                                height: _hight * 0.06,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey[50],
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: (images.length == 0)
                                                    ? Icon(
                                                        Icons.engineering,
                                                        color: Colors.grey[900],
                                                      )
                                                    : Image.network(
                                                        images.first),
                                              ),
                                              Container(
                                                height: _hight * 0.11,
                                                // width: _width * 0.6,
                                                padding: EdgeInsets.only(
                                                    left: _width * 0.06,
                                                    top: _width * 0.02),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: _width * 0.65,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .account_balance_wallet,
                                                                color: Colors
                                                                    .grey[900],
                                                                size: _width *
                                                                    0.04,
                                                              ),
                                                              SizedBox(
                                                                width: _width *
                                                                    0.01,
                                                              ),
                                                              TextWid(
                                                                text: 'Rs.1500',
                                                                // +
                                                                // o[index]['money']
                                                                //     .toString(),
                                                                size: _width *
                                                                    0.035,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              )
                                                            ],
                                                          ),
                                                          TextWid(
                                                              text: toBeginningOfSentenceCase(o[
                                                                      index]
                                                                  ['problem']),
                                                              flow: TextOverflow
                                                                  .ellipsis,
                                                              size: _width *
                                                                  0.045),
                                                        ],
                                                      ),
                                                    ),
                                                    Stack(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey[200],
                                                          child: Icon(
                                                            Icons.chat_bubble,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                        Positioned(
                                                            right: 0,
                                                            top: 0,
                                                            child: CircleAvatar(
                                                                radius: _width *
                                                                    0.02,
                                                                backgroundColor:
                                                                    Colors.indigo[
                                                                        900],
                                                                child: TextWid(
                                                                  text: '5',
                                                                  color: Colors
                                                                      .white,
                                                                  size: _width *
                                                                      0.025,
                                                                )))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.grey[300],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButtonWidget(
                                                minWidth: _width * 0.498,
                                                height: _hight * 0.06,
                                                bgColor: Colors.grey[50],
                                                buttonName: 'Need Help ?',
                                                textColor: Colors.grey[900],
                                                borderRadius: 0.0,
                                                textSize: _width * 0.04,
                                                leadingIcon: Icon(
                                                  Icons.help,
                                                  size: _width * 0.04,
                                                  color: Colors.grey[900],
                                                ),
                                                borderSideColor:
                                                    Colors.grey[50],
                                              ),
                                              ElevatedButtonWidget(
                                                minWidth: _width * 0.498,
                                                height: _hight * 0.06,
                                                bgColor: Colors.grey[50],
                                                buttonName: 'View Menu',
                                                textColor: Colors.grey[900],
                                                borderRadius: 0.0,
                                                textSize: _width * 0.04,
                                                trailingIcon: Icon(
                                                  Icons.menu,
                                                  size: _width * 0.04,
                                                  color: Colors.grey[900],
                                                ),
                                                borderSideColor:
                                                    Colors.grey[50],
                                                onClick: () {
                                                  // postmenu(orderid, _hight, _width);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              padding: EdgeInsets.only(top: 10),
                            );
                          }),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Container orderFilters() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20),
      height: 50,
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: filter.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding:
                    EdgeInsets.only(top: 4, bottom: 4, right: 15, left: 15),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                    alignment: Alignment.center,
                    child: TextWid(text: filter[index])));
          }),
    );
  }
}

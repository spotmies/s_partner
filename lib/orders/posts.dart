import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/orders_controller.dart';
import 'package:spotmies_partner/orders/post_overview.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/constants.dart';
import 'package:spotmies_partner/utilities/profile_shimmer.dart';

class PostList extends StatefulWidget {
  final bool? orderCompleted;

  PostList({required this.orderCompleted});
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends StateMVC<PostList> {
  OrdersController? _ordersController = OrdersController();
  PartnerDetailsProvider? partnerProvider;
  // _PostListState() : super(OrdersController()) {
  //   this._ordersController = controller;
  // }
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
        key: _ordersController?.scaffoldkey,
        body: Column(
          children: [
            // orderFilters(),
            Expanded(
              child: Container(
                // padding: EdgeInsets.all(10),
                height: _hight * 1,
                width: _width * 1,
                decoration: BoxDecoration(
                  color: SpotmiesTheme.background,
                ),
                child: Consumer<PartnerDetailsProvider>(
                  builder: (context, data, child) {
                    var o = data.getOrders;
                    if (data.ordersLoader)
                      return Center(child: profileShimmer(context));

                    return RefreshIndicator(
                      onRefresh: () async {
                        await _ordersController!.getOrderFromDB(context);
                      },
                      child: o.length < 1
                          ? NoDataPlaceHolder(
                              height: _hight,
                              width: _width,
                              title: "Not yet startedd")
                          : ListView.builder(
                              itemCount: o.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                List<String> images =
                                    List.from(o[index]['media']);
                                dynamic orderData = o[index];

                                if (widget.orderCompleted !=
                                    o[index]['isOrderCompletedByPartner'])
                                  return Container();

                                print(o[index]['ordId']);

                                return Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => PostOverView(
                                          orderId:
                                              orderData['ordId'].toString(),
                                        ),
                                      ));
                                    },
                                    child: Container(
                                        height: _hight * 0.265,
                                        width: _width * 1,
                                        decoration: BoxDecoration(
                                          color: SpotmiesTheme.surfaceVariant,
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                              text: partnerProvider!
                                                                  .getServiceNameById(o[
                                                                          index]
                                                                      ['job']),
                                                              size: _width *
                                                                  0.045,
                                                              weight: FontWeight
                                                                  .w600,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 5,
                                                                      left: 5),
                                                              height: _hight *
                                                                  0.032,
                                                              decoration: BoxDecoration(
                                                                  color: SpotmiesTheme
                                                                      .background,
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
                                                                        ordState: o[index]['isOrderCompletedByPartner']
                                                                            ? 9
                                                                            : o[index]['orderState']),
                                                                    color: SpotmiesTheme
                                                                        .primary,
                                                                    size:
                                                                        _width *
                                                                            0.04,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        _width *
                                                                            0.01,
                                                                  ),
                                                                  TextWid(
                                                                      text: _ordersController?.orderStateText(o[index]
                                                                              [
                                                                              'isOrderCompletedByPartner']
                                                                          ? 9
                                                                          : o[index]
                                                                              [
                                                                              'orderState']),
                                                                      color: SpotmiesTheme
                                                                          .primary,
                                                                      weight: FontWeight
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
                                                                  [
                                                                  'schedule']) +
                                                              ' - ' +
                                                              getTime(o[index]
                                                                  ['schedule']),
                                                          color: SpotmiesTheme
                                                              .secondary,
                                                          size: _width * 0.03,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: _hight * 0.06,
                                                    height: _hight * 0.06,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: SpotmiesTheme
                                                          .surfaceVariant,
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: (images.length == 0)
                                                        ? Icon(
                                                            Icons.engineering,
                                                            color: SpotmiesTheme
                                                                .secondaryVariant,
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
                                                                    color: SpotmiesTheme
                                                                        .secondaryVariant,
                                                                    size:
                                                                        _width *
                                                                            0.04,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        _width *
                                                                            0.01,
                                                                  ),
                                                                  TextWid(
                                                                    text:
                                                                        'Rs.1500',
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
                                                                  text: toBeginningOfSentenceCase(
                                                                          o[index]
                                                                              [
                                                                              'problem'])
                                                                      .toString(),
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
                                                                  Colors.grey[
                                                                      200],
                                                              child: Icon(
                                                                Icons
                                                                    .chat_bubble,
                                                                color: Colors
                                                                    .grey[500],
                                                              ),
                                                            ),
                                                            Positioned(
                                                                right: 0,
                                                                top: 0,
                                                                child:
                                                                    CircleAvatar(
                                                                        radius: _width *
                                                                            0.02,
                                                                        backgroundColor:
                                                                            SpotmiesTheme
                                                                                .primary,
                                                                        child:
                                                                            TextWid(
                                                                          text:
                                                                              '5',
                                                                          color:
                                                                              SpotmiesTheme.background,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButtonWidget(
                                                    minWidth: _width * 0.498,
                                                    height: _hight * 0.06,
                                                    bgColor: SpotmiesTheme
                                                        .surfaceVariant,
                                                    buttonName: 'Need Help ?',
                                                    textColor: SpotmiesTheme
                                                        .secondaryVariant,
                                                    borderRadius: 0.0,
                                                    textSize: _width * 0.04,
                                                    leadingIcon: Icon(
                                                      Icons.help,
                                                      size: _width * 0.04,
                                                      color: SpotmiesTheme
                                                          .secondaryVariant,
                                                    ),
                                                    borderSideColor:
                                                        SpotmiesTheme
                                                            .surfaceVariant,
                                                  ),
                                                  ElevatedButtonWidget(
                                                    minWidth: _width * 0.498,
                                                    height: _hight * 0.06,
                                                    bgColor: SpotmiesTheme
                                                        .surfaceVariant,
                                                    buttonName: 'View Menu',
                                                    textColor: SpotmiesTheme
                                                        .secondaryVariant,
                                                    borderRadius: 0.0,
                                                    textSize: _width * 0.04,
                                                    trailingIcon: Icon(
                                                      Icons.menu,
                                                      size: _width * 0.04,
                                                      color: SpotmiesTheme
                                                          .secondaryVariant,
                                                    ),
                                                    borderSideColor:
                                                        SpotmiesTheme
                                                            .surfaceVariant,
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
      color: SpotmiesTheme.background,
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
                    color: SpotmiesTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                    alignment: Alignment.center,
                    child: TextWid(text: filter[index])));
          }),
    );
  }
}

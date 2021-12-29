import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class OrdersController extends ControllerMVC {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  final controller = TestController();
  PartnerDetailsProvider partnerProvider;
  List jobs = [
    'AC Service',
    'Computer',
    'TV Repair',
    'Development',
    'Tutor',
    'Beauty',
    'Photography',
    'Drivers',
    'Events'
  ];
  List state = ['Waiting for confirmation', 'Ongoing', 'Completed'];
  @override
  void initState() {
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);

    super.initState();
  }

  orderStateText(int orderState) {
    switch (orderState) {
      case 0:
        return 'Requested';
      case 1:
        return 'No partner';
      case 2:
        return 'updated';
      case 3:
        return "canceled by user";
      case 4:
        return "cancelled by partner";
      case 5:
      case 6:
        return "went wrong";
      case 7:
        return "Rescheduled";

      case 8:
        return 'On Going';
      case 9:
        return 'Service completed';

      case 10:
        return "Order completed";
      default:
        return 'Went wrong';
    }
  }

  orderStateIcon(String orderState) {
    switch (orderState) {
      case 'req':
        return Icons.pending_actions;
        break;
      case 'noPartner':
        return Icons.stop_circle;
        break;
      case 'updated':
        return Icons.update;
        break;
      case 'onGoing':
        return Icons.run_circle_rounded;
        break;
      case 'completed':
        return Icons.done_all;
        break;
      case 'cancel':
        return Icons.cancel;
        break;
      default:
        return Icons.search;
    }
  }

  getAddressofLocation(addresses) async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // final coordinates = Coordinates(position.latitude, position.longitude);

    return Text(addresses.first.locality.toString());
  }

  Future getOrderFromDB() async {
    var response = await Server().getMethod(API.allOrder + pId);
    if (response.statusCode == 200) {
      var ordersList = jsonDecode(response.body);
      partnerProvider.setOrder(ordersList);

      snackbar(context, "sync with new changes");
    } else
      snackbar(context, "something went wrong");
  }
}

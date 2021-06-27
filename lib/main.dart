import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/home/noInternetScreen.dart';
import 'package:spotmies_partner/home/splash_screen.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<PartnerDetailsProvider>(
        create: (context) => PartnerDetailsProvider()),
    ChangeNotifierProvider<IncomingOrdersProvider>(
        create: (context) => IncomingOrdersProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    var partner = Provider.of<PartnerDetailsProvider>(context, listen: false);
    // var orders = Provider.of<IncomingOrdersProvider>(context, listen: false);
    // orders.incomingOrders();
    partner.partnerDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot != null &&
                snapshot.hasData &&
                snapshot.data != ConnectivityResult.none) {
              return SplashScreen();
            } else {
              return NoInternet();
            }
          }),
    );
  }
}

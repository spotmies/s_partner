import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/home/noInternetScreen.dart';
import 'package:spotmies_partner/home/splash_screen.dart';
import 'package:spotmies_partner/login/stepperpersonalinfo.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<PartnerDetailsProvider>(
        create: (context) => PartnerDetailsProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
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
              return 
             // SplashScreen();
              StepperPersonalInfo();
            } else {
              return NoInternet();
            }
          }),
    );
  }
}

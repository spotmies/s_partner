import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:quick_actions/quick_actions.dart';
import 'package:spotmies_partner/home/splash_screen.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/location_provider.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/providers/timer_provider.dart';
import 'package:spotmies_partner/providers/universal_provider.dart';
import 'package:spotmies_partner/reusable_widgets/local_notifications_and_schedule_notifications.dart';
import 'package:spotmies_partner/reusable_widgets/notifications.dart';
import 'package:spotmies_partner/reusable_widgets/utils.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

// recieve messages when app is in background
Future<void> backGroundHandler(RemoteMessage message) async {
  // LocalNotificationService.displayAwesomeNotification(message);
  displayAwesomeNotificationBackground(message);
  // if (message.notification != null) {
  //   await displayAwesomeNotificationBackground(message);
  //   // OneContext().push(MaterialPageRoute(
  //   //     builder: (_) => NotificationMessage(
  //   //           message: message.notification,
  //   //         )));
  // }
}

Future<void> setPrefThemeMode(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var system_themeMode =
      WidgetsBinding.instance?.window.platformBrightness == Brightness.dark;
  var pref_themeMode =
      (sharedPreferences.getBool("theme_mode") ?? system_themeMode);
  var themeMode = system_themeMode ? ThemeMode.dark : ThemeMode.light;
  if (system_themeMode == false && pref_themeMode == true) {
    themeMode = ThemeMode.dark;
  }
  Provider.of<ThemeProvider>(context, listen: false).setThemeMode(themeMode);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  awesomeInitilize();
  // FirebaseMessaging.onBackgroundMessage((message) => null);

  FirebaseMessaging.onBackgroundMessage(backGroundHandler);
  // displayAwesomeNotification();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UniversalProvider>(
              create: (context) => UniversalProvider()),
          ChangeNotifierProvider<IncomingOrdersProvider>(
              create: (context) => IncomingOrdersProvider()),
          ChangeNotifierProvider<PartnerDetailsProvider>(
              create: (context) => PartnerDetailsProvider()),
          ChangeNotifierProvider<LocationProvider>(
              create: (context) => LocationProvider()),
          ChangeNotifierProvider<TimeProvider>(
              create: (context) => TimeProvider()),
          ChangeNotifierProvider<ChatProvider>(
              create: (context) => ChatProvider()),
          ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // connect();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setPrefThemeMode(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    print("ThemeModeChanged");
    setPrefThemeMode(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class NotificationsDemo extends StatefulWidget {
  const NotificationsDemo({Key? key}) : super(key: key);

  @override
  _NotificationsDemoState createState() => _NotificationsDemoState();
}

class _NotificationsDemoState extends State<NotificationsDemo> {
  @override
  void initState() {
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   final routefromMessage = message.data["route"];
    //   log(routefromMessage);
    //   Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
    // });
    // //forground
    // FirebaseMessaging.onMessage.listen((message) async {
    //   if (message.notification != null) {
    //     print(message.notification.title);
    //     print(message.notification.body);
    //     LocalNotificationService.display(message);
    //   }
    // });
    // // when app background but in recent
    // FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    //   final routefromMessage = message.data["route"];
    //   log(routefromMessage);
    //   LocalNotificationService.display(message);
    //   Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
    // });
    LocalNotidication.init(initSchedule: true);
    listenNotifications();
    super.initState();
  }

  void listenNotifications() {
    LocalNotidication.onNotifications.stream.listen(onlickNotificaion);
  }

  void onlickNotificaion(String payload) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Demo(payload: payload)));
  }

  @override
  Widget build(BuildContext context) {
    SpotmiesTheme().init(context);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    LocalNotidication.showNotifications(
                      title: 'sample',
                      body: 'something to try',
                      payload: 'sample.abs',
                      bigImage: await Utils.downloadFile(
                          'https://spiderimg.amarujala.com/assets/images/2018/10/22/750x506/prabhas_1540214136.jpeg',
                          'bigPicture'),
                      largeIcon: await Utils.downloadFile(
                          'https://spiderimg.amarujala.com/assets/images/2018/10/22/750x506/prabhas_1540214136.jpeg',
                          'largeIcon'),
                    );
                  },
                  icon: Icon(Icons.notifications)),
              IconButton(
                  onPressed: () {
                    LocalNotidication.showShedduleNotifications(
                        title: 'Service',
                        body: 'Today 2.30 PM',
                        payload: 'Service_2.30pm.abs',
                        scheduledDate:
                            DateTime.now().add(Duration(seconds: 15)));
                    snackbar(context, 'Scheduled in 15 seconds');
                  },
                  icon: Icon(Icons.notifications_active)),
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none))
            ],
          ),
        ],
      ),
    );
  }
}

class Demo extends StatelessWidget {
  final String? payload;
  const Demo({Key? key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(payload!),
      ),
    );
  }
}

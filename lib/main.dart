import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:spotmies_partner/home/noInternetScreen.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/universal_provider.dart';
import 'package:spotmies_partner/reusable_widgets/notifications.dart';
import 'package:spotmies_partner/reusable_widgets/utils.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<UniversalProvider>(
          create: (context) => UniversalProvider()),
      ChangeNotifierProvider<IncomingOrdersProvider>(
          create: (context) => IncomingOrdersProvider()),
      ChangeNotifierProvider<PartnerDetailsProvider>(
          create: (context) => PartnerDetailsProvider()),
      ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider())
    ], child: MyApp()));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final quickActions = QuickActions();

  @override
  void initState() {
    // LocalNotidication.init();
    // listenNotifications();
    quickActions.setShortcutItems([
      ShortcutItem(type: 'Home', localizedTitle: 'Go Home'),
      ShortcutItem(type: 'Chat', localizedTitle: 'Go Chat'),
      ShortcutItem(type: 'Jobs', localizedTitle: 'Go Jobs'),
      ShortcutItem(type: 'Learn', localizedTitle: 'Go Learn')
    ]);

    // quickActions.initialize((type) {
    //   if(type == 'Home'){
    //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBar(data:1)));
    //   }if(type == 'Chat'){
    //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBar(data:2)));
    //   }if(type == 'Jobs'){
    //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBar(data:3)));
    //   }if(type == 'Learn'){
    //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBar(data:4)));
    //   }
    // });
    super.initState();
  }

  // void listenNotifications(){
  //   LocalNotidication.onNotifications.stream.listen(onlickNotificaion);
  // }

  // void onlickNotificaion(String payload){
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Demo(payload:payload)));
  // }

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
              return NotificationsDemo();
            } else {
              return NoInternet();
            }
          }),
    );
  }
}

class NotificationsDemo extends StatefulWidget {
  const NotificationsDemo({Key key}) : super(key: key);

  @override
  _NotificationsDemoState createState() => _NotificationsDemoState();
}

class _NotificationsDemoState extends State<NotificationsDemo> {
  @override
  void initState() {
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
  final String payload;
  const Demo({Key key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(payload),
      ),
    );
  }
}

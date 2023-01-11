import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:x_positron/mainpages/introduction.dart';
import 'package:x_positron/mainpages/questions.dart';
import 'package:x_positron/mainpages/signup.dart';
import 'package:x_positron/mainpages/subjects_rate.dart';
import 'package:x_positron/mainpages/user_subjects.dart';
import 'package:x_positron/provider/connectivity.dart';
import 'package:x_positron/provider/subjects_info.dart';
import 'package:x_positron/provider/userdata.dart';
import 'package:flutter/material.dart';
import 'package:x_positron/mainpages/home_page.dart';
import 'package:x_positron/mainpages/contactus.dart';
import 'package:x_positron/mainpages/login.dart';
import 'animation/splashscreen_atom.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  await FlutterDownloader.initialize(debug: false);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return UserData();
        }),
        ChangeNotifierProvider(create: (context) {
          return ConnectivityProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return SubjectsInfo();
        }),
      ],
      child: Consumer<SubjectsInfo>(
        builder: (context, subjectsInfo, child) {
          if (subjectsInfo.firstYear.isEmpty &&
              subjectsInfo.secondyear.isEmpty &&
              subjectsInfo.thirdyear.isEmpty &&
              subjectsInfo.forthyear.isEmpty &&
              subjectsInfo.fifthyear.isEmpty) {
            subjectsInfo.getSubjectInfo();
            return Consumer<UserData>(builder: (context, data, child) {
              if (data.username == null) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'X-POSITRON',
                    theme: ThemeData(
                        fontFamily: "serif",
                        primarySwatch: Colors.blue,
                        sliderTheme: SliderThemeData(
                            trackHeight: 5,
                            valueIndicatorColor: Colors.blue,
                            minThumbSeparation: 5,
                            valueIndicatorTextStyle: TextStyle(fontSize: 20),
                            showValueIndicator: ShowValueIndicator.always),
                        // appBarTheme: AppBarTheme(
                        //     backgroundColor: Colors.black26, color: Colors.black26),
                        textTheme: TextTheme(
                            bodyText1: TextStyle(color: Colors.white))),
                    home: Introduction(),
                    routes: {
                      "home": (context) => MyApp(),
                      "signup": (context) => Signup(),
                      "login": (context) => Login(),
                      "subjects": (context) => SubjectsRate(),
                      "userSubjects": (context) => User_subjects(),
                      "contactus": (context) => ContactUs(),
                      "questions": (context) => Questions(),
                    });
              }
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(body: SplashscreenAtom()));
            });
          }
          if (subjectsInfo.firstYear.isNotEmpty ||
              subjectsInfo.secondyear.isNotEmpty ||
              subjectsInfo.thirdyear.isNotEmpty ||
              subjectsInfo.forthyear.isNotEmpty ||
              subjectsInfo.fifthyear.isNotEmpty) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'X-POSITRON',
                theme: ThemeData(
                    fontFamily: "serif",
                    primarySwatch: Colors.blue,
                    sliderTheme: SliderThemeData(
                        trackHeight: 5,
                        valueIndicatorColor: Colors.blue,
                        minThumbSeparation: 5,
                        valueIndicatorTextStyle: TextStyle(fontSize: 20),
                        showValueIndicator: ShowValueIndicator.always),
                    // appBarTheme: AppBarTheme(
                    //     backgroundColor: Colors.black26, color: Colors.black26),
                    textTheme:
                        TextTheme(bodyText1: TextStyle(color: Colors.white))),
                home: Consumer<UserData>(
                    builder: (context, data, child) =>
                        data.username != null ? MyApp() : Introduction()),
                routes: {
                  "home": (context) => MyApp(),
                  "signup": (context) => Signup(),
                  "login": (context) => Login(),
                  "subjects": (context) => SubjectsRate(),
                  "userSubjects": (context) => User_subjects(),
                  "contactus": (context) => ContactUs(),
                  "questions": (context) => Questions(),
                });
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: SplashscreenAtom()));
        },
      )));
}

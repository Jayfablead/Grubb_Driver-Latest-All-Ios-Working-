import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodie_driver/WelcomeScreen.dart';
import 'package:foodie_driver/constants.dart';
import 'package:foodie_driver/model/mail_setting.dart';
import 'package:foodie_driver/services/FirebaseHelper.dart';
import 'package:foodie_driver/services/helper.dart';
import 'package:foodie_driver/services/notification_service.dart';
import 'package:foodie_driver/ui/WelcomeDialog.dart';
import 'package:foodie_driver/ui/auth/AuthScreen.dart';
import 'package:foodie_driver/ui/container/ContainerScreen.dart';
import 'package:foodie_driver/ui/home/HomeScreen.dart';
import 'package:foodie_driver/ui/onBoarding/OnBoardingScreen.dart';
import 'package:foodie_driver/userPrefrence.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/User.dart';

NotificationService notificationService = NotificationService();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  notificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await UserPreference.init();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        useOnlyLangCode: true,
        useFallbackTranslations: true,
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  /// this key is used to navigate to the appropriate screen when the
  /// notification is clicked from the system tray
  static User? currentUser;
  NotificationService notificationService = NotificationService();

  /*
  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (currentUser != null) {
        await FireStoreUtils.getCurrentUser(currentUser!.userID).then((value) {
          if (value != null) {
            currentUser = value;
            currentUser!.fcmToken = token;
            FireStoreUtils.updateCurrentUser(currentUser!);
          }
        });
      }
    });
  }

   */

  void initializeFlutterFire() async {
    try {
      await FirebaseFirestore.instance
          .collection(Setting)
          .doc("globalSettings")
          .get()
          .then((dineinresult) {
        if (dineinresult.exists &&
            dineinresult.data() != null &&
            dineinresult.data()!.containsKey("website_color")) {
          COLOR_PRIMARY = int.parse(
              dineinresult.data()!["website_color"].replaceFirst("#", "0xff"));
        }
      });

      await FirebaseFirestore.instance
          .collection(Setting)
          .doc("googleMapKey")
          .get()
          .then((value) {
        print(value.data());
        GOOGLE_API_KEY = value.data()!['key'].toString();
      });

      await FirebaseFirestore.instance
          .collection(Setting)
          .doc("emailSetting")
          .get()
          .then((value) {
        if (value.exists) {
          mailSettings = MailSettings.fromJson(value.data()!);
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Grubb Locate'.tr(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Color(COLOR_PRIMARY)),
          iconTheme: IconThemeData(color: Color(COLOR_PRIMARY)),
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        primaryColor: Color(COLOR_PRIMARY),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
          ),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Color(COLOR_PRIMARY)),
          iconTheme: IconThemeData(color: Color(COLOR_PRIMARY)),
        ),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.grey.shade900),
        primaryColor: Color(COLOR_PRIMARY),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.grey[200],
            fontSize: 17.0,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
          ),
        ),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      color: Color(COLOR_PRIMARY),
      home: Builder(
        builder: (context) {
          // Check if the user has agreed to the terms
          bool hasAgreed =
              UserPreference.getBoolean(UserPreference.userAgreementKey);
          if (!hasAgreed) {
            // Show WelcomeDialog if not agreed
            return WelcomeDialog();
          }

          // Check if the user has finished onboarding
          bool hasFinishedOnboarding =
              UserPreference.getBoolean(UserPreference.isFinishOnBoardingKey);
          if (!hasFinishedOnboarding) {
            // Show OnBoarding if onboarding not completed
            return WelcomeScreen();
          }

          // Else, show main screen
          return HomeScreen();
        },
      ),
    );
  }

  @override
  void initState() {
    //notificationInit();
    initializeFlutterFire();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

// @override
// Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//   if (auth.FirebaseAuth.instance.currentUser != null && currentUser != null) {
//     await FireStoreUtils.getCurrentUser(MyAppState.currentUser!.userID).then((value) {
//       MyAppState.currentUser = value;
//       if (state == AppLifecycleState.paused) {
//         //user offline
//         MyAppState.currentUser!.lastOnlineTimestamp = Timestamp.now();
//         if (MyAppState.currentUser!.inProgressOrderID != null) {
//           MyAppState.currentUser!.isActive = false;
//         } else {
//           MyAppState.currentUser!.isActive = MyAppState.currentUser!.isActive == true ? false : true;
//         }
//         FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
//       } else if (state == AppLifecycleState.resumed) {
//         //user online
//         if (MyAppState.currentUser!.inProgressOrderID != null) {
//           MyAppState.currentUser!.isActive = false;
//         } else {
//           MyAppState.currentUser!.isActive = MyAppState.currentUser!.isActive == false ? true : false;
//         }
//         FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
//       }
//     });
//   }
// }
}

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding = (prefs.getBool(FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        User? user = await FireStoreUtils.getCurrentUser(firebaseUser.uid);
        if (user != null && user.role == USER_ROLE_DRIVER) {
          if (user.active) {
            user.isActive = true;
            user.role = USER_ROLE_DRIVER;
            user.fcmToken =
                await FireStoreUtils.firebaseMessaging.getToken() ?? '';
            await FireStoreUtils.updateCurrentUser(user);
            print('User Ka Id He : ${user.userID}');
            MyAppState.currentUser = user;
            pushReplacement(context, ContainerScreen(user: user));
          } else {
            user.isActive = false;
            user.lastOnlineTimestamp = Timestamp.now();
            await FireStoreUtils.updateCurrentUser(user);
            print('User Ka Id He : ${user.userID}');
            await auth.FirebaseAuth.instance.signOut();
            MyAppState.currentUser = null;
            pushAndRemoveUntil(context, AuthScreen(), false);
          }
        } else {
          pushReplacement(context, AuthScreen());
        }
      } else {
        pushReplacement(context, AuthScreen());
      }
    } else {
      pushReplacement(context, OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(
            Color(COLOR_PRIMARY),
          ),
        ),
      ),
    );
  }
}

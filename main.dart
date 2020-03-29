import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  StreamSubscription streamSubscription;
  final FirebaseMessaging _fcm = FirebaseMessaging(); // For FCM
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>(); // To be used as navigator
  StreamSubscription iosSubscription;


  @override
  void initState() {

    /* Handle Notifications */
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          // TODO: As per your need
        },
        onLaunch: (Map<String, dynamic> message) async {
          // On App Launch
          handleClickedNotification(message);
        },
        onResume: (Map<String, dynamic> message) async {
          // On App Resume
          return handleClickedNotification(message);
        },
    );

    if (Platform.isIOS) {
        iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
            // save the token  OR subscribe to a topic here
        });

        _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    super.initState();
  }

  handleClickedNotification(message){
    // Put your logic here before redirecting to your material page route if you want too
    navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (context) => InternalPage()));
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App Name",
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.blue, fontFamily: 'Roboto'),
      navigatorKey: navigatorKey,
      home: HomePage(),
      routes: {
        "home": (context) => HomePage(),
        // Your Routes
      },
    );
    
  }
}
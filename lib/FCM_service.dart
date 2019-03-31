import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';


class FCMService extends StatefulWidget {

  @override
  FCMServiceState createState() {
    return FCMServiceState();
  }

}

class FCMServiceState extends State<FCMService> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token;
  String _message;

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }
  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print('Token: $token');
      setState(() {
        _token = token;
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        setState(() {
          _message = message.toString();
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        setState(() {
          _message = message.toString();
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        _message = message.toString();
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  Widget build(BuildContext context) {

    return Container();
  }

}



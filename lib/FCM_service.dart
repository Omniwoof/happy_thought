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
  String _title;
  String _body;

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
        print('on message ${message}');
        setState(() {
          _message = message.toString();
          _title = message['notification']['title'];
          _body = message['notification']['body'];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("It's time to answer $_title"),
                  content: Text(_body.toString()),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text('Close', style: TextStyle (
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
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



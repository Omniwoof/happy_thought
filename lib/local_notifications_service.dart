import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'poll_element.dart';
import 'polls_model.dart';
import 'package:flutter/cupertino.dart';



class LocalNotification extends StatefulWidget {

  @override
  LocalNotificationState createState() => LocalNotificationState();
}


class LocalNotificationState extends State<LocalNotification>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  @override

  initState() {
    super.initState();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocationLocation);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);


    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }


  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PollElement(pollID: payload),
    )
    );
  }

  Future onDidRecieveLocationLocation(
      int id, String title, String body, String payload) async {
    // Display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
            builder: (BuildContext context) => CupertinoAlertDialog (
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OK'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(
                      //TODO: FIX poll element to accept pollID as a payload
                      context, MaterialPageRoute(builder: (context) => PollElement(pollID: payload))
                    );
                  },
                )
              ],
            )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }

}


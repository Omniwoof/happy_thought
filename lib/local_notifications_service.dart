import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'poll_element.dart';
import 'polls_model.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';



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
        'ic_io_notification');
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

  Future scheduleNotification() async {
    var scheduleNotificationDateTime = new DateTime.now().add(new Duration(seconds: 5));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel desc',
        importance: Importance.Max, priority: Priority.High,
        icon: 'ic_io_notification',
//        sound: 'slow_spring_board',
//        largeIcon: 'ic_io_notification.xml',
//        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(244, 224, 162, 1)
    );

    var IOSPlatformChannelSpecifics = new IOSNotificationDetails(
        sound: 'slow_spring_board.aiff'
    );

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        IOSPlatformChannelSpecifics
    );
    print('Notficifation sent');

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduleNotificationDateTime,
        platformChannelSpecifics
    );

  }


  Future showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel desc',
      importance: Importance.Max, priority: Priority.High
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpeficics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpeficics,
    payload: 'item x');


  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}




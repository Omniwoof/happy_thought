import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'poll_element.dart';
import 'polls_model.dart';
import 'package:flutter/cupertino.dart';
import 'auth.dart';
import 'dart:typed_data';
import 'schedule_model.dart';
import 'polls_page.dart';


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class NotificationService extends ListPollsPage{
  static String userID;

  NotificationService(@required userID);

  Stream<QuerySnapshot> notificationStream =
  //TODO: Fix this document reference
      Firestore.instance.collection('users')
          .document('Xq0G56MmuaPqWfhSy0GDnnbBN2r1')
          .collection('notifications')
          .snapshots();



  checkNotfications(){
    Iterable<Map<String, dynamic>> notifications;
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

//    print('checking notifications: $userID');
//    notificationStream.listen((data) => print(data.documents.map((k)=> k.data)));
    notificationStream.listen((snapshot){
      var notes = snapshot.documents.map((data){
        var schedule = Schedule.fromMap(data.data);
//        print('Data.data: ${data.data}');
//        print(schedule.pollId);
        if(schedule.repeat == 'daily'){
//          print('Daily found!');
          LocalNotificationState().showDailyAtTime();
        }
        else if(schedule.repeat == 'weekly') {
          () async {await LocalNotificationState()._showWeeklyAtDayAndTime(schedule);};
        }
        else if(schedule.repeat == 'none') {
          LocalNotificationState().scheduleNotification(schedule);
        }
        return data.data;
      });
//      print('Notes: $notes');
      notifications = notes;
//      print('Notifications: $notifications');
    });

  }



}


class LocalNotification extends StatefulWidget {
  var flutterLocalNotificationsPlugin;

  @override
  LocalNotificationState createState() => LocalNotificationState();
}


class LocalNotificationState extends State<LocalNotification>{
  var platform = MethodChannel('crossingthestreams.io/resourceResolver');
//  var flutterLocalNotificationsPlugin;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  @override
  initState() {
    super.initState();
    print('INISTATE LocalNotificationState');
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

//
//  @override
//
//  initState() {
//    super.initState();
//
//// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//    var initializationSettingsAndroid = AndroidInitializationSettings(
//        'ic_io_notification');
//    var initializationSettingsIOS = IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidRecieveLocationLocation);
//    var initializationSettings = InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
//
//
//    flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        onSelectNotification: onSelectNotification);
  print('Trigger StreamBuilder');
    StreamBuilder(
      stream: Firestore.instance.collection('polls').where('client', isEqualTo: 'Xq0G56MmuaPqWfhSy0GDnnbBN2r1').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){print('Testing Notifications Stream: $snapshot');}
        else{print('NO DATA IN SNAPSHOT');}
      },
    );

  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) =>
      new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  //TODO: FIX poll element to accept pollID as a payload
                  builder: (context) => PollElement(pollID: payload),
                ),
              );
            },
          )
        ],
      ),
    );
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

  Future scheduleNotification(schedule) async {
//    var scheduleNotificationDateTime = new DateTime.now().add(new Duration(seconds: 5));
    var scheduleNotificationDateTime = new DateTime(schedule.year, schedule.month, schedule.day, schedule.hour, schedule.minute, 0);
    print('scheduleNotificationDateTime: $scheduleNotificationDateTime');
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel id',
        schedule.pollId,
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

    await flutterLocalNotificationsPlugin.schedule(
        0,
        schedule.pollId,
        'Single notification scheduled body',
        scheduleNotificationDateTime,
        platformChannelSpecifics
    );

  }


//  Future _showDailyAtTime(schedule) async {
////    var time = new Time(schedule.hour, schedule.minute, 0);
//    var time = Time(21,2,15);
//    print('Daily Schedule: ${time.hour}:${time.minute}.${time.second}');
//    print('Current Time: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'repeatDailyAtTime channel id',
//        'repeatDailyAtTime channel name',
//        'repeatDailyAtTime description');
//    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//    var platformChannelSpecifics = new NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        'show daily title',
//        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
//        time,
//        platformChannelSpecifics);
//  }

  Future showDailyAtTime() async {
    var time = new Time(21, 19, 00);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
  }

  Future _showWeeklyAtDayAndTime(schedule) async {
    print('Weekly NOTIFICTION SET ${schedule.hour} ${schedule.minute}');
    var time = new Time(schedule.hour, schedule.minute, 0);
    var day = schedule.dayOfTheWeek;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on $day at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        Day.Wednesday,
//        day,
        time,
        platformChannelSpecifics);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}




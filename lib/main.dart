import 'package:flutter/material.dart';
import 'polls_page.dart';
import 'auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'user_profile.dart';
import 'login_button.dart';
import 'local_notifications_service.dart';
import 'FCM_service.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inside Outcomes',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 51, 102, 153),
//      primaryColor: Colors.blueGrey[700],
//        primarySwatch: Colors.blueGrey,
        accentColor: Colors.amberAccent,
        backgroundColor: Color.fromARGB(255, 242, 221, 169),
//          primaryTextTheme: TextTheme(white),
          sliderTheme: SliderThemeData(
              trackHeight: 2.0,
              activeTrackColor: Color.fromARGB(255, 242, 221, 169),
              inactiveTrackColor: Color.fromARGB(255, 242, 221, 169),
              disabledActiveTrackColor: Colors.black,
              disabledInactiveTrackColor: Colors.black,
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.white,
              disabledActiveTickMarkColor: Colors.black,
              disabledInactiveTickMarkColor: Colors.black,
              thumbColor: Color.fromARGB(255, 242, 221, 169),
              disabledThumbColor: Colors.black,
              overlayColor: Colors.red,
              valueIndicatorColor: Color.fromARGB(255, 242, 221, 169),
              trackShape: RectangularSliderTrackShape(),
              tickMarkShape: RoundSliderTickMarkShape (),
              thumbShape: RoundSliderThumbShape(),
              overlayShape: RoundSliderOverlayShape(),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              showValueIndicator: ShowValueIndicator.onlyForDiscrete,
              valueIndicatorTextStyle: TextStyle(color: Colors.black),
//              valueIndicatorTextStyle: ThemeData.fallback().accentTextTheme.body2.copyWith(color: Color(0xfeedcafe)),
    ),
        cardColor: Colors.amber,
        primaryColorDark: Colors.red,
        primarySwatch: Colors.red,
        buttonColor: Colors.amber,
        unselectedWidgetColor: Colors.white,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 221, 169),
      appBar: AppBar(
          title: Text('Inside Outcomes'),
          actions: <Widget>[
//            LoginButton(),
        ],

      ),
      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoginButton(),
          HomeScreen(),
          FCMService(),
//          LocalNotification(),
//          RaisedButton(
//            child: Text('+5 seconds notification'),
//            onPressed: () async {
////              await LocalNotificationState().scheduleNotification();
//            },
//          )
//          ListPollsPage(),
        ],
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
//            LocalNotification();
//            NotificationService().checkNotfications();
            return ListPollsPage();
//          return Container();
          }
          else {
            return Container();
          }
        }
    );
  }


}
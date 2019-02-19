import 'package:flutter/material.dart';
import 'polls_page.dart';
import 'auth.dart';
import 'user_profile.dart';
import 'login_button.dart';
import 'local_notifications_service.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Thought',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Happy Thought'),
          actions: <Widget>[
//            LoginButton(),
        ],

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoginButton(),
          UserProfile(),
          HomeScreen(),
          LocalNotification(),
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
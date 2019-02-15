import 'package:flutter/material.dart';
import 'auth.dart';

Map<String, dynamic> profile;

class UserProfile extends StatefulWidget {

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {

  bool _loading = false;

  @override
  initState() {
    super.initState();

    authService.profile.listen((state) => setState(() => profile = state));
    authService.loading.listen((state) => setState(()=> _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
//        Container(padding: EdgeInsets.all(20.0), child: Text(profile.toString())),
//          Text(_loading.toString()),
//      ListPollsPage()
        ],);
    }else{
      return Container();
    }
  }

}
import 'package:flutter/material.dart';
import 'auth.dart';
import 'polls_page.dart';



class UserProfile extends StatefulWidget {

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;
//  String currentUID;

  @override
  initState() {
    super.initState();

    authService.profile.listen((state) => setState(() {
      _profile = state;
    }));
    authService.loading.listen((state) => setState(()=> _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
//      return Container();
      return Container(padding: EdgeInsets.all(20.0), child: Text(_profile.toString()));
//      return ListPollsPage();
//      return Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          CircularProgressIndicator(),
//        Container(padding: EdgeInsets.all(20.0), child: Text(profile.toString())),
//          Text(_loading.toString()),
//      ListPollsPage()
//        ],);
    }else{
      return Container(child: Text('Awaiting profile'));
    }
  }

}
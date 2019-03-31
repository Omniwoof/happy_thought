import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sched_test.dart';

class LoginButton extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                RaisedButton(
//                  child: Text('Notifications'),
//                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SchedHomePage()));},
//                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                  child: StreamBuilder(
                      stream: FirebaseAuth.instance.currentUser().asStream(),
                      builder:
                      (BuildContext context, AsyncSnapshot<FirebaseUser> userSnapshot) {
                        //TODO: Fix this. Flashing overflow errors when photoUrl doesn't exist yet
                        if (userSnapshot.hasData) {
                          print('PhotoURL: ${snapshot.data.photoUrl}');
                          return FloatingActionButton(
                            //TODO: Do we need to show more client details onClick?
                            onPressed: () {},
                            elevation: 16.0,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userSnapshot.data.photoUrl),
                              radius: 36.0,
                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                      }
                  ),
                ),
                SizedBox(height: 0.0, width: 90.0,),
                Container(
                  alignment: Alignment(0.0,0.0),
                  margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                  child: MaterialButton(
                    onPressed: () => authService.signOut(),
                    elevation: 8.0,
                    color: Colors.red,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Text('Signout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)
                    ),
                  ),
                ),
              ],
            );
          }
          else {
            return Container(
              margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
              child: MaterialButton(
                onPressed: () => authService.googleSignIn(),
                elevation: 8.0,
                color: Colors.white,
                textColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Text('Login with Google',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)
                ),
              ),
            );
          }
        }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'results_page.dart';
import 'polls_model.dart';
import 'poll_element.dart';
import 'local_notifications_service.dart';
import 'user_profile.dart';
import 'dart:async';
import 'auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';

class ListPollsPage extends StatefulWidget {

  @override
  ListPollsPageState createState() => ListPollsPageState();
}

class ListPollsPageState extends State<ListPollsPage> {

  static AudioCache player = new AudioCache();

  var currentUID;
  var _profile;


  @override
  Widget build(BuildContext context) {
    player.load('chime.wav');


//      return Container();
    return _buildFrame(context);
  }

  Widget _buildFrame(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseAuth.instance.currentUser().asStream(),
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if(snapshot.hasData){
            currentUID = snapshot.data.uid;
          return _buildBody(context, snapshot.data.uid);
          }
          else
          {return Container();}
        }
    );

//    return Container(
//      child: _buildBody(context),
//    );
  }

  Widget _buildBody(BuildContext context, String userID) {
//    print('Current User: $userID');
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('polls').where(
          'client', isEqualTo: userID ).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
//          print('Awaiting polls');
          return Center(
              child: CircularProgressIndicator()
          );
        }
        else {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }


  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      child: ListView(
      shrinkWrap: true,
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final poll = Poll.fromSnapshot(data);

    void showSubmitSuccess(context) {
      print('playsound');
      Vibrate.vibrate();
      player.play('chime.wav');
//      Navigator.pop(context);
//      showModalBottomSheet(
//          context: context,
//          builder: (BuildContext bc) {
////            Future.delayed(Duration(seconds: 2), () {
////              Navigator.of(bc, rootNavigator: true).pop();
////            });
//            return Container(
//                height: 48.0,
//                color: Colors.green,
//                child: Center(
//                    child: Text('Saved to database',
//                        style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            color: Colors.white,
//                            fontSize: 20.0))
//                )
//            );
//          }
//      );
    }

    Widget buildListTile() {
      if (poll.elements != null){
        return Card(
          color: Color.fromARGB(255, 51, 102, 153),
          elevation: 10.0,
          child: ListTile(
            trailing: IconButton(
              color: Colors.white,
              icon: Icon(Icons.assessment),
              iconSize: 40.0,
              onPressed: () => _goResults(poll),
            ),
            title: Container(
              padding: EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 2.0, color: Colors.white)
                )
              ),
              child: FlatButton(
//                elevation: 8.0,
//                  color: Colors.white,
                  child: Text(poll.title, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => PollElement(poll: poll))
                    );
                  }),
            ),
          ),
        );
      }
      else {
        return Card(
          color: Color.fromARGB(255, 51, 102, 153),
          elevation: 10.0,
          child: ListTile(
            trailing: IconButton(
              color: Colors.white,
              icon: Icon(Icons.assessment),
              iconSize: 40.0,
              onPressed: () => _goResults(poll),
            ),
            title: Container(
              padding: EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 2.0, color: Colors.white)
                  )
              ),
              child: FlatButton(
                  child: Text(poll.title, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),),
                  onPressed: () {
                    Firestore.instance.collection('polls')
                        .document(poll.polls.documentID)
                        .collection('results')
                        .document().setData(
                          {
                            'created_at': FieldValue.serverTimestamp(),
                            'pollID': poll.polls.documentID,
                          });
                      showSubmitSuccess(context);
                  }
              ),
            ),
          ),
        );
      }
    }

    return Padding(
      key: ValueKey(poll.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
//        height: 92.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 51, 102, 153),
//          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(child: buildListTile()),
      ),
    );
  }

  _goResults (poll) {
    return Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => ShowResults(poll: poll)
      ),
    );
  }

}

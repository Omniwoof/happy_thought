import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'results_page.dart';
import 'polls_model.dart';
import 'poll_element.dart';
import 'user_profile.dart';
import 'dart:async';
import 'auth.dart';
import 'package:rxdart/rxdart.dart';

class ListPollsPage extends StatefulWidget {

  @override
  ListPollsPageState createState() => ListPollsPageState();
}

class ListPollsPageState extends State<ListPollsPage> {

  var _currentUID;
  var _profile;


  @override
  Widget build(BuildContext context) {


//      return Container();
    return _buildFrame(context);
  }

  Widget _buildFrame(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseAuth.instance.currentUser().asStream(),
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          return _buildBody(context, snapshot.data.uid);
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
          'client', isEqualTo: userID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
//          print('Awaiting polls');
          return Center(
              child: CircularProgressIndicator()
          );
        }
        else {
//          print('Poll data received');
//            return Text('DATA HERE');
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
          elevation: 8.0,
          child: ListTile(
            title: Column(
              children: <Widget>[
                Text(poll.polls.documentID),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () => _goResults(poll),
            ),
            subtitle: MaterialButton(
                child: Text(poll.title),
                onPressed: () =>
                    Firestore.instance.collection('results')
                        .document().setData(
                        {
                          'created_at': FieldValue.serverTimestamp(),
                          'pollID': poll.polls.documentID,
                        })
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

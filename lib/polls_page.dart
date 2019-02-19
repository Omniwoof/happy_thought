import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results_page.dart';
import 'polls_model.dart';
import 'poll_element.dart';
import 'user_profile.dart';
import 'dart:async';

class ListPollsPage extends StatefulWidget {

  @override
  _ListPollsPageState createState() => _ListPollsPageState();
}

class _ListPollsPageState extends State<ListPollsPage> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _buildFrame(context),
    );
  }

  Widget _buildFrame(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
//    if (profile.containsKey('uid')){
//      print('Found profile.uid: ${profile['uid']}');
      return StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('polls').where('client', isEqualTo: profile['uid']).snapshots(),
      stream: Firestore.instance.collection('polls').where('client', isEqualTo: 'Xq0G56MmuaPqWfhSy0GDnnbBN2r1').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('Awaiting polls');
          return Center(
              child: CircularProgressIndicator()
          );
          }
          else{
            print('Poll data received');
//            return Text('DATA HERE');
          return _buildList(context, snapshot.data.documents);
          }
        },
      );
//    }
//    else {
//      //TODO: Find better way of waiting for UID to be loaded.
//      Timer(Duration(milliseconds: 10),() {
//        print('iterating over timer');
//      return _buildFrame(context);
//      });
//
//    }
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      child: ListView(
//      shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final poll = Poll.fromSnapshot(data);
    Widget buildListTile() {
      if (poll.elements != null){
        return ListTile(
          trailing: IconButton(
            icon: Icon(Icons.assessment),
            onPressed: () => _goResults(poll),
          ),
          title: RaisedButton(
              child: Text(poll.title),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => PollElement(poll: poll))
                );
              }),
        );
      }
      else {
        return ListTile(
          title: Column(
            children: <Widget>[
              Text(poll.polls.documentID),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.assessment),
            onPressed: () => _goResults(poll),
          ),
          subtitle: RaisedButton(
              child: Text(poll.title),
              onPressed: () =>
                  Firestore.instance.collection('results')
                      .document().setData(
                      {
                        'created_at': FieldValue.serverTimestamp(),
                        'pollID': poll.polls.documentID,
                      })
          ),
        );
      }
    }

    return Padding(
      key: ValueKey(poll.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: buildListTile(),
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

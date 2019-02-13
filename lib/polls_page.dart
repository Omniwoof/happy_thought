import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results_page.dart';
import 'polls_model.dart';
import 'poll_element.dart';

class ListPollsPage extends StatefulWidget {

  @override
  _ListPollsPageState createState() => _ListPollsPageState();
}

class _ListPollsPageState extends State<ListPollsPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildFrame(context),
    );
  }

  Widget _buildFrame(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: _buildBody(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('polls').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
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

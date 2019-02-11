import 'package:flutter/material.dart';
import 'polls_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results_model.dart';

class ShowResults extends StatelessWidget{
  final Poll poll;

  ShowResults({Key key, @required this.poll}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Poll'),
      ),
      body: Center(
        child: _buildOutput(context),
      ),
    );

  }


  _buildOutput(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('results').where('pollID', isEqualTo: poll.polls.documentID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildOutputList(context, snapshot.data.documents);
      },
    );
  }
  _buildOutputList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      padding: const EdgeInsets.only(top: 2.0),
      children: snapshot.map<Widget>((data) => _buildOutputListItem(context, data)).toList(),
    );
  }


  _buildOutputListItem (BuildContext context, DocumentSnapshot data) {
    final output = Results.fromSnapshot(data);

    return Padding(
      key: ValueKey(output.pollID),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          subtitle: Text(output.createdAt.toString()),
          title: Text('${output.elements.toString()}'),
        ),
      ),
    );
  }
}



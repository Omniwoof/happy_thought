import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


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
      appBar: AppBar(title: Text('Happy Thought')),
      body: ListPollsPage(),
    );
  }

}

class PollPage extends StatefulWidget {
  final Polls poll;

  PollPage({Key key, @required this.poll}) : super(key: key);


  @override
  State<StatefulWidget> createState() {

    return _PollState();
  }

}

class _PollState extends State<PollPage> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Poll Page'),),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex:1),
            Slider(
                label: widget.poll.slideVal.toInt().toString(),
                min: widget.poll.min.toDouble(),
                max: widget.poll.max.toDouble(),
                divisions: widget.poll.max.toInt(),
                value: widget.poll.slideVal,
                onChanged: (val) {
              setState(() => widget.poll.slideVal = val);
            },
            ),
            RaisedButton(
              child: Text(widget.poll.button),
              onPressed: () =>
                    Firestore.instance.collection('results')
                        .document().setData(
                        {
                          'created_at': FieldValue.serverTimestamp(),
                          'pollID': widget.poll.polls.documentID,
                          'val': widget.poll.slideVal,
                        }),
            ),
            Spacer(flex:1),
          ],
        ),
      )

      
    );
  }

  Widget _buildPoll(BuildContext context, DocumentSnapshot poll) {
    return Padding(
      padding: EdgeInsets.all(10.0),

    );
  }

}




class ListPollsPage extends StatefulWidget {

  @override
  _ListPollsPageState createState() => _ListPollsPageState();
}

class _ListPollsPageState extends State<ListPollsPage> {
//  double slideVal = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
//      appBar: AppBar(title: Text('Happy Thought')),
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
//        Flexible(
//          flex: 2,
//          child: _buildOuput(context),
//        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('polls').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
//        print(snapshot.data.documents.toList());
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
    final poll = Polls.fromSnapshot(data);
//    double slideVal = record.val;
    Widget buildListTile() {
      if (poll.max != null && poll.max > poll.min && poll.min != null) {
//        return Slider(
//            label: poll.title,
//            min: poll.min,
//            max: poll.max,
//            divisions: poll.max.toInt(),
//            value: slideVal,
//            onChanged: (val) {
//          setState(() => slideVal = val);
//        },
//        );
          return ListTile(
//            title: Text(record.title),
            title: Column(
              children: <Widget>[
                Text(poll.polls.documentID),
                Text("poll.test "+poll.test.toString()),
              ],
            ),
            subtitle: RaisedButton(
              child: Text(poll.title),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => PollPage(poll: poll)
                  ),
                );
              },
//                onPressed: () =>
//                    Firestore.instance.collection('results')
//                        .document().setData(
//                        {
//                          'created_at': FieldValue.serverTimestamp(),
//                          'pollID': record.reference.documentID,
//                          'val': slideVal,
//                        })
            ),
          );
      }
      else {
        return ListTile(
//            title: Text(record.title),
          title: Column(
            children: <Widget>[
              Text(poll.polls.documentID + " : " + poll.test),
            ],
          ),
          subtitle: RaisedButton(
            child: Text(poll.title),
                onPressed: () =>
                    Firestore.instance.collection('results')
                        .document().setData(
                        {
                          'created_at': FieldValue.serverTimestamp(),
                          'pollID': poll.polls.documentID,
//                          'val': slideVal,
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

}

class ShowResults extends StatelessWidget{

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Poll'),
      ),
      body: Center(
        child: _buildOuput(context),
      ),
    );

  }


  _buildOuput(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('results').snapshots(),
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
    final output = Output.fromSnapshot(data);

    return Padding(
      key: ValueKey(output.pollID),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
//          trailing: Text(output.createdAt.toString()),
          subtitle: Text(output.pollID),
          title: Text(output.createdAt.toString()),
          trailing: Text(output.sVal.toString()),
//              onTap: () => print(data.data.toString()),
        ),
      ),
    );

  }


}

//void setVal(val) {
//  slideVal = val;
//}

class Polls {
  final String title;
  final String button;
  final String test;
  final double val;
  final double max;
  final double min;
  double slideVal;
  final DocumentReference polls;

  Polls.fromMap(Map<String, dynamic> map, {this.polls})
  // May not be a good idea to use an Initalizer list.
      : assert(map['title'] !=null),
        assert(map['button'] !=null),
        test = 'Polls Class',
        title = map['title'],
        button = map['button'],
  // TODO: Check if this is a good pattern. Assigns variable if not null.
        max = map['max']?.toDouble(),
        min = map['min']?.toDouble(),
        slideVal = map['min']?.toDouble(),
        val = map['min']?.toDouble();

  Polls.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, polls: snapshot.reference);


}

class Poll {
  //How to implement dynamic forms!
  //1) Create a class for each element: Button, Slider and Multi
  //2) When a poll is selected iterate over the fields and create form fields
  //for each element.
  //The top level poll class should have a list of elements (Maps) that describe
  //the structure of each poll. Eg: List<Element>[{type: Basic, title: 'Name'},
  // {type: Slider, max: 10, min: 0}, {type: Multi, choices: {choice1: 'Choice1'
  // , choice2: 'Choice2'}}] etc
  final DocumentReference reference;
  static Map<String, dynamic> polls = Map<String, dynamic>();

  factory Poll (polls){
    return null;
  }

}

class Output {
  final DateTime createdAt;
  final String pollID;
  final double sVal;
  final DocumentReference output;

  Output.fromMap(Map<String, dynamic> map, {this.output})
  :
//      : assert(map['created_at'] !=null),
//        assert(map['pollID'] !=null),
//        assert(map['val'] !=null),
        createdAt = map['created_at'],
        pollID = map['pollID'],
        sVal = map['val'];

  Output.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, output: snapshot.reference);

}


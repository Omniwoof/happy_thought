import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'polls_model.dart';
import 'results_model.dart';

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

class ShowResults extends StatelessWidget{
  final Poll poll;

  ShowResults({Key key, @required this.poll}) : super(key: key);

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
//          trailing: Text(output.createdAt.toString()),
//          trailing: Text(output.pollID),
          subtitle: Text(output.createdAt.toString()),
          title: Text('${output.elements.toString()}'),
//              onTap: () => print(data.data.toString()),
        ),
      ),
    );
  }
}



class PollElement extends StatefulWidget {
  final Poll poll;

  PollElement({Key key, @required this.poll}) {}


  @override
  State<StatefulWidget> createState() {
    return PollElementsState();
  }

}

class PollElementsState extends State<PollElement> {
  Map<String, dynamic> formState;

  callback(Map<String, dynamic> newState){
    if(formState != null){
      formState.addAll(newState);
    }
    else {
      formState = newState;
    }
  print('newState: $newState formState: $formState');
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.poll.title;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildPoll(),
    );
  }

   buildPoll(){

//
    return Column(
      children: <Widget>[
        buildElements(),
        submitButton(),
      ],
    );
  }

  buildElements(){
    final List elements = List();
    Map <dynamic, dynamic> allElements = widget.poll.elements;
    allElements.forEach((key, value) => elements.add(value));

    return Expanded(
      child: ListView.builder(
          itemCount: allElements.length,
          itemBuilder: (context, index) {
//          print('element: '+elements[index].toString());
            final elem = ElementSlider.fromElement(index, elements[index]);

            if (elem.type == 'slider') {

              return Element(element: elements[index], callback: callback, formState: formState,);
            } else if (elem == null) {
              print('Elem Null!');
              return ListTile(
                  title: Text('ELEM type = null!'),
              );
            }
          }
      ),
    );

  }

  submitButton(){
    String button = widget.poll.button;
    return Expanded(
      child: RaisedButton(
        onPressed: () => Firestore.instance.collection('results')
        .document().setData(
        {
          'created_at': FieldValue.serverTimestamp(),
          'pollID': widget.poll.polls.documentID,
          'elements' : formState,
        }),
        child: Text(button),
      ),
    );
  }
}

class Element extends StatefulWidget {
  final element;
  double slideVal;
  var formState;
  Function(Map <String, dynamic>) callback;

  Element({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
  this.slideVal = 0.0;
  }


  @override
  State<StatefulWidget> createState() {
    return ElementState();
  }

}

class ElementState extends State<Element> {
  stateCallback(String title, num value) {
    print("{title : $title, value: $value}");
    return {title : title, value: value};
  }
//  callback(var a) {print(a);}

  @override
  Widget build(BuildContext context) {
  return elementTile(widget.element);
  }

  elementTile(element){
    var elem = ElementSlider.fromMap(element, element);
//    widget.callback({elem.title: 0.0});

    return ListTile(
      title: Text(elem.title),
      subtitle: Slider(
        value: widget.slideVal,
        onChanged: (newValue) {
          setState(() {
            Map<String, dynamic> newState = {elem.title: newValue.round()};
            widget.slideVal = newValue;
            widget.callback(newState);
          });
        },
        min: elem.min,
        max: elem.max,
        divisions: elem.max.toInt(),
        label: widget.slideVal.floor().toString(),

      ),
      leading: Text('Val: ${widget.slideVal.round()}'),
    );
  }

}


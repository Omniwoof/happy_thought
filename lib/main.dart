import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'results_page.dart';

import 'polls_model.dart';

import 'radio_element.dart';
import 'slider_element.dart';
import 'checkbox_element.dart';

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


class PollElement extends StatefulWidget {
  final Poll poll;

  PollElement({Key key, @required this.poll}) {}


  @override
  State<StatefulWidget> createState() {
    return PollElementsState();
  }

}

class PollElementsState extends State<PollElement> {
  Map<String, Map<String, dynamic>> formState = {};


  callback(Map<dynamic, dynamic> newState){

    if (newState.keys.contains('checkbox') && formState.keys.contains('checkbox')){
      Map <String, dynamic> checkboxState = newState['checkbox'];
      formState['checkbox'].addAll(checkboxState);
    }
    else if (newState.keys.contains('checkbox') && !formState.keys.contains('checkbox')){
      formState.addAll(newState);
    }
    else if (newState.containsKey('radio')) {
      Map <String, dynamic> radioState = newState['radio'];
      formState['radio'] = radioState;
    }
    else if (newState.containsKey('slider') && formState.keys.contains('slider')) {
      Map <String, dynamic> sliderState = newState['slider'];
      formState['slider'].addAll(sliderState);
    }
    else if (newState.containsKey('slider') && !formState.keys.contains('slider')) {
      formState.addAll(newState);
    }
    else if (formState.length == 0){
    formState = newState;
    }
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
    print('All elems' + allElements.toString());
    print('FormState : $formState');

    return Expanded(
      child: ListView.builder(
          itemCount: allElements.length,
          itemBuilder: (context, index) {
            final elem = ElementSlider.fromElement(index, elements[index]);
            final elemtype = elements[index]['type'];
            print ('Elemtype: ${elemtype}');

            if (elemtype == 'slider') {

              return SliderElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if(elemtype == 'checkbox') {
              return CheckboxElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if (elemtype == 'radio') {
              return RadioElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if (elem == null) {
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
    //TODO: Add validation
    String button = widget.poll.button;
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200.0),
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


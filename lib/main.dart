import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

//import 'poll_builder.dart';
import 'polls_model.dart';
import 'results_model.dart';
import 'buildSlider.dart';

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

//  Widget _buildPoll(BuildContext context, DocumentSnapshot poll) {
//    return Padding(
//      padding: EdgeInsets.all(10.0),
//
//    );
//  }

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
    final poll = Polls.fromSnapshot(data);
    Widget buildListTile() {
      if (poll.max != null && poll.max > poll.min && poll.min != null){
          return ListTile(
            title: Column(
              children: <Widget>[
                Text(poll.polls.documentID),
                Text("poll.test "+poll.test.toString()),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () => _goResults(poll),
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
            ),
          );
      }
      if (poll.elements != null){
//        Map<dynamic, dynamic> test = poll.elements;
//        Map<String, dynamic> element = poll.getElements(poll.elements);
//        print('Elements not null. ${poll.elements}');
//        Widget listy = ListTile();
//
//        test.forEach((x,y) {
//          print('X: ${x.toString()} Y: ${y.toString()}');
//          listy = ListTile(
//            title: Text(y.toString()),
//          );
//        });
//        return listy;
        return ListTile(
          title: RaisedButton(
              child: Text(poll.title),
              onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => Poll(poll: poll))
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
  final Polls poll;

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
          subtitle: Text(output.pollID),
          title: Text(output.createdAt.toString()),
          trailing: Text(output.sVal.toString()),
//              onTap: () => print(data.data.toString()),
        ),
      ),
    );

  }


}



class Poll extends StatefulWidget {
  final Polls poll;
//  var slideVal;
//  final ElementSlider elem;
//
//
//  ElementSlider({Key key, @required this.elem}) {
//    this.elem = poll.elements.forEach((key, value) => );
//  };


  Poll({Key key, @required this.poll}) {
//  poll.elements.forEach((key, element) {
//    ElementSlider.fromElement(key, element);
//    this.slideVal = 6.0;
//  } );
}


  @override
  State<StatefulWidget> createState() {
//    poll.elements.forEach((key, value) => print('pollele: $key $value'));
    return _PollElementsState();
  }

}

class _PollElementsState extends State<Poll> {

//  double sliderVal = 4.0;
//
//  _initSliderVal()
//  {this.sliderVal = 9.0;}

  @override
  Widget build(BuildContext context) {
    String title = widget.poll.title;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildPoll(),
    );
  }

   _buildPoll(){
     String button = widget.poll.button;
//
    return Container(
      child: _buildElements()
    );
  }

  _buildElements(){
    final List elements = List();
    Map <dynamic, dynamic> allElements = widget.poll.elements;
    allElements.forEach((key, value) => elements.add(value));

    return ListView.builder(
        itemCount: allElements.length,
        itemBuilder: (context, index) {
          print('element: '+elements[index].toString());
          final elem = ElementSlider.fromElement(index, elements[index]);

          if (elem.type == 'slider') {

            return Element(element: elements[index]);
          } else if (elem == null) {
            print('Elem Null!');
            return ListTile(
                title: Text('ELEM type = null!'),
            );
          }
        }
    );

  }

}

class Element extends StatefulWidget {
  final element;
  var slideVal;

  Element({Key key, @required this.element}) : super (key : key) {
  this.slideVal = 3.0;
  }

  @override
  State<StatefulWidget> createState() {
    return _ElementState();
  }

}

class _ElementState extends State<Element> {

  @override
  Widget build(BuildContext context) {
    String title = widget.element.toString();

//    return Text(title);
  return _elementTile(widget.element);
  }

  _elementTile(element){
    var elem = ElementSlider.fromMap(element, element);

    return ListTile(
      title: Text(elem.title),
      subtitle: Slider(
        value: widget.slideVal,
        onChanged: (newValue) {
          setState(() {
            print('newValue: $newValue');
            widget.slideVal = newValue;
//                      elem.setVal(newValue);
            print('New slideVal: ${widget.slideVal}');
          });
        },
        min: elem.min,
        max: elem.max,
        label: widget.slideVal.floor().toString(),

      ),
      leading: Text('Val: ${widget.slideVal.round()}'),
    );
  }
}


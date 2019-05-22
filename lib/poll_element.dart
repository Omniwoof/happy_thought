import 'package:flutter/material.dart';
import 'polls_model.dart';
import 'slider_element.dart';
import 'radio_element.dart';
import 'checkbox_element.dart';
import 'switch_element.dart';
import 'textfield_element.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibrate/vibrate.dart';

class PollElement extends StatefulWidget {
  final Poll poll;
  final String pollID;

  PollElement({Key key, this.poll, this.pollID});


  @override
  State<StatefulWidget> createState() {
    return PollElementsState();
  }

}

class PollElementsState extends State<PollElement> {
  Map<String, Map<String, dynamic>> formState = {};
  static AudioCache player = new AudioCache();




  callback(Map<dynamic, dynamic> newState){
    player.load('chime.wav');

    if (newState.keys.contains('checkbox') && formState.keys.contains('checkbox')){
      Map <String, dynamic> checkboxState = newState['checkbox'];
      formState['checkbox'].addAll(checkboxState);
    }
    else if (newState.keys.contains('checkbox') && !formState.keys.contains('checkbox')){
      formState.addAll(newState);
    }
    else if (newState.containsKey('radio') && formState.keys.contains('radio')) {
      Map <String, dynamic> radioState = newState['radio'];
      formState['radio'].addAll(radioState);
    }
    else if (newState.containsKey('radio') && !formState.keys.contains('radio')) {
      //TODO: Fix radio button update to work with groups of radio buttons.
      Map <String, dynamic> radioState = newState['radio'];
      formState['radio'] = radioState;
    }
    else if (newState.containsKey('switch') && formState.keys.contains('switch')) {
      Map <String, dynamic> switchState = newState['switch'];
      formState['switch'].addAll(switchState);
    }
    else if (newState.containsKey('switch') && !formState.keys.contains('switch')) {
      Map <String, dynamic> switchState = newState['switch'];
      formState['switch'] = switchState;
    }
    else if (newState.containsKey('slider') && formState.keys.contains('slider')) {
      Map <String, dynamic> sliderState = newState['slider'];
      formState['slider'].addAll(sliderState);
    }
    else if (newState.containsKey('slider') && !formState.keys.contains('slider')) {
      formState.addAll(newState);
    }
    else if (newState.containsKey('text') && formState.keys.contains('text')) {
      Map <String, dynamic> textState = newState['text'];
      formState['text'].addAll(textState);
    }
    else if (newState.containsKey('text') && !formState.keys.contains('text')) {
      formState.addAll(newState);
    }
    else if (formState.length == 0){
      formState = newState;
    }
    print('Formstate: $formState');
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.poll.title;

    return Scaffold(

      backgroundColor: Color.fromARGB(255, 242, 221, 169),
      appBar: AppBar(title: Text(title)),
      body: buildPoll(),
    );
  }

  buildPoll(){

//
    return Center(
      child: Card(
        margin: EdgeInsets.all(16.0),
        color: Color.fromARGB(255, 51, 102, 153),
        elevation: 8.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: buildElements(),),
            submitButton(),
          ],
        ),
      ),
    );
  }

  buildElements(){
    final List elements = List();
    Map <dynamic, dynamic> allElements = widget.poll.elements;
    allElements.forEach((key, value) => elements.add(value));


    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.red, width: 2.0)
        )
      ),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          itemCount: allElements.length,
          itemBuilder: (context, index) {
            final elem = ElementSlider.fromElement(index, elements[index]);
            final elemtype = elements[index]['type'];

            if (elemtype == 'slider') {

              return SliderElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if(elemtype == 'checkbox') {
              return CheckboxElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if (elemtype == 'radio') {
              return RadioElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if (elemtype == 'switch') {
              return SwitchElement(element: elements[index], callback: callback, formState: formState,);
            }
            else if (elemtype == 'text') {
              return TextElement(element: elements[index], callback: callback, formState: formState,);
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
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: MaterialButton(
        color: Colors.white,
        elevation: 8.0,
        onPressed: () {
          submitForm();
          _showSubmitSuccess();
//              .catchError((errorMessage) {
//                print('Submission failed: $errorMessage');
//                showSubmitFailure();
//              })
//              .then(_showSubmitSuccess());
        },
        child: Text(button,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 20.0)
        ),
      ),
    );
  }

  submitForm() async {

      await Firestore.instance.collection('polls')
          .document(widget.poll.polls.documentID)
          .collection('results')
          .document().setData(
        {
          'created_at': FieldValue.serverTimestamp(),
          'pollID': widget.poll.polls.documentID,
          'elements' : formState,
        });
  }

  _showSubmitSuccess() {
    print('Show Submit Success');
    player.play('chime.wav');
    Vibrate.vibrate();
//    Navigator.of(context).pop();


    Future.delayed(Duration(milliseconds: 250), (){
      Navigator.of(context).pop();
    });
  }

  showSubmitFailure() {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 48.0,
              color: Colors.red,
              child: Center(
                  child: Text('Failed to submit answer. Please check network connection and try again.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0))
              )
          );
        }
    );
  }

}
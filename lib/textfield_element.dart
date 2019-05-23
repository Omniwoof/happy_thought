import 'package:flutter/material.dart';

class TextElement extends StatefulWidget {
  final Map<dynamic, dynamic> element;
//  final Map<String, bool> choices = Map();
  final Map<String, String> textChoices = Map();
  final formState;
  final Function(Map <dynamic, dynamic>) callback;


  TextElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
    if (element.containsValue('text')){
      print("Element: $element");

      textChoices.addAll({element['title']: element['type']});
      print('ADDED!');
    };
    }


  @override
  State<StatefulWidget> createState() {return TextElementState();}
}


class TextElementState extends State<TextElement> {
  final textContoller = TextEditingController();


  @override
  void initState() {
    super.initState();
        textContoller.addListener(sendToForm);
  }

  @override
  void dispose() {
    textContoller.dispose();
    super.dispose();
  }

  sendToForm() {
    Map<String, Map<String, String>> textMap = {'text' : {widget.element['title'] : textContoller.text}};
    widget.callback(textMap);
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//      decoration: BoxDecoration(
//        border: Border(
//          bottom: BorderSide(color: Colors.white, width: 2.0)
//        )
//      ),
      child: TextField(
        style: new TextStyle(color: Colors.white),
        controller: textContoller,
        //Expands textfield as input hits end of line
        maxLines: null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)
          ),
          labelText: widget.element['title'],
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
          fillColor: Colors.white,
//          border: OutlineInputBorder(borderRadius: BorderRadius.all(,Radius.circular(10.0))),
        //TODO: Either replace or remove hintext withs something more appropriate.
          hintText: 'Type away!',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
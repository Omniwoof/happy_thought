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
    return Column(
      children: <Widget>[
        Text(widget.element['title']),
        TextField(
          controller: textContoller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            hintText: 'Type away!',
          ),
        )
      ],
    );
  }
}
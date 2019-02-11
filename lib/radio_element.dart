import 'package:flutter/material.dart';

class RadioElement extends StatefulWidget {
  Map<dynamic, dynamic> element;
  Map<String, bool> choices = Map();
  Map<String, int> radioChoices = Map();
  var formState;
  Function(Map <dynamic, dynamic>) callback;


  RadioElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
    if (element.containsValue('radio')){element['choices'].forEach((key, value) {
      radioChoices.addAll({value : int.parse(key)});
    });
    //Creates default value for radio button in formState.
    Map <String, Map <String, dynamic>> radioValue = {element['type'] : {'0' : element['choices']['0']}};
      callback(radioValue);
    }
  }


  @override
  State<StatefulWidget> createState() {return RadioElementState();}
}


class RadioElementState extends State<RadioElement> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.element['title']),
        ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: widget.radioChoices.keys.map((String key){
              return RadioListTile(
                  title: Text(key),
                  value: widget.radioChoices[key],
                  groupValue: _selected,
                  onChanged: (int value) {
                    setState(() {
                      _selected = value;
                      widget.callback({widget.element['type']:{key: value}});
                    });
                  }
              );
            },).toList()
        ),
      ],
    );
  }
}
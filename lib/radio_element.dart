import 'package:flutter/material.dart';

class RadioElement extends StatefulWidget {
  final Map<dynamic, dynamic> element;
  final Map<String, bool> choices = Map();
  final Map<String, int> radioChoices = Map();
  final formState;
  final Function(Map <dynamic, dynamic>) callback;


  RadioElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
    if (element.containsValue('radio')){element['choices'].forEach((key, value) {
      radioChoices.addAll({value : int.parse(key)});
      print('Radiochoices: $radioChoices');

      //Creates default value for radio button in formState.
      Map <String, Map <String, dynamic>> radioValue = {element['type'] : {'0' : element['choices']['0']}};
      callback(radioValue);
//      print('Radiovalue: $radioValue');
    });
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
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            color: Color.fromARGB(64, 18, 35, 53),
//            width: 300.0,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(widget.element['title'], style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0)),
            ),
          ),
        ),
        ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: widget.radioChoices.keys.map((String key){
              return RadioListTile(
                  title: Text(key, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0)),
                  value: widget.radioChoices[key],
                  groupValue: _selected,
                  activeColor: Colors.red,
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
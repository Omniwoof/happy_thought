import 'package:flutter/material.dart';

class CheckboxElement extends StatefulWidget {
  Map<dynamic, dynamic> element;
  Map<String, bool> choices = Map();
  var formState;
  Function(Map <dynamic, dynamic>) callback;


  CheckboxElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
    element['choices'].forEach((key, value) => choices.addAll({value : false}));
//    print('Choices ${choices}');
  }

  @override
  State<StatefulWidget> createState() {return CheckboxElementState();}
}


class CheckboxElementState extends State<CheckboxElement> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.element['title']),
        ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: widget.choices.keys.map((String key){
              return CheckboxListTile(
                  title: Text(key),
                  value: widget.choices[key],
                  onChanged: (bool value) {
                    setState(() {
                      Map <String, Map<String, dynamic>> newValue = {widget.element['type']:{key : value}};
                      widget.choices[key] = value;
//                    print('Value: ${key}:$value');
                      widget.callback(newValue);
                    });
                  }
              );
            },).toList()
        ),
      ],
    );
  }
}

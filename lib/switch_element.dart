import 'package:flutter/material.dart';

class SwitchElement extends StatefulWidget {
  final Map<dynamic, dynamic> element;
  final Map<String, bool> choices = Map();
  final Map<String, String> switchChoices = Map();
  final formState;
  final Function(Map <dynamic, dynamic>) callback;


  SwitchElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
    if (element.containsValue('switch')){
      print("Element: $element");

       switchChoices.addAll({element['title']: element['type']});
       print('ADDED!');

    };
    //Creates default value for switch in formState.
    Map <String, Map <String, dynamic>> switchValue = {element['type'] : {element['title'] : false}};
    callback(switchValue);
    }



  @override
  State<StatefulWidget> createState() {return SwitchElementState();}
}


class SwitchElementState extends State<SwitchElement> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.element['title']),
        ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: widget.switchChoices.keys.map((String key){
              return SwitchListTile(
                  title: Text(key),
                  value: switchValue,
//                  groupValue: _selected,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      switchValue = value;
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
import 'package:flutter/material.dart';

class CheckboxElement extends StatefulWidget {
  final Map<dynamic, dynamic> element;
  final Map<String, bool> choices = Map();
  final formState;
  final Function(Map <dynamic, dynamic>) callback;


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
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            color: Color.fromARGB(64, 18, 35, 53),
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(widget.element['title'], style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),),
            ),
          ),
        ),
        ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            children: widget.choices.keys.map((String key){
              return CheckboxListTile(
                activeColor: widget.choices[key] ? Colors.red : Colors.white,
                  title: Text(key, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      ),),
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

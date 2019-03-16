import 'package:flutter/material.dart';
import 'polls_model.dart';


class SliderElement extends StatefulWidget {
  final element;
  final formState;
  final Function(Map <dynamic, dynamic>) callback;

  SliderElement({Key key, @required this.element, this.callback, this.formState}) : super (key : key) {
//    this.slideVal = 0.0;
  }


  @override
  State<StatefulWidget> createState() {
    return SliderElementState();
  }

}

class SliderElementState extends State<SliderElement> {
  double slideVal = 0.0;

  @override
  Widget build(BuildContext context) {
    return elementTile(widget.element);
  }

  elementTile(element){
    var elem = ElementSlider.fromMap(element, element);

    return Column(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            color: Color.fromARGB(64, 18, 35, 53),
//          width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(elem.title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0)),
            ),
          ),
        ),
        ListTile(
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
            child: Slider(
//        activeColor: Color.fromARGB(255, 242, 221, 169),
//        inactiveColor: Color.fromARGB(255, 242, 221, 169),
              value: slideVal,
              onChanged: (newValue) {
                setState(() {
                  Map<String, Map<String, dynamic>> newState = {widget.element['type']:{elem.title: newValue.round()}};
                  slideVal = newValue;
                  widget.callback(newState);
                });
              },
              min: elem.min,
              max: elem.max,
              divisions: elem.max.toInt(),
              label: slideVal.floor().toString(),

            ),
          ),
//      leading: Text('Val: ${slideVal.round()}', style: TextStyle(
//          fontWeight: FontWeight.bold,
//          color: Colors.white,
//          fontSize: 20.0)),
        ),
      ],
    );
  }

}
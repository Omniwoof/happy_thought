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

    return ListTile(
      title: Text(elem.title),
      subtitle: Slider(
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
      leading: Text('Val: ${slideVal.round()}'),
    );
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';

class Polls {
  final String title;
  final String button;
  final String test;
  final DocumentReference polls;
  final Map <dynamic, dynamic> elements;
  double val;
  double max;
  double min;
  double slideVal;


  Polls.fromMap(Map<String, dynamic> map, {this.polls})
  // May not be a good idea to use an Initalizer list.
      : assert(map['title'] !=null),
        assert(map['button'] !=null),
        test = 'Polls Class',
        title = map['title'],
        button = map['button'],
        elements = map['elements'],
  // TODO: Check if this is a good pattern. Assigns variable if not null.
        max = map['max']?.toDouble(),
        min = map['min']?.toDouble(),
        slideVal = map['min']?.toDouble(),
        val = map['min']?.toDouble();



  Polls.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, polls: snapshot.reference);



  getElements(elem) {
    elem.forEach((key, element) {
      if(element['type'] == 'slider'){
        print('subElement: ${element}, key =$key');
        var newElement = ElementSlider.fromElement(key, element);
        return newElement;
      }
    });

  }

  buildSlider(key, element){
//    print('Element: ${element['max']}');
//    max = element['max']?.toDouble();
//    min = element['min']?.toDouble();
//    slideVal = min;
//    val = min;
  var newElement = ElementSlider.fromElement(key, element);
//    return print('Build Slider: $max : $min');
  }
}

class ElementSlider{
  final Map <dynamic, dynamic> element;
  final double val;
  final double max;
  final double min;
  final String title;
  final String type;
  double slideVal;

  ElementSlider.fromMap(key, Map<dynamic, dynamic> map, {this.element})
    : max = map['max'].toDouble(),
      min = map['min'].toDouble(),
      slideVal = 0.0,
      val= map['min'].toDouble(),
      title = map['title'],
      type = map['type']
  {print('slideVal: $slideVal');}

  ElementSlider.fromElement(key, element)
    : this.fromMap(key, element, element: element);

  setVal(double value) {
    slideVal =  value;
  }

}
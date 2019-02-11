import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  final String title;
  final String button;
  final String test;
  final DocumentReference polls;
  final Map <dynamic, dynamic> elements;


  Poll.fromMap(Map<String, dynamic> map, {this.polls})
      : assert(map['title'] !=null),
        assert(map['button'] !=null),
        test = 'Polls Class',
        title = map['title'],
        button = map['button'],
        elements = map['elements'];


  Poll.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, polls: snapshot.reference);

}

class ElementSlider{
  final Map <dynamic, dynamic> element;
  final double max;
  final double min;
  final String title;
  final String type;

  ElementSlider.fromMap(key, Map<dynamic, dynamic> map, {this.element})
    : max = map['max']?.toDouble(),
      min = map['min']?.toDouble(),
      title = map['title'],
      type = map['type'];

  ElementSlider.fromElement(key, element)
    : this.fromMap(key, element, element: element);

//  }

}
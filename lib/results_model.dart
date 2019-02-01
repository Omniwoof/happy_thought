import 'package:cloud_firestore/cloud_firestore.dart';


class Results {
  final DateTime createdAt;
  final String pollID;
  final double sVal;
  final Map<dynamic, dynamic> elements;
  final DocumentReference output;

  Results.fromMap(Map<String, dynamic> map, {this.output})
      :
//      : assert(map['created_at'] !=null),
//        assert(map['pollID'] !=null),
//        assert(map['val'] !=null),
        createdAt = map['created_at'],
        pollID = map['pollID'],
        sVal = map['val'],
        elements = map['elements'];

  Results.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, output: snapshot.reference);

}

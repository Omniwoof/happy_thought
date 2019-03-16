import 'package:cloud_firestore/cloud_firestore.dart';


class Schedule {
  final DocumentReference schedule;
  final String pollId;
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final String dayOfWeek;
  final String repeat;

  Schedule.fromMap(Map<String, dynamic> map, {this.schedule})
      : assert(map['pollId'] !=null),
        pollId = map['pollId'],
        year = map['year'],
        month = map['month'],
        day = map['day'],
        hour = map['hour'],
        minute = map['minute'],
        dayOfWeek = map['dayOfWeek'],
        repeat = map['repeat'];


  Schedule.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, schedule: snapshot.reference);

}



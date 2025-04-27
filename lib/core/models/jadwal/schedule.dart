import 'package:flutter/material.dart';

class Schedule {
  final int id;
  final String timeStart;
  final String timeEnd;
  final String course;
  final String classroom;
  final String teacher;
  final int day;

  Schedule({
    required this.id,
    required this.timeStart, 
    required this.timeEnd, 
    required this.course, 
    required this.classroom,
    required this.teacher, 
    required this.day, 
    });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      course: json['subject']?['name'],
      classroom: json['classroom']?['name'],
      teacher: json['employee']?['fullname'],
      day: json['day'],
    );
  }

  String get formattedTimeStart {
    final time = TimeOfDay(
      hour: int.parse(timeStart.split(':')[0]),
      minute: int.parse(timeStart.split(':')[1]),
    );
    return _formatTime(time);
  }

  String get formattedTimeEnd {
    final time = TimeOfDay(
      hour: int.parse(timeEnd.split(':')[0]),
      minute: int.parse(timeEnd.split(':')[1]),
    );
    return _formatTime(time);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime getScheduleDate(DateTime currentDate) {
    final today = currentDate.weekday;
    final daysDifference = (day - today) % 7;
    return currentDate.add(Duration(days: daysDifference));
  }
}
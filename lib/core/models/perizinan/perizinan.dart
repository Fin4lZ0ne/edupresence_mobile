import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Perizinan {
  final int id;
  final String status;
  final String type;
  final String description;
  final String document;
  final int dateStart;
  final int dateEnd;
  final int createdAt;
  final int updatedAt;

  Perizinan({
    required this.id,
    required this.status,
    required this.type,
    required this.description,
    required this.document,
    required this.dateStart,
    required this.dateEnd,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Perizinan.fromJson(Map<String, dynamic> json) {
    return Perizinan(
      id: json['id'],
      status: json['status'],
      type: json['type'],
      description: json['description'],
      document: json['document'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'type': type,
      'description': description,
      'document': document,
      'date_start': dateStart,
      'date_end': dateEnd,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get formattedDateStart => _formatDate(dateStart);
  String get formattedDateEnd => _formatDate(dateEnd);
  String get formattedCreatedAt => _formatDate(createdAt);
  String get formattedUpdatedAt => _formatDate(updatedAt);

  static String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  int get izinDuration {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(dateStart * 1000);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(dateEnd * 1000);
    return end.difference(start).inDays;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.grey;
    case 'accepted':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.black;
  }
}

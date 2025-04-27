import 'package:flutter/material.dart';

class LogPresensiCard extends StatelessWidget {
  final String subject;
  final String date;
  final String time;
  final String status;
  final Color statusColor;

  LogPresensiCard({
    required this.subject,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(date),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 5),
              Text(time),
            ],
          ),
          SizedBox(height: 5),
          Text('Status : $status'),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleTimeline extends StatefulWidget {
  final List<Schedule> scheduleList;
  const ScheduleTimeline({Key? key, required this.scheduleList})
      : super(key: key);

  @override
  State<ScheduleTimeline> createState() => _ScheduleTimelineState();
}

class _ScheduleTimelineState extends State<ScheduleTimeline> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    return Container(
      margin: const EdgeInsets.only(
        bottom: 35,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        children: [
          for (var schedule in widget.scheduleList)
            _buildScheduleRow(schedule, now),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(Schedule schedule, DateTime now) {
    final scheduleDate = schedule.getScheduleDate(now);
    final startTime  = DateTime(
      scheduleDate.year, scheduleDate.month, scheduleDate.day,
      int.parse(schedule.timeStart.split(':')[0]),
      int.parse(schedule.timeStart.split(':')[1]),
    );
    final endTime = DateTime(
      scheduleDate.year, scheduleDate.month, scheduleDate.day,
      int.parse(schedule.timeEnd.split(':')[0]),
      int.parse(schedule.timeEnd.split(':')[1]),
    );

    if (endTime.isBefore(startTime)) {
      endTime.add(Duration(days: 1));
    }

    final isActive = now.isAfter(startTime) && now.isBefore(endTime) && now.day == scheduleDate.day;

    return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule.formattedTimeStart,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                schedule.formattedTimeEnd,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFBCC1CD),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: 8),
                          _buildCard(
                            isActive ? LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0xFF66CCFF), Color(0xFF0099FF), Color(0xFF005B99)],
                          ) : null,
                          isActive ? Colors.white : Colors.grey.shade200,
                          schedule.course,
                          schedule.classroom,
                          schedule.teacher,
                          Icons.location_on_outlined,
                          CupertinoIcons.profile_circled,
                          isActive ? Colors.white : Colors.grey,
                          isActive ? Colors.grey : Colors.black,
                          isActive ? Colors.white : Colors.black,
                          isActive ? Colors.black : Colors.black,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildCard(
    Gradient? bgColorActive,
    Color bgColorInactive,
    String course,
    String classroom,
    String teacher,
    IconData pinIcon,
    IconData profileIcon,
    Color iconColorActive,
    Color iconColorInactive,
    Color textColorActive,
    Color textColorInactive,
  ) {

    final BoxDecoration decoration = BoxDecoration(
      color: bgColorActive != null ? null : bgColorInactive,
      gradient: bgColorActive,
      borderRadius: BorderRadius.circular(16),
    );

    return Expanded(
      child: Container(
        decoration: decoration,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: bgColorActive != null ? textColorActive : textColorInactive,
              ),
            ),
            SizedBox(height: 15),
            Row( // Baris untuk pinIcon dan room
              children: [
                Icon(
                  pinIcon,
                  size: 16,
                  color: bgColorActive != null ? iconColorActive : iconColorInactive,
                ),
                SizedBox(width: 10),
                Text(
                  classroom,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: bgColorActive != null ? textColorActive : textColorInactive,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              // Baris untuk profileIcon dan teacher
              children: [
                Icon(
                  profileIcon,
                  color: bgColorActive != null
                      ? iconColorActive
                      : iconColorInactive,
                  size: 16,
                ),
                SizedBox(width: 10),
                Text(
                  teacher,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: bgColorActive != null ? textColorActive : textColorInactive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget titlePage() {
  return Container(
    margin: const EdgeInsets.only(
      top: 40,
    ),
    child: Text(
      'Jadwal',
      style: blackTextStyle.copyWith(
        fontSize: 18,
        fontWeight: bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget date() {
  final now = DateTime.now();
  final formattedDate = DateFormat('d MMM yyyy').format(now);

  return Container(
    margin: const EdgeInsets.only(
      top: 15,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.4000000059604645),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    ),
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //Container box bertuliskan tanggal sekarang
            width: 156,
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 146,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '${formattedDate.split(' ')[0].padLeft(2, '0')}',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF202525),
                            fontSize: 44,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 61,
                        top: 11,
                        child: Text(
                          DateFormat('E').format(now),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 61,
                        top: 33,
                        child: Text(
                          DateFormat('MMM yyyy').format(now),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            //Container Box bertuliskan "Today"
            width: 83,
            height: 40,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 83,
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Opacity(
                          opacity: 0.10,
                          child: Container(
                            width: 83,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF338C65),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Text(
                            'Today',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF2E9769),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



Widget scheduleTitle() {
  return Container(
      margin: const EdgeInsets.only(
        top: 13,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time',
              style: GoogleFonts.poppins(
                color: Color(0xFFBCC1CD),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 34),
            Text(
              'Course',
              style: GoogleFonts.poppins(
                color: Color(0xFFBCC1CD),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Icon(
                Icons.sort_outlined,
                color: Color(0xFFBCC1CD),
              ),
            )
          ],
        ),
      ));
}


import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:edupresence_mobile/core/services/get_status_service.dart';

Widget buildCardStatusPresensi(BuildContext context, List<Schedule> schedules) {
  String currentDate =
      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

  Schedule? currentSchedule;
  DateTime now = DateTime.now();

  for (var schedule in schedules) {
    final startTime = TimeOfDay(
      hour: int.parse(schedule.timeStart.split(':')[0]),
      minute: int.parse(schedule.timeStart.split(':')[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(schedule.timeEnd.split(':')[0]),
      minute: int.parse(schedule.timeEnd.split(':')[1]),
    );

    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
      currentSchedule = schedule;
      break;
    }
  }

  return Container(
    width: double.infinity,
    height: 160,
    margin: const EdgeInsets.only(
      top: 26,
      left: 16,
      right: 16,
    ),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Presensi Saat Ini',
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: extrabold,
              ),
            ),
            Text(
              currentDate,
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: extrabold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        if (currentSchedule != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${currentSchedule.formattedTimeStart}-${currentSchedule.formattedTimeEnd}',
                style: blackTextStyle.copyWith(
                  fontSize: 19,
                  fontWeight: bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                currentSchedule.course,
                style: blackTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 30,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: GetStatusService().getStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Invalid',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: bold,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      final isActive = snapshot.data?['isActive'] ?? false;
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0099FF),
                        ),
                        child: Text(
                          isActive ? 'Presensi Akhir' : 'Presensi Awal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          )
        else
          Expanded(
            child: Center(
              child: Text(
                'Tidak ada presensi untuk saat ini',
                style: blackTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );
}

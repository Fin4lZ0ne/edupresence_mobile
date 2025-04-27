import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:flutter/material.dart'; 
import 'package:edupresence_mobile/shared/theme.dart';

Widget buildCardJadwalHariIni(List<Schedule> schedules) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(
      top: 26,
    ),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Jadwal Hari Ini',
          style: blackTextStyle.copyWith(
            fontSize: 12,
            fontWeight: extrabold,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        if (schedules.isNotEmpty)
          Column(
            children: schedules.map((schedule) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      schedule.course,
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      schedule.classroom,
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${schedule.formattedTimeStart} - ${schedule.formattedTimeEnd} WIB',
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          )
        else
          Center(
            child: Text(
              'Tidak ada jadwal untuk hari ini',
              style: blackTextStyle.copyWith(
                fontSize: 13,
                fontWeight: bold,
              ),
            ),
          ),
      ],
    ),
  );
}

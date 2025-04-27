// ignore_for_file: prefer_const_constructors

import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:edupresence_mobile/core/services/schedule_service.dart';
import 'package:edupresence_mobile/ui/pages/presensi_page.dart';
import 'package:edupresence_mobile/ui/widget/schedule/schedule_widget.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'perizinan_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  List<Schedule> _scheduleList = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _hasSchedule = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedulesForDate(_selectedDate);
  }

  void _fetchSchedulesForDate(DateTime date) async {
    setState(() {
      _isLoading = true;
      _hasSchedule = true;
    });

    try {
      final schedules = await ScheduleService.fetchSchedulesForDate(
          DateFormat('yyyy-MM-dd').format(date));
      setState(() {
        _scheduleList = schedules;
        _hasSchedule = schedules.isNotEmpty;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasSchedule = false;
      });
      print('Error fetching schedules: $error');
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _fetchSchedulesForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentBackground,
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 6,
        elevation: 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          elevation: 0,
          selectedItemColor: buttonActiveColor,
          unselectedItemColor: buttonDisableColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: blueTextStyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          unselectedLabelStyle: blackTextStyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          currentIndex:
              1, // Menandakan item terpilih, dalam hal ini indeks 1 untuk "Jadwal"
          onTap: (index) {
            if (index == 0) {
              // Jika item "Home" diklik, kembali ke halaman Home tanpa animasi
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            } else if (index == 2) {
              // Jika item "Jadwal" diklik, pindah ke halaman Jadwal tanpa animasi
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CalendarPage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            } else if (index == 3) {
              // Jika item "Perizinan" diklik, pindah ke halaman Perizinan tanpa animasi
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => PerizinanPage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/home.png',
                width: 24,
                color:
                    buttonDisableColor, // Karena bukan halaman utama, warna dinonaktifkan
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/jadwal.png',
                width: 24,
                color:
                    buttonActiveColor, // Item "Jadwal" dipilih, sehingga warnanya aktif
              ),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/kalender.png',
                width: 24,
                color:
                    buttonDisableColor, // Karena bukan halaman utama, warna dinonaktifkan
              ),
              label: 'Kalendar',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/perizinan.png',
                width: 24,
                color:
                    buttonDisableColor, // Karena bukan halaman utama, warna dinonaktifkan
              ),
              label: 'Perizinan',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ketika tombol floating button diklik, pindah ke halaman PresensiPage
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => PresensiPage(),
              transitionsBuilder: (_, __, ___, child) => child,
            ),
          );
        },
        backgroundColor: buttonActiveColor,
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/navbar/presensi.png',
          width: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        children: [
          titlePage(),
          date(),
          datePicker(_onDateSelected),
          scheduleTitle(),
          _isLoading
              ? Center(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : _hasSchedule
                  ? ScheduleTimeline(scheduleList: _scheduleList)
                  : Center(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Tidak ada jadwal',
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: bold
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

Widget datePicker(void Function(DateTime) onDateSelected) {
  return Container(
    margin: const EdgeInsets.only(
      top: 0,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0)),
    ),
    child: Container(
      height: 85,
      width: 60,
      child: DatePicker(DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: Color(0xFF0099FF),
          selectedTextColor: Colors.white,
          daysCount: 30,
          deactivatedColor: Colors.grey,
          dateTextStyle: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          dayTextStyle: GoogleFonts.poppins(
              fontSize: Dimen.dayTextSize, color: Colors.grey),
          monthTextStyle: GoogleFonts.poppins(
              fontSize: Dimen.monthTextSize,
              color: Colors.grey), onDateChange: (date) {
        onDateSelected(date);
      }),
    ),
  );
}

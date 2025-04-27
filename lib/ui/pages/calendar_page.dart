import 'package:edupresence_mobile/core/services/kalender_sevice.dart';
import 'package:edupresence_mobile/ui/pages/presensi_page.dart';
import 'package:edupresence_mobile/ui/widget/kalender/kalender_widget.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'perizinan_page.dart';
import 'jadwal_page.dart';
import 'home_page.dart';
import 'package:edupresence_mobile/core/models/calendar/calendar_model.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<GetHolidays> holidays = [];
  late Set<DateTime> holidayDates = {};
  bool isLoading = false;
  String? errorMessage;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchHolidays(focusedDay.month, focusedDay.year);
  }

  Future<void> fetchHolidays(int month, int year) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedHolidays = await CalendarService.fetchHolidays(month, year);
      setState(() {
        holidays = fetchedHolidays;
        filterHolidaysByMonth(focusedDay);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching holidays: $e';
        isLoading = false;
      });
    }
  }

  void filterHolidaysByMonth(DateTime date) {
    holidayDates = holidays
        .where((holiday) =>
            holiday.dateStart.year == date.year &&
            holiday.dateStart.month == date.month)
        .map((holiday) => holiday.dateStart)
        .toSet();
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomePage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => JadwalPage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            } else if (index == 3) {
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
                color: buttonDisableColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/jadwal.png',
                width: 24,
                color: buttonDisableColor,
              ),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/kalender.png',
                width: 24,
                color: buttonActiveColor,
              ),
              label: 'Kalender',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/perizinan.png',
                width: 24,
                color: buttonDisableColor,
              ),
              label: 'Perizinan',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (errorMessage != null)
                      Center(child: Text(errorMessage!))
                    else ...[
                      KalenderWidget(
                        focusedDay: focusedDay,
                        holidaysInMonth: holidays,
                        holidayDates: holidayDates,
                        filterHolidaysByMonth: filterHolidaysByMonth,
                        isToday: isToday,
                        onMonthChanged: (newDate) {
                          setState(() {
                            focusedDay = newDate;
                            fetchHolidays(newDate.month, newDate.year);
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

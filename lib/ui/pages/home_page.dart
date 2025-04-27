import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:edupresence_mobile/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:flutter/widgets.dart';
// import 'package:edupresence_mobile/ui/widget/home/profile_widget.dart';
import 'package:edupresence_mobile/ui/widget/home/status_presensi_widget.dart';
import 'package:edupresence_mobile/ui/widget/home/jadwal_hari_ini_widget.dart';
import 'package:edupresence_mobile/core/models/user.dart';
import 'package:get/get.dart';
import 'package:edupresence_mobile/core/controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'jadwal_page.dart';
import 'calendar_page.dart';
import 'perizinan_page.dart';
import 'presensi_page.dart';
import 'package:edupresence_mobile/core/services/schedule_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.put(AuthController());
  bool _isLoading = false;
  bool _hasSchedule = true;
  List<Schedule> _scheduleList = [];

  @override
  void initState() {
    super.initState();
    authController.loadUserFromPrefs(); // Load user data from SharedPreferences
    _fetchSchedulesForToday(DateTime.now());
  }

  void _fetchSchedulesForToday(DateTime date) async {
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
              0, // Menandakan item terpilih, dalam hal ini indeks 0 untuk "Home"
          onTap: (index) {
            if (index == 1) {
              // Jika item "Jadwal" diklik, pindah ke halaman Jadwal tanpa animasi
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => JadwalPage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
            } else if (index == 2) {
              // Jika item "Kalendar" diklik, pindah ke halaman Kalendar tanpa animasi
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
                    buttonActiveColor, // Item "Home" dipilih, sehingga warnanya aktif
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/jadwal.png',
                width: 24,
              ),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/kalender.png',
                width: 24,
              ),
              label: 'Kalendar',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/perizinan.png',
                width: 24,
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
      body: Obx(() {
        final user = authController.user.value;
        return ListView(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
          ),
          children: [
            buildProfile(context, user),
            _isLoading
              ? Center(
                  child: Container(
                    height: 160,
                    margin: const EdgeInsets.only(
                      top: 26,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : _hasSchedule
                  ? buildCardStatusPresensi(context, _scheduleList)
                  : Center(
                      child: Container(
                        height: 160,
                        margin: const EdgeInsets.only(
                          top: 26,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                'Tidak ada presensi untuk saat ini',
                                style: blackTextStyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            _isLoading
                ? Center(
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.only(
                        top: 26,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : _hasSchedule
                    ? buildCardJadwalHariIni(_scheduleList)
                    : Center(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(
                            top: 26,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Tidak ada jadwal untuk hari ini',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ],
        );
      }),
    );
  }
}

Widget buildProfile(BuildContext context, User user) {
  return Container(
    margin: const EdgeInsets.only(
      top: 40,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: whiteTextStyle.copyWith(
                fontSize: 19,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              user.fullname ?? 'Guest',
              style: whiteTextStyle.copyWith(
                fontSize: 19,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              user.nik ?? 'No NIK',
              style: whiteTextStyle.copyWith(
                fontSize: 10,
                fontWeight: semibold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: user.photos?.front != null
                    ? NetworkImage(user.photos!.front!)
                    : AssetImage('assets/home/profil_picture.png')
                        as ImageProvider, // URL gambar dari API atau gambar default
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

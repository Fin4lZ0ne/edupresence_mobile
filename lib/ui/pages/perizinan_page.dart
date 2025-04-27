// import 'dart:js';
import 'package:edupresence_mobile/ui/pages/pengajuan_izin.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'home_page.dart';
import 'jadwal_page.dart';
import 'calendar_page.dart';
import 'presensi_page.dart';
import 'package:edupresence_mobile/core/models/perizinan/perizinan.dart';
import 'package:edupresence_mobile/core/services/perizinan_service.dart';

class PerizinanPage extends StatefulWidget {
  const PerizinanPage({Key? key}) : super(key: key);

  @override
  State<PerizinanPage> createState() => _PerizinanPageState();
}

class _PerizinanPageState extends State<PerizinanPage> {
  List<Perizinan>? _excuses;
  bool _isLoading = true;
  bool _hasIzin = true;


  @override
  void initState() {
    super.initState();
    _fetchExcuses();
  }

  Future<void> _fetchExcuses() async {
    try {
      List<Perizinan> excuses = await PerizinanService().daftarIzin();
      setState(() {
        _excuses = excuses;
        _hasIzin = excuses.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasIzin = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Daftar Izin: $e')),
      );
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
          currentIndex: 3,
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
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CalendarPage(),
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
                color: buttonDisableColor,
              ),
              label: 'Kalendar',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/navbar/perizinan.png',
                width: 24,
                color: buttonActiveColor,
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        children: [
          tittlePage(),
          _isLoading
            ? Center(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : listIzin(context, _excuses, _hasIzin)
        ],
      ),
    );
  }
}

Widget tittlePage() {
  return Container(
    margin: const EdgeInsets.only(
      top: 40,
    ),
    child: Text(
      'Daftar Izin',
      style: blackTextStyle.copyWith(
        fontSize: 18,
        fontWeight: bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget listIzin(BuildContext context, List<Perizinan>? excuses, bool hasIzin) {
  bool hasIzin = excuses != null && excuses.isNotEmpty;

  return Container(
    margin: const EdgeInsets.only(
      top: 15,
      bottom: 35
    ),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PengajuanIzinPage()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              'Ajukan Izin Baru',
              style: blackTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: semibold
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        if (hasIzin)
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: excuses.length,
          itemBuilder: (context, index) {
            final excuse = excuses[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          excuse.type,
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tanggal Izin: ${excuse.formattedDateStart}',
                                style: blackTextStyle.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Status Izin',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4
                                  ), // Adding some spacing between the text
                                  Text(
                                    excuse.status,
                                    style: TextStyle(
                                      color: getStatusColor(excuse.status),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Lama Izin: ${excuse.izinDuration} Hari',
                          style: blackTextStyle.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      if (!hasIzin)
        Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.error, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Tidak ada data izin',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold
                )
              ),
            ],
          )
        )
      ],
    ),
  );
}

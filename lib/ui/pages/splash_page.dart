import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edupresence_mobile/shared/theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigasi ke halaman login atau home setelah 3 detik
    Future.delayed(Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('login') == true) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });

    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Lottie.asset(
          'assets/json/splash.json',
          width: 200, // Sesuaikan ukuran sesuai kebutuhan Anda
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

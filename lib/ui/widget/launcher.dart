// ignore_for_file: camel_case_types

import 'package:edupresence_mobile/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edupresence_mobile/ui/pages/home_page.dart';
import '../pages/splash_page.dart';

class launcher extends StatefulWidget {
  const launcher({Key? key}) : super(key: key);

  @override
  State<launcher> createState() => _launcherState();
}

class _launcherState extends State<launcher> {
  bool _showSplash = true;

  void cekPilihan() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('login') == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }));
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3500), () {
      setState(() {
        _showSplash = false;
      });

      cekPilihan();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox.expand(
          child: Image.asset(
            'assets/splash/logo_anim.gif',
            fit: BoxFit.cover, // Untuk menyesuaikan ke layar penuh
          ),
        ),
      );
    }
    return Container();
  }
}

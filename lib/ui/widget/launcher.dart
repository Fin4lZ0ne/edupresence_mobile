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
  void cekPilihan() async {
    final prefs = await SharedPreferences.getInstance();

    
      if (prefs.getBool('login') == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const LoginPage();
        }));
      }
  }

  @override
  void initState() {
    super.initState();
    cekPilihan();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
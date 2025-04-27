import 'package:edupresence_mobile/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edupresence_mobile/ui/pages/forgot_password_page.dart';
import 'package:edupresence_mobile/ui/pages/otp_page.dart';
import 'package:edupresence_mobile/ui/pages/reset_password_page.dart';
import 'package:edupresence_mobile/ui/pages/login_page.dart';

class RouteApp {
  static final pages = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/forgot-password', page: () => const ForgotPage()),
    GetPage(
      name: '/otp',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final username = args['username'] as String;
        final message = args['message'] as String;
        return OtpPage(username: username, message: message);
      },
    ),
    GetPage(
      name: '/reset-password',
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final username = args['username'] as String;
        final otp = args['otp'] as String;
        return ResetPasswordPage(username: username, otp: otp);
      },
    ),
    GetPage(name: '/home', page: () => const HomePage()),
  ];
}

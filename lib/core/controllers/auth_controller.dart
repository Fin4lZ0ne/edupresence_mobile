import 'dart:convert';
import 'package:edupresence_mobile/core/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:edupresence_mobile/core/services/auth_service.dart';
import 'package:edupresence_mobile/core/utils/constant.dart';

class AuthController extends GetxController {
  var user = User().obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs();
  }

  static Future<void> login(BuildContext context,
      TextEditingController username, TextEditingController password) async {
    try {
      if (username.text.isEmpty || password.text.isEmpty) {
        throw 'Username dan Password harus diisi.';
      }

      await AuthService.login(username.text, password.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('login', true);

      await getUser();

      Get.snackbar(
        'Success',
        'Login berhasil',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await Get.offAllNamed('/home'); // Clear navigation stack and go to home
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<void> logout(
      BuildContext context, SharedPreferences preferences) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('login');
      await prefs.remove('user'); // Hapus data pengguna dari shared preferences
      await AuthService.logout(preferences);
      Get.offAllNamed('/login');
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<void> getUser() async {
    try {
      String? token = await Constant.getToken();
      User? user = await AuthService.fetchUserData(token!);
      if (user != null) {
        final controller = Get.find<AuthController>();
        controller.user.value = user;
        controller.saveUserToPrefs(
            user); // Simpan data pengguna ke shared preferences
      } else {
        print('No user data fetched');
      }
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      user.value = User.fromJson(jsonDecode(userJson));
    }
  }

  Future<void> saveUserToPrefs(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }
}

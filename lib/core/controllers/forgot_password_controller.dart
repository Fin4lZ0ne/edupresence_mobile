import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/forgot_password_service.dart';

class ForgotPasswordController extends GetxController {
  static Future<void> requestOTP(
      BuildContext context, TextEditingController usernameController) async {
    try {
      if (usernameController.text.isEmpty) {
        throw 'Username harus diisi.';
      }

      // Dapatkan respons dari API dan simpan pesan
      final response =
          await ForgotPasswordService.requestOTP(usernameController.text);
      final message = response['meta']['message'];

      Get.snackbar(
        'Success',
        message,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigasi ke halaman OTP dengan username dan pesan sebagai argumen
      await Get.toNamed('/otp',
          arguments: {'username': usernameController.text, 'message': message});
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<void> verifyOTP(BuildContext context,
      TextEditingController otpController, String username) async {
    try {
      if (otpController.text.isEmpty) {
        throw 'OTP harus diisi.';
      }

      await ForgotPasswordService.verifyOTP(username, otpController.text);
      Get.snackbar(
        'Success',
        'OTP berhasil diverifikasi',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigasi ke halaman reset password dengan username dan otp sebagai argumen
      await Get.toNamed('/reset-password',
          arguments: {'username': username, 'otp': otpController.text});
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<void> resetPassword(
      BuildContext context,
      TextEditingController newPasswordController,
      String username,
      String otp) async {
    try {
      if (newPasswordController.text.isEmpty) {
        throw 'Password baru harus diisi.';
      }

      final response = await ForgotPasswordService.resetPassword(
          username, otp, newPasswordController.text);

      if (response['meta']['code'] == 200) {
        Get.snackbar(
          'Success',
          response['meta']['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigasi kembali ke halaman login setelah reset password
        await Get.offAllNamed('/login');
      } else {
        throw response['meta']['message'];
      }
    } catch (error) {
      print(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

import 'package:edupresence_mobile/ui/pages/reset_password_page.dart';
import 'package:edupresence_mobile/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/theme.dart';
import '../../core/controllers/forgot_password_controller.dart';

class OtpPage extends StatelessWidget {
  final String username;
  final String message; // Tambahkan ini

  const OtpPage(
      {super.key,
      required this.username,
      required this.message}); // Tambahkan ini

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          children: [
            Container(
              width: 150,
              height: 47,
              margin: const EdgeInsets.only(top: 100, bottom: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login/logo_title.png'),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 47,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login/logo_forgot.png'),
                ),
              ),
            ),
            Text(
              'Verifikasi OTP',
              textAlign: TextAlign.center,
              style: blackTextStyle.copyWith(
                fontSize: 27,
                fontWeight: black,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  message, // Tampilkan pesan dari API
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: superlight,
                  ),
                ),
                // Text(
                //   username,
                //   textAlign: TextAlign.center,
                //   style: blackTextStyle.copyWith(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     decoration: TextDecoration.underline,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '*Pastikan kode OTP yang anda masukkan sesuai',
              textAlign: TextAlign.left,
              style: blackTextStyle.copyWith(
                fontSize: 11,
                fontWeight: superlight,
                color: Colors.red,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteColor,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode OTP',
                          style: blackTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          maxLength: 6,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the OTP code';
                            }
                            if (value.length < 6) {
                              return 'OTP code must be 6 digits';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ForgotPasswordController.verifyOTP(
                                context, otpController, username);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semibold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    "Kembali ke Login",
                    style: blackTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

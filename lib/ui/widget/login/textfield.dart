// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? toggleObscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.isPassword = false,
    this.isObscure = false,
    this.toggleObscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5
          )
        ),
      ),
      child: TextField(
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 15,
        ),
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    size: 20,
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
        ),
      ),
    );
  }
}
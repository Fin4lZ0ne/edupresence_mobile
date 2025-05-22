import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';

class EditProfileWidget {
  static Widget textedit() {
    return Text(
      'Lengkapi dan simpan perubahan data profil yang telah anda perbaiki.',
      textAlign: TextAlign.center,
      style: blackTextStyle,
    );
  }

  static Widget buildTextField(String labelText, IconData icon, {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText harus diisi';
          }
          return null;
        },
      ),
    );
  }

  static Widget buildDateField(BuildContext context, String labelText, {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now().subtract(Duration(days: 1)),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().split('T').first;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText harus diisi';
          }
          return null;
        },
      ),
    );
  }

  static Widget saveButton(Function()? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonActiveColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Simpan',
          style: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semibold,
          ),
        ),
      ),
    );
  }
}

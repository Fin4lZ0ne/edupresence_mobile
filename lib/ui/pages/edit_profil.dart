import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edupresence_mobile/core/services/editprofile_service.dart';
import 'package:edupresence_mobile/core/services/profile_service.dart';
import 'package:edupresence_mobile/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:edupresence_mobile/ui/widget/editprofile/editprofile_widget.dart';
import 'package:edupresence_mobile/ui/pages/profile_page.dart'; // Ensure you have the correct import for ProfilePage

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _birthplaceController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String _authToken = ''; // Placeholder for the auth token
  String _userId = ''; // Placeholder for the user ID
  String? _profileImageUrl; // URL for the profile image

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');
      if (token != null) {
        setState(() {
          _authToken = token;
        });
        print('Auth Token loaded from SharedPreferences: $_authToken');
      } else {
        print('No Auth Token found in SharedPreferences');
      }

      User user = await ProfileService.fetchUser();
      setState(() {
        _emailController.text = user.email ?? '';
        _fullNameController.text = user.fullname ?? '';
        _birthplaceController.text = user.birthplace ?? '';
        _birthdateController.text = user.birthdate ?? '';
        _addressController.text = user.address ?? '';
        _userId = user.id?.toString() ?? '';
        _profileImageUrl = user.photos?.front;
      });
    } catch (e) {
      // Handle error
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Print all form data before sending
      print('Saving Profile with Data:');
      print('User ID: $_userId');
      print('Email: ${_emailController.text}');
      print('Full Name: ${_fullNameController.text}');
      print('Place of Birth: ${_birthplaceController.text}');
      print('Date of Birth: ${_birthdateController.text}');
      print('Address: ${_addressController.text}');
      print('Auth Token: $_authToken');

      bool success = await EditProfileService.editProfile(
        userId: _userId,
        email: _emailController.text,
        fullname: _fullNameController.text,
        birthplace: _birthplaceController.text,
        birthdate: DateTime.parse(_birthdateController.text),
        address: _addressController.text,
        token: _authToken,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: _pickImage,
                //   child: CircleAvatar(
                //     radius: 50,
                //     backgroundImage: _image != null
                //         ? FileImage(_image!)
                //         : (_profileImageUrl != null
                //             ? NetworkImage(_profileImageUrl!)
                //             : AssetImage('assets/profile/user.png'))
                //                 as ImageProvider,
                //   ),
                // ),
                // SizedBox(height: 20),
                EditProfileWidget.textedit(),
                SizedBox(height: 20),
                EditProfileWidget.buildTextField('Nama Panjang', Icons.person_outline,
                    controller: _fullNameController),
                EditProfileWidget.buildTextField('Tempat Lahir', Icons.location_city,
                    controller: _birthplaceController),
                EditProfileWidget.buildDateField(context, 'Tanggal Lahir',
                    controller: _birthdateController),
                EditProfileWidget.buildTextField('Alamat', Icons.home,
                    controller: _addressController),
                EditProfileWidget.buildTextField('Email', Icons.person,
                    controller: _emailController),
                SizedBox(height: 20),
                EditProfileWidget.saveButton(_saveProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

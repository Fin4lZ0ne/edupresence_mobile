import 'package:edupresence_mobile/core/models/user.dart';
import 'package:edupresence_mobile/core/services/profile_service.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:edupresence_mobile/ui/widget/profile/profilepage_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
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
      body: FutureBuilder<User>(
        future: ProfileService.fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            User user = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    fotoprofil(user),
                    nama(user.fullname, user.email),
                    boxprofile(user.nik, user.gender, user.birthplace),
                    nextProfile(user.username, user.birthplace, user.birthdate, user.address),
                    editButton(context),
                    SizedBox(height: 16),
                    logoutButton(context),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

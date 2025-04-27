import 'package:edupresence_mobile/core/models/user.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:edupresence_mobile/ui/pages/profile_page.dart';

Widget buildProfile(BuildContext context, User user) {
  return Container(
    margin: const EdgeInsets.only(
      top: 40,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: whiteTextStyle.copyWith(
                fontSize: 19,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              user.fullname ?? 'Guest',
              style: whiteTextStyle.copyWith(
                fontSize: 19,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              user.nik ?? 'No NIK',
              style: whiteTextStyle.copyWith(
                fontSize: 10,
                fontWeight: semibold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: user.photos?.front != null
                    ? NetworkImage(user.photos!.front!)
                    : AssetImage('assets/home/profil_picture.png')
                        as ImageProvider, // URL gambar dari API atau gambar default
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

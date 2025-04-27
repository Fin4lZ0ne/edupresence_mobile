import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:edupresence_mobile/core/services/image_upload_service.dart';
import 'package:image/image.dart' as img;

class CaptureController {
  final ImageUploadService _imageUploadService = ImageUploadService();

  Future<void> captureAndUpload(BuildContext context, String imagePath) async {
    try {
      // Memeriksa izin lokasi
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Mendapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(
          "Lokasi berhasil didapatkan: (${position.latitude}, ${position.longitude})");

      // Kompresi gambar sebelum mengupload
      Uint8List compressedImage = await compressImage(File(imagePath));

      // Mengirim gambar beserta lokasi ke API
      Map<String, dynamic> response =
          await _imageUploadService.uploadImageWithLocation(
        compressedImage,
        position.latitude,
        position.longitude,
      );

      if (response['success']) {
        print("Presensi berhasil: ${response['message']}");
        showSuccessDialog(context, response['message'] ?? 'Presensi berhasil.');
      } else {
        print("Gagal melakukan presensi: ${response['message']}");
        showErrorDialog(
            context, response['message'] ?? 'Gagal melakukan presensi.');
      }
    } catch (e) {
      print("Error: $e");
      showErrorDialog(context, e.toString());
    }
  }

  Future<Uint8List> compressImage(File file) async {
    // Membaca gambar dari file
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    // Mengkompresi gambar
    img.Image resizedImage = img.copyResize(image, width: 600); // Resize image
    Uint8List compressedImage = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 85)); // Compress image

    return compressedImage;
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 10), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 16),
              const Text('Presensi Berhasil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Kembali Ke Beranda'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 100),
              SizedBox(height: 16),
              Text(
                'Presensi Gagal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Tutup'),
              ),
            ],
          ),
        );
      },
    );
  }
}

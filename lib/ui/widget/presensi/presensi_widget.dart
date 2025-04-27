import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:edupresence_mobile/core/controllers/checkin_controller.dart';
import 'package:m7_livelyness_detection/index.dart';
import 'package:edupresence_mobile/core/services/get_status_service.dart';
import 'package:edupresence_mobile/core/controllers/capture_controller.dart';

class PresensiWidget extends StatefulWidget {
  final List<Schedule> schedules;
  final bool hasSchedule;
  final bool isLoading;

  const PresensiWidget({
    Key? key,
    required this.schedules,
    required this.hasSchedule,
    required this.isLoading,
  }) : super(key: key);

  @override
  _PresensiWidgetState createState() => _PresensiWidgetState();
}

class _PresensiWidgetState extends State<PresensiWidget> {
  final CheckInController _checkInController = CheckInController();
  final CaptureController _captureController = CaptureController();
  bool _isLoading = false;

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 10), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 16),
              const Text(
                'Presensi Berhasil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Anda baru saja melakukan presensi pada pukul ${DateFormat('HH:mm:ss').format(DateTime.now())} WIB',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              const Text(
                'Selamat bekerja dan terima kasih telah melakukan presensi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Kembali Ke Beranda'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: 
                Text(
                  'Tutup',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startPresence() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool isLocationValid = await _checkInController.checkIn(context);

      if (isLocationValid) {
        final M7CapturedImage? detectionResponse =
            await M7LivelynessDetection.instance.detectLivelyness(
          context,
          config: M7DetectionConfig(steps: [
            M7LivelynessStepItem(
              step: M7LivelynessStep.blink,
              title: "Kedipkan Mata",
              isCompleted: false,
            ),
          ]),
        );

        if (detectionResponse != null) {
          print("Gambar berhasil di-scan, path: ${detectionResponse.imgPath}");
          await _captureController.captureAndUpload(
              context, detectionResponse.imgPath);
        } else {
          print("Gagal mendeteksi wajah.");
          _captureController.showErrorDialog(
              context, "Gagal mendeteksi wajah.");
        }
      } else {
        print("Lokasi tidak valid.");
        _captureController.showErrorDialog(context, "Lokasi tidak valid.");
      }
    } catch (e) {
      print("Error saat melakukan presensi: $e");
      _captureController.showErrorDialog(
          context, "Gagal melakukan presensi: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

    Schedule? currentSchedule;
    DateTime now = DateTime.now();

    for (var schedule in widget.schedules) {
      final startTime = TimeOfDay(
        hour: int.parse(schedule.timeStart.split(':')[0]),
        minute: int.parse(schedule.timeStart.split(':')[1]),
      );
      final endTime = TimeOfDay(
        hour: int.parse(schedule.timeEnd.split(':')[0]),
        minute: int.parse(schedule.timeEnd.split(':')[1]),
      );

      final startDateTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);
      final endDateTime =
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        currentSchedule = schedule;
        break;
      }
    }

    return widget.isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: double.infinity,
            height: 160,
            margin: const EdgeInsets.only(
              top: 26,
              left: 16,
              right: 16,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Presensi Saat Ini',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: extrabold,
                      ),
                    ),
                    Text(
                      currentDate,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: extrabold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                if (currentSchedule != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${currentSchedule.formattedTimeStart}-${currentSchedule.formattedTimeEnd}',
                        style: blackTextStyle.copyWith(
                          fontSize: 19,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        currentSchedule.course,
                        style: blackTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 30,
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: GetStatusService().getStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0099FF),
                                ),
                                child: Text(
                                  'Invalid',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              final isActive =
                                  snapshot.data?['isActive'] ?? false;
                              return ElevatedButton(
                                onPressed: _isLoading ? null : _startPresence,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0099FF),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        isActive
                                            ? 'Akhiri Presensi'
                                            : 'Mulai Presensi',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Expanded(
                    child: Center(
                      child: Text(
                        'Tidak ada presensi untuk saat ini',
                        style: blackTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
  }
}

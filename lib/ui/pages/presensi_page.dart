import 'package:edupresence_mobile/core/models/jadwal/schedule.dart';
import 'package:flutter/material.dart';
import 'package:edupresence_mobile/shared/theme.dart';
import 'package:edupresence_mobile/ui/widget/presensi/presensi_widget.dart';
import 'package:edupresence_mobile/core/services/schedule_service.dart';
import 'package:edupresence_mobile/core/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:edupresence_mobile/core/controllers/log_presensi_controller.dart';
import 'package:edupresence_mobile/ui/widget/presensi/log_presensi_widget.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({Key? key}) : super(key: key);

  @override
  _PresensiPageState createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  final AuthController authController = Get.put(AuthController());
  final LogPresensiController logPresensiController =
      Get.put(LogPresensiController());

  bool _hasSchedule = true;
  List<Schedule> _scheduleList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    authController.loadUserFromPrefs();
    _fetchSchedulesForToday(DateTime.now());
  }

  void _fetchSchedulesForToday(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final schedules = await ScheduleService.fetchSchedulesForDate(
          DateFormat('yyyy-MM-dd').format(date));
      setState(() {
        _scheduleList = schedules;
        _hasSchedule = schedules.isNotEmpty;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasSchedule = false;
      });
      print('Error fetching schedules: $error');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green[100]!;
      case 'late':
        return Colors.yellow[100]!;
      case 'absent':
        return Colors.red[100]!;
      case 'excused':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Widget _buildLogPresensi() {
    return Obx(() {
      if (logPresensiController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Presensi',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...logPresensiController.logPresensiList.map((log) {
              final subject = log['subject'] ?? 'Unknown';
              final date = log['date'] ?? 'Unknown';
              final start = log['start'] ?? '00:00';
              final end = log['end'] ?? '00:00';
              final status = log['status'] ?? 'belum presensi';
              final time = '$start - $end';
              final statusColor = _getStatusColor(status);

              return LogPresensiCard(
                subject: subject,
                date: date,
                time: time,
                status: status,
                statusColor: statusColor,
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Presensi',
          textAlign: TextAlign.center,
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PresensiWidget(
              schedules: _scheduleList,
              hasSchedule: _hasSchedule,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            _buildLogPresensi(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

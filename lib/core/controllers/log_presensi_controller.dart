import 'package:get/get.dart';
import 'package:edupresence_mobile/core/services/log_presensi_service.dart';

class LogPresensiController extends GetxController {
  var isLoading = false.obs;
  var logPresensiList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchLogPresensi();
    super.onInit();
  }

  void fetchLogPresensi() async {
    isLoading(true);
    try {
      var logs = await LogPresensiService().getLogPresensi();
      logPresensiList.assignAll(logs);
    } catch (error) {
      print('Error fetching log presensi: $error');
    } finally {
      isLoading(false);
    }
  }
}

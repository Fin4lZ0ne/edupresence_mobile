import 'package:edupresence_mobile/core/controllers/auth_controller.dart';
import 'package:edupresence_mobile/routes/route.dart';
import 'package:edupresence_mobile/ui/pages/home_page.dart';
import 'package:edupresence_mobile/ui/pages/login_page.dart';
import 'package:edupresence_mobile/ui/widget/launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale data for Indonesian locale
  await initializeDateFormatting('id_ID', null);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apsensi Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const launcher(),
      getPages: RouteApp.pages,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    );
  }
}

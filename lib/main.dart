import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:protopharma/config/app_config.dart';
import 'package:protopharma/features/home/home_screen.dart';
import 'package:protopharma/models/drug_model.dart';
import 'package:protopharma/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await seedDrugDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.isDebug,
      home: HomeScreen(),
    );
  }
}

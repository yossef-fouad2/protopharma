import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:protopharma/core/config/app_config.dart';
import 'package:protopharma/core/config/app_pages.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/data/fetch_drugs.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final db = AppDatabase();

  runApp(MyApp(db: db));

  // Defer database seeding until after startup is complete to keep launch smooth
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 500), () {
      insertAllDrugs(db);
    });
  });
}

class MyApp extends StatelessWidget {
  final AppDatabase db;

  const MyApp({super.key, required this.db});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DrugsRepository>(
      create: (context) => DrugsRepository(db: db),
      child: GetMaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: AppConfig.isDebug,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Automatically matches device theme
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}

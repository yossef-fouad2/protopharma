import 'package:get/get.dart';
import 'package:protopharma/core/config/app_routes.dart';
import 'package:protopharma/features/navigation/screens/main_layout_screen.dart';

abstract class AppPages {
  static const initial = AppRoutes.mainLayout;
  static final routes = [
    GetPage(name: AppRoutes.mainLayout, page: () => const MainLayoutScreen()),
//     // GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
//     GetPage(name: AppRoutes.inventory, page: () => Scaffold()),
//     GetPage(name: AppRoutes.orders, page: () => Scaffold()),
//     GetPage(name: AppRoutes.checkout, page: () => Scaffold()),
  ];
}

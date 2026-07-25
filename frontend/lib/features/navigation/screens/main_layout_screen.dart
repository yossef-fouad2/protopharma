import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:protopharma/features/home/home_screen.dart';
import 'package:protopharma/features/inventory/inventory_screen.dart';
import 'package:protopharma/features/navigation/controllers/nav_controller.dart';
import 'package:protopharma/features/navigation/widgets/side_nav_bar.dart';
import 'package:protopharma/features/orders/order_history_screen.dart';
import 'package:protopharma/features/orders/order_view.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());
    return Scaffold(
      body: Row(
        children: [
          const SideNavBar(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  HomeScreen(),
                  InventoryScreen(),
                  OrderView(),
                  const OrderHistoryScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

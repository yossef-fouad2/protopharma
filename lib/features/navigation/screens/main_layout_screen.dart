import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:protopharma/features/home/home_screen.dart';
import 'package:protopharma/features/navigation/controllers/navigation_controller.dart';
import 'package:protopharma/features/navigation/widgets/side_nav_bar.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      body: Row(
        children: [
          const SideNavBar(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.selectedIndex,
                children: [
                  HomeScreen(),
                  const Center(child: Text('Inventory Screen')),
                  const Center(child: Text('Orders Screen')),
                  const Center(child: Text('Checkout Screen')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:protopharma/features/home/home_screen.dart';
import 'package:protopharma/features/navigation/widgets/side_nav_bar.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNavBar(),
          Expanded(child: Obx() =>IndexedStack()),
        ],
      ),
    );
  }
}

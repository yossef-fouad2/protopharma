import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:protopharma/config/app_routes.dart';
import 'package:protopharma/features/navigation/controller/navigation_controller.dart';
import 'package:protopharma/models/nav_menu_item_model.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  static final List<NavMenuItem> _menuItems = [
    NavMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: AppRoutes.home,
    ),
    NavMenuItem(
      title: 'Inventory',
      icon: Icons.inventory_2_outlined,
      route: AppRoutes.inventory,
    ),
    NavMenuItem(
      title: 'Orders',
      icon: Icons.receipt_long_outlined,
      route: AppRoutes.orders,
    ),
    NavMenuItem(
      title: 'Checkout',
      icon: Icons.shopping_cart_outlined,
      route: AppRoutes.checkout,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();
    return Container(
      width: 300,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return Obx(() {
                  final isSelected = controller.selectedIndex == index;
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () => controller.changeIndex(index),
                  );
                });
              },

              // children: _menuItems
              //     .map(
              //       (item) => ListTile(
              //         leading: Icon(item.icon),
              //         title: Text(item.title),
              //         onTap: () => Get.toNamed(item.route),
              //       ),
              //     )
              //     .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

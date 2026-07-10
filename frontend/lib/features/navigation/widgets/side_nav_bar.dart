import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:protopharma/core/config/app_routes.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/features/navigation/controllers/navigation_controller.dart';
import 'package:protopharma/features/navigation/models/nav_menu_item_model.dart';

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
      width: 200,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 160),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return Obx(() {
                  final isSelected = controller.selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        selected: isSelected,
                        visualDensity: const VisualDensity(
                          vertical: -4,
                        ), // Shrinks vertical space (default is 0, minimum is -4)
                        // 1. Hover State: 8% Opacity for subtle feedback
                        hoverColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),

                        // 2. Shape: 12px Rounded Corners (rounded-xl)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),

                        // 3. Selection Color: High-contrast Solid Primary
                        selectedTileColor: AppColors.primaryDark,

                        // 4. Icon & Text Colors:
                        leading: Icon(
                          item.icon,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textMuted,
                          size: 18,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textMuted,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () => controller.changeIndex(index),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

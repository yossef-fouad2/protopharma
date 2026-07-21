import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_theme.dart';

class PharmacyLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const PharmacyLabel({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

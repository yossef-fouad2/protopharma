import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../../core/config/app_colors.dart';

class CurrentOrder extends StatelessWidget {
  const CurrentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 400,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.surfaceContainerLow,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Current Order',
                    style: AppTextStyles.cairoBold.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 5),
            SizedBox(height: 16),
            Text('Add Medicine', style: AppTextStyles.titleMedium),
            // This takes all remaining empty space
            const Expanded(child: SizedBox()),
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Subtotal'),
                  Text('Insurance Coverage'),
                  SizedBox(height: 12),
                  Text('Total Due'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

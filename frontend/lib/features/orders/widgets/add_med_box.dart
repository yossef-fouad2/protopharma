import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

class AddMedBox extends StatelessWidget {
  const AddMedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 700,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Add Medicine', style: AppTextStyles.titleMedium),
          ],
        ),
      ),
    );
  }
}

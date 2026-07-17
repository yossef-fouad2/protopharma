import 'package:flutter/material.dart';
import 'package:protopharma/features/home/widgets/summary_card.dart';
import 'package:protopharma/core/config/app_theme.dart';

/// Row of three summary metric cards: Today's Sales, Total Orders, Active Prescriptions.
class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Stack cards vertically on narrow screens
        if (constraints.maxWidth < 600) {
          return const Column(
            children: [
              SummaryCard(
                label: "TODAY'S SALES",
                value: '\$8,452.00',
                icon: Icons.payments_outlined,
                subtitle: '+12.5% vs yesterday',
                subtitleIcon: Icons.trending_up,
                subtitleColor: AppColors.success,
              ),
              SizedBox(height: 16),
              SummaryCard(
                label: 'TOTAL ORDERS',
                value: '142',
                icon: Icons.shopping_bag_outlined,
                subtitle: '45 pending fulfillment',
              ),
              SizedBox(height: 16),
              SummaryCard(
                label: 'ACTIVE PRESCRIPTIONS',
                value: '89',
                icon: Icons.vaccines_outlined,
                subtitle: 'Requires pharmacist verification',
                isAccented: true,
                actionLabel: 'Review',
              ),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: "TODAY'S SALES",
                value: '\$8,452.00',
                icon: Icons.payments_outlined,
                subtitle: '+12.5% vs yesterday',
                subtitleIcon: Icons.trending_up,
                subtitleColor: AppColors.success,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                label: 'TOTAL ORDERS',
                value: '142',
                icon: Icons.shopping_bag_outlined,
                subtitle: '45 pending fulfillment',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                label: 'ACTIVE PRESCRIPTIONS',
                value: '89',
                icon: Icons.vaccines_outlined,
                subtitle: 'Requires pharmacist verification',
                isAccented: true,
                actionLabel: 'Review',
              ),
            ),
          ],
        );
      },
    );
  }
}

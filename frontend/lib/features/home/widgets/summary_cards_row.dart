import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/features/home/widgets/summary_card.dart';
import 'package:protopharma/features/orders/cubit/sales_cubit.dart';
import 'package:protopharma/features/orders/cubit/sales_state.dart';

/// Row of live summary metric cards driven by [SalesCubit].
///
/// Each card renders a derived metric off of [SalesState] so it stays in sync
/// the moment a new checkout completes:
///   • Total Revenue      – sum of every completed sale's total.
///   • Completed Sales    – count of sales in the ledger.
///   • Average Order Value – revenue / sales count (0 when empty).
class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        final revenue = state.totalRevenue;
        final count = state.totalSalesCount;
        final aov = state.averageOrderValue;

        final cards = <Widget>[
          SummaryCard(
            label: 'TOTAL REVENUE',
            value: '${revenue.toStringAsFixed(2)} EGP',
            icon: Icons.payments_outlined,
            subtitle: 'Across all completed sales',
            subtitleIcon: Icons.trending_up,
            subtitleColor: AppColors.success,
          ),
          SummaryCard(
            label: 'COMPLETED SALES',
            value: '$count',
            icon: Icons.shopping_bag_outlined,
            subtitle: count == 0
                ? 'No sales yet — checkout to add one'
                : '$count total orders processed',
          ),
          SummaryCard(
            label: 'AVERAGE ORDER VALUE',
            value: '${aov.toStringAsFixed(2)} EGP',
            icon: Icons.stacked_line_chart_outlined,
            subtitle: 'Live from sales history',
            isAccented: true,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            // Stack vertically on narrow screens.
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    cards[i],
                  ],
                ],
              );
            }
            return Row(
              children: [
                for (int i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Expanded(child: cards[i]),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

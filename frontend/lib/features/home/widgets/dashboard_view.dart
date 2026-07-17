import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/features/home/widgets/critical_alerts_panel.dart';
import 'package:protopharma/features/home/widgets/dashboard_header.dart';
import 'package:protopharma/features/home/widgets/recent_activity_table.dart';
import 'package:protopharma/features/home/widgets/summary_cards_row.dart';

/// Main dashboard layout — composes all dashboard sections.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 24),
              const SummaryCardsRow(),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return const Column(
                      children: [
                        RecentActivityTable(),
                        SizedBox(height: 24),
                        CriticalAlertsPanel(),
                      ],
                    );
                  }
                  return const IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 2, child: RecentActivityTable()),
                        SizedBox(width: 24),
                        Expanded(child: CriticalAlertsPanel()),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

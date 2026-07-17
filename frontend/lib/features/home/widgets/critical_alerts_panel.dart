import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/features/home/cubit/alerts_cubit.dart';
import 'package:protopharma/features/home/cubit/alerts_state.dart';
import 'package:protopharma/features/home/models/inventory_alert.dart';

/// Critical Alerts panel showing urgent pharmacy notifications.
///
/// Alerts are driven live by the inventory table through [AlertsCubit]. They're
/// split into categories (out-of-stock, low-stock, expiring) with per-category
/// pagination so the panel stays responsive even for large catalogues.
class CriticalAlertsPanel extends StatelessWidget {
  const CriticalAlertsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlertsCubit>(
      create: (_) =>
          AlertsCubit(drugsRepository: context.read<DrugsRepository>()),
      child: const _CriticalAlertsView(),
    );
  }
}

class _CriticalAlertsView extends StatelessWidget {
  const _CriticalAlertsView();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<AlertsCubit, AlertsState>(
        builder: (context, state) {
          return Column(
            children: [
              _Header(total: state.counts.total),
              _CategoryTabs(selected: state.selectedType, counts: state.counts),
              Expanded(child: _Body(state: state)),
              _PaginationFooter(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderDark)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: AppColors.error, size: 22),
          const SizedBox(width: 8),
          Text('Critical Alerts', style: AppTextStyles.titleMedium),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$total',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented tabs to switch between the three alert categories.
class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.selected, required this.counts});

  final AlertType selected;
  final AlertCounts counts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TabChip(
            label: 'Out of Stock',
            count: counts.outOfStock,
            isSelected: selected == AlertType.outOfStock,
            color: AppColors.error,
            onTap: () =>
                context.read<AlertsCubit>().selectType(AlertType.outOfStock),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Low Stock',
            count: counts.lowStock,
            isSelected: selected == AlertType.lowStock,
            color: AppColors.error,
            onTap: () =>
                context.read<AlertsCubit>().selectType(AlertType.lowStock),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Expiring',
            count: counts.expiring,
            isSelected: selected == AlertType.expiringSoon,
            color: AppColors.warning,
            onTap: () =>
                context.read<AlertsCubit>().selectType(AlertType.expiringSoon),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(color: isSelected ? color : AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? color : AppColors.textHeadline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : AppColors.textBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});
  final AlertsState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == AlertsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == AlertsStatus.error) {
      return const _EmptyMessage(
        icon: Icons.error_outline,
        message: 'Could not load alerts.',
      );
    }
    if (state.alerts.isEmpty) {
      return const _EmptyMessage(
        icon: Icons.check_circle_outline,
        message: 'All good — nothing here.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.alerts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _AlertCard(alert: state.alerts[i]),
    );
  }
}

/// Prev / next pagination controls for the selected category.
class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.state});
  final AlertsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AlertsCubit>();
    final totalPages = cubit.totalPages;

    // Hide the footer when there's nothing to page through.
    if (state.totalInSelected == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: state.currentPage > 1 ? cubit.previousPage : null,
            icon: const Icon(Icons.chevron_left),
            splashRadius: 20,
          ),
          Text(
            'Page ${state.currentPage} of $totalPages',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textBody,
            ),
          ),
          IconButton(
            onPressed: state.currentPage < totalPages ? cubit.nextPage : null,
            icon: const Icon(Icons.chevron_right),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textBody),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});
  final InventoryAlert alert;

  IconData get _icon => switch (alert.type) {
    AlertType.outOfStock => Icons.inventory_2_outlined,
    AlertType.lowStock => Icons.inventory_outlined,
    AlertType.expiringSoon => Icons.event_busy_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final isCritical = alert.severity == AlertSeverity.critical;

    final bgColor = isCritical
        ? AppColors.error.withValues(alpha: 0.08)
        : AppColors.warning.withValues(alpha: 0.08);
    final borderColor = isCritical
        ? AppColors.error.withValues(alpha: 0.3)
        : AppColors.warning.withValues(alpha: 0.3);
    final titleColor = isCritical
        ? const Color(0xFF93000A)
        : const Color(0xFF5D4037);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: titleColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textBody,
                  ),
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  label: alert.actionLabel,
                  isCritical: isCritical,
                  onTap: () {
                    debugPrint('Alert action tapped: ${alert.title}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    this.isCritical = false,
    this.onTap,
  });
  final String label;
  final bool isCritical;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isCritical ? AppColors.error : Colors.transparent,
          border: isCritical ? null : Border.all(color: AppColors.borderDark),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: isCritical ? Colors.white : AppColors.textHeadline,
          ),
        ),
      ),
    );
  }
}

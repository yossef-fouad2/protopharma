import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/app_text_styles.dart';
import '../cubit/sales_cubit.dart';
import '../cubit/sales_state.dart';
import '../models/sale_model.dart';
import 'sale_details_drawer.dart';

/// Order History screen body.
///
/// Shows the completed sales as a filterable/searchable table. All state lives
/// in the app-level [SalesCubit], so this view stays stateless.
class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order History', style: AppTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Browse every completed sale, filter by payment method, and open any receipt.',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 20),
              const _FilterBar(),
              const SizedBox(height: 16),
              const Expanded(child: _HistoryTable()),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter bar: search box + payment method chips
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 260,
              child: TextField(
                onChanged: context.read<SalesCubit>().updateSearch,
                decoration: InputDecoration(
                  hintText: 'Search by ref or drug name',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            _FilterChip(
              label: 'All',
              selected: state.paymentFilter == null,
              onTap: () => context.read<SalesCubit>().filterByPayment(null),
            ),
            for (final method in PaymentMethod.values)
              _FilterChip(
                label: method.label,
                selected: state.paymentFilter == method,
                onTap: () => context.read<SalesCubit>().filterByPayment(method),
              ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryTeal : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primaryTeal : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.tableCell.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textBody,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// History table
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryTable extends StatelessWidget {
  const _HistoryTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        final sales = state.filteredSales;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _headerRow(),
              const Divider(height: 1),
              Expanded(
                child: sales.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        itemCount: sales.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, i) => _SaleRow(sale: sales[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerRow() {
    return Container(
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _cell('Sale', flex: 1),
          _cell('Time', flex: 2),
          _cell('Items', flex: 1),
          _cell('Total', flex: 1, align: TextAlign.right),
          _cell('Payment', flex: 1),
          _cell('Action', flex: 1, align: TextAlign.right),
        ],
      ),
    );
  }

  static Widget _cell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: AppTextStyles.tableCell.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => SaleDetailsDrawer.show(context, sale: sale),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _cell(
              sale.reference,
              flex: 1,
              bold: true,
              color: AppColors.textHeadline,
            ),
            _cell(_formatDateTime(sale.createdAt), flex: 2),
            _cell('${sale.itemCount}', flex: 1),
            _cellRight(
              '${sale.totalAmount.toStringAsFixed(2)} EGP',
              flex: 1,
              bold: true,
            ),
            Expanded(flex: 1, child: _PaymentBadge(method: sale.paymentMethod)),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => SaleDetailsDrawer.show(context, sale: sale),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(String text, {int flex = 1, bool bold = false, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyles.tableCell.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: color ?? AppColors.textBody,
        ),
      ),
    );
  }

  Widget _cellRight(String text, {int flex = 1, bool bold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: AppTextStyles.tableCell.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppColors.textHeadline,
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    if (isToday) return 'Today · $hh:$mm';
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d · $hh:$mm';
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.method});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (method) {
      PaymentMethod.cash => (const Color(0xFFE8F5E9), const Color(0xFF00714D)),
      PaymentMethod.card => (const Color(0xFFE8EAF6), const Color(0xFF283593)),
      PaymentMethod.insurance => (
        const Color(0xFFFFF3E0),
        const Color(0xFF9A5B00),
      ),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          method.label,
          style: AppTextStyles.tableCell.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No sales match the current filters.',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textBody),
          ),
        ],
      ),
    );
  }
}

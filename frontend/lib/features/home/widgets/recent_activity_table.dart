import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/features/navigation/controllers/nav_controller.dart';
import 'package:protopharma/features/orders/cubit/sales_cubit.dart';
import 'package:protopharma/features/orders/cubit/sales_state.dart';
import 'package:protopharma/features/orders/models/sale_model.dart';
import 'package:protopharma/features/orders/widgets/sale_details_drawer.dart';

/// Recent Activity table showing the latest completed sales from [SalesCubit].
///
/// The list stays in sync with the app-wide sales ledger: any checkout will
/// immediately appear at the top. "View All" jumps to the Order History tab.
class RecentActivityTable extends StatelessWidget {
  const RecentActivityTable({super.key, this.maxRows = 6});

  /// Cap on how many rows to render so the dashboard stays compact.
  final int maxRows;

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
      child: Column(
        children: [
          _header(),
          Expanded(
            child: BlocBuilder<SalesCubit, SalesState>(
              builder: (context, state) {
                final rows = state.sales.take(maxRows).toList();
                if (rows.isEmpty) return const _EmptyState();
                return SingleChildScrollView(child: _buildTable(context, rows));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderDark)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Recent Activity', style: AppTextStyles.titleMedium),
          InkWell(
            // Jumps to the Order History tab (index 3 in MainLayoutScreen).
            onTap: () {
              if (Get.isRegistered<NavController>()) {
                Get.find<NavController>().changeIndex(3);
              }
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textBody,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.textBody,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<SaleModel> sales) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.2),
      },
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLow,
            border: Border(bottom: BorderSide(color: AppColors.borderDark)),
          ),
          children: [
            _headerCell('Time'),
            _headerCell('Sale'),
            _headerCell('Action'),
            _headerCell('Payment', align: TextAlign.right),
          ],
        ),
        // Data rows — one per sale.
        ...sales.asMap().entries.map((entry) {
          final i = entry.key;
          final sale = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : AppColors.background,
              border: const Border(
                bottom: BorderSide(color: AppColors.borderDark, width: 0.5),
              ),
            ),
            children: [
              _tapCell(
                context,
                sale,
                _dataCell(
                  _formatTime(sale.createdAt),
                  color: AppColors.textMuted,
                ),
              ),
              _tapCell(context, sale, _refCell(sale)),
              _tapCell(context, sale, _dataCell(_describeSale(sale))),
              _tapCell(context, sale, _paymentBadgeCell(sale)),
            ],
          );
        }),
      ],
    );
  }

  /// Wraps a table cell in an [InkWell] so the whole row opens the details drawer.
  Widget _tapCell(BuildContext context, SaleModel sale, Widget child) {
    return TableRowInkWell(
      onTap: () => SaleDetailsDrawer.show(context, sale: sale),
      child: child,
    );
  }

  Widget _headerCell(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _dataCell(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textBody,
        ),
      ),
    );
  }

  Widget _refCell(SaleModel sale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sale.reference,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeadline,
            ),
          ),
          Text(
            sale.userName,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _paymentBadgeCell(SaleModel sale) {
    final (Color bg, Color fg, Color border) = switch (sale.paymentMethod) {
      PaymentMethod.cash => (
        const Color(0xFFE8F5E9),
        const Color(0xFF00714D),
        const Color(0xFF00714D).withValues(alpha: 0.2),
      ),
      PaymentMethod.card => (
        const Color(0xFFE8EAF6),
        const Color(0xFF283593),
        const Color(0xFF283593).withValues(alpha: 0.2),
      ),
      PaymentMethod.insurance => (
        const Color(0xFFFFF3E0),
        const Color(0xFF9A5B00),
        const Color(0xFF9A5B00).withValues(alpha: 0.2),
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Text(
            sale.paymentMethod.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }

  /// Short natural-language summary of what was sold.
  String _describeSale(SaleModel sale) {
    if (sale.items.isEmpty) return 'Empty sale';
    final first = sale.items.first;
    final extra = sale.items.length - 1;
    final base = '${first.quantity}× ${first.drugName}';
    return extra > 0 ? '$base  +$extra more' : base;
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    if (isToday) return '$hh:$mm';
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$m-$d $hh:$mm';
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
            Icons.timelapse_outlined,
            size: 32,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'No recent activity yet',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

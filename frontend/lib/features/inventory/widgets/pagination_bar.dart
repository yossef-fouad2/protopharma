import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';
import 'package:protopharma/features/inventory/inventory_cubit.dart';
import 'table_footer.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
  });

  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;

  /// Which page numbers to show (up to 3 around current, with smart clamping).
  List<int> _visiblePages() {
    if (totalPages <= 5) {
      return List.generate(totalPages, (i) => i + 1);
    }
    // Show 3 pages around the current page, clamped to valid range.
    final start = (currentPage - 1).clamp(1, totalPages - 2);
    final end = (currentPage + 1).clamp(3, totalPages);
    return List.generate(end - start + 1, (i) => start + i);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();
    final visiblePages = _visiblePages();

    // "Showing X to Y of Z entries"
    final int from = totalCount == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final int to = (currentPage * pageSize).clamp(0, totalCount);

    final bool showLeadingEllipsis =
        totalPages > 5 && visiblePages.first > 1;
    final bool showTrailingEllipsis =
        totalPages > 5 && visiblePages.last < totalPages;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: entry count label ──────────────────────────────
          Text(
            'Showing $from to $to of $totalCount entries',
            style: AppTextStyles.tableCell.copyWith(
              color: AppColors.textBody,
            ),
          ),

          // ── Right: chevron + page buttons + chevron ──────────────
          Row(
            children: [
              // ‹ chevron
              TableFooter.icon(
                icon: Icons.chevron_left,
                onTap: currentPage > 1 ? cubit.previousPage : null,
              ),

              const SizedBox(width: 4),

              // Leading ellipsis + first page (if scrolled away from start)
              if (showLeadingEllipsis) ...[
                TableFooter.label(
                  label: '1',
                  isActive: currentPage == 1,
                  onTap: () => cubit.goToPage(1),
                ),
                const SizedBox(width: 4),
                _EllipsisLabel(),
                const SizedBox(width: 4),
              ],

              // Visible page number buttons
              for (final page in visiblePages) ...[
                TableFooter.label(
                  label: '$page',
                  isActive: page == currentPage,
                  onTap: () => cubit.goToPage(page),
                ),
                const SizedBox(width: 4),
              ],

              // Trailing ellipsis + last page (if more pages beyond window)
              if (showTrailingEllipsis) ...[
                _EllipsisLabel(),
                const SizedBox(width: 4),
              ],

              // › chevron
              TableFooter.icon(
                icon: Icons.chevron_right,
                onTap: currentPage < totalPages ? cubit.nextPage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EllipsisLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 32,
      child: Center(
        child: Text(
          '...',
          style: AppTextStyles.tableCell.copyWith(color: AppColors.textBody),
        ),
      ),
    );
  }
}

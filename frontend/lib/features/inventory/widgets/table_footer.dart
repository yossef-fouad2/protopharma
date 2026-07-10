import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_colors.dart' show AppColors;
import 'package:protopharma/core/config/app_text_styles.dart';

/// A single page-number button (or Prev/Next chevron button).
///
/// Active  → filled [AppColors.textHeadline] background, white label.
/// Inactive → transparent with [AppColors.border] outline, dark label.
class TableFooter extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final VoidCallback? onTap;

  const TableFooter({
    required this.child,
    required this.isActive,
    this.onTap,
    super.key,
  });

  /// Convenience constructor for a plain text label (page numbers).
  factory TableFooter.label({
    required String label,
    required bool isActive,
    required VoidCallback? onTap,
    Key? key,
  }) {
    return TableFooter(
      key: key,
      isActive: isActive,
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.tableCell.copyWith(
          color: isActive ? Colors.white : AppColors.textHeadline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Convenience constructor for an icon button (chevrons).
  factory TableFooter.icon({
    required IconData icon,
    required VoidCallback? onTap,
    Key? key,
  }) {
    return TableFooter(
      key: key,
      isActive: false,
      onTap: onTap,
      child: Icon(
        icon,
        size: 18,
        color: onTap != null ? AppColors.textHeadline : AppColors.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.textHeadline : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.textHeadline : AppColors.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

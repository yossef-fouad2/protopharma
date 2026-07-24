import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';
import 'package:protopharma/features/inventory/inventory_cubit.dart';

/// Search input + category dropdown that drives the [InventoryCubit] filters.
///
/// The text field uses a 400 ms debounce inside the cubit, while the category
/// dropdown triggers an immediate reload.
class SearchToolbar extends StatefulWidget {
  const SearchToolbar({super.key});

  @override
  State<SearchToolbar> createState() => _SearchToolbarState();
}

class _SearchToolbarState extends State<SearchToolbar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryCubit>();
    final categories = cubit.categories;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final searchField = TextField(
          controller: _searchController,
          onChanged: cubit.updateSearchQuery,
          style: AppTextStyles.tableCell.copyWith(
            color: AppColors.textHeadline,
          ),
          decoration: InputDecoration(
            hintText: 'Search medication name...',
            hintStyle: AppTextStyles.tableCell.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(
                color: AppColors.primaryTeal,
                width: 1.5,
              ),
            ),
            isDense: true,
          ),
        );

        final dropdownField = _CategoryDropdown(
          categories: categories,
          onChanged: cubit.updateCategory,
        );

        final inStockToggle = _InStockToggle(
          onChanged: cubit.toggleInStockOnly,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderDark),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    SizedBox(height: 40, child: dropdownField),
                    const SizedBox(height: 12),
                    inStockToggle,
                  ],
                )
              : Row(
                  children: [
                    // Search field takes remaining space
                    Expanded(child: searchField),
                    const SizedBox(width: 24),
                    // Category dropdown has a fixed width on desktop
                    SizedBox(width: 200, height: 40, child: dropdownField),
                    const SizedBox(width: 16),
                    inStockToggle,
                  ],
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private dropdown extracted for clarity
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryDropdown extends StatefulWidget {
  const _CategoryDropdown({required this.categories, required this.onChanged});

  final List<String> categories;
  final ValueChanged<String?> onChanged;

  @override
  State<_CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<_CategoryDropdown> {
  String? _selected; // null == "All Categories"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: _selected,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textBody,
            size: 20,
          ),
          style: AppTextStyles.tableCell.copyWith(
            color: AppColors.textHeadline,
          ),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          items: [
            // "All Categories" entry
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'All Categories',
                style: AppTextStyles.tableCell.copyWith(
                  color: AppColors.textHeadline,
                ),
              ),
            ),
            // One entry per unique category
            ...widget.categories.map(
              (cat) => DropdownMenuItem<String?>(
                value: cat,
                child: Text(
                  cat,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tableCell.copyWith(
                    color: AppColors.textHeadline,
                  ),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() => _selected = value);
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "In stock only" toggle
// ─────────────────────────────────────────────────────────────────────────────

class _InStockToggle extends StatefulWidget {
  const _InStockToggle({required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<_InStockToggle> createState() => _InStockToggleState();
}

class _InStockToggleState extends State<_InStockToggle> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: _value,
          activeTrackColor: AppColors.primaryTeal,
          onChanged: (v) {
            setState(() => _value = v);
            widget.onChanged(v);
          },
        ),
        Text(
          'In stock only',
          style: AppTextStyles.tableCell.copyWith(
            color: AppColors.textBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

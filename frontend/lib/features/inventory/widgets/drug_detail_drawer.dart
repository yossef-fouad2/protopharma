import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';
import 'package:protopharma/features/drugs/models/batch_model.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';
import 'package:protopharma/features/inventory/inventory_cubit.dart';
import 'package:protopharma/features/inventory/widgets/batch_form_dialog.dart';
import 'package:protopharma/features/inventory/widgets/drug_form_dialog.dart';

/// Right-hand sliding detail panel for a single drug.
///
/// Shows editable catalog metadata at the top and a live list of the drug's
/// active batches below, each with edit/delete plus an "Add batch" action.
/// The main inventory table stays visible behind it on wide screens.
///
/// Opened via [DrugDetailDrawer.show], which handles the scrim + slide-in
/// animation. The [cubit] is passed explicitly so its provider is available
/// inside the overlay route (which sits outside the screen's BlocProvider).
class DrugDetailDrawer extends StatelessWidget {
  const DrugDetailDrawer({super.key, required this.drug, required this.cubit});

  final DrugModel drug;
  final InventoryCubit cubit;

  static Future<void> show(
    BuildContext context, {
    required DrugModel drug,
    required InventoryCubit cubit,
  }) {
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width < 600 ? width : 460.0;

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 380),
      // Build the (relatively heavy) panel content ONCE here. showGeneralDialog
      // reruns transitionBuilder every animation frame, so anything built there
      // — the ListView, StreamBuilder, and its DB query — would be rebuilt ~60
      // times during the slide, which is what made it feel sluggish.
      pageBuilder: (_, _, _) {
        return Align(
          alignment: Alignment.centerRight,
          child: RepaintBoundary(
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: Material(
                color: AppColors.surface,
                child: DrugDetailDrawer(drug: drug, cubit: cubit),
              ),
            ),
          ),
        );
      },
      // Only animate the already-built child. The scrim fades separately while
      // the panel uses a compositor-friendly transform for a snappier feel.
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return Stack(
          children: [
            FadeTransition(
              opacity: curved,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: curved,
              child: child,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset((1 - curved.value) * panelWidth, 0),
                  child: child,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reuse the existing cubit so mutations reload the table underneath.
    return BlocProvider.value(
      value: cubit,
      child: _DrawerBody(drug: drug),
    );
  }
}

class _DrawerBody extends StatelessWidget {
  const _DrawerBody({required this.drug});

  final DrugModel drug;

  Future<void> _editDrug(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final result = await DrugFormDialog.show(context, drug: drug);
    if (result == null || drug.id == null) return;
    await cubit.editDrug(
      id: drug.id!,
      commercialNameEn: result.commercialNameEn,
      commercialNameAR: result.commercialNameAR,
      scientificName: result.scientificName,
      manufacturer: result.manufacturer,
      drugClass: result.drugClass,
      route: result.route,
      priceEGP: result.priceEGP,
    );
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteDrug(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete medication?'),
        content: Text(
          'This removes "${drug.commercialNameEn}" and all of its batches '
          'from the active inventory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || drug.id == null) return;
    await cubit.deleteDrug(drug.id!);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _addBatch(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final result = await BatchFormDialog.show(context);
    if (result == null || drug.id == null) return;
    await cubit.addBatch(
      drugId: drug.id!,
      quantity: result.quantity,
      batchNumber: result.batchNumber,
      expiryDate: result.expiryDate,
      purchasePrice: result.purchasePrice,
      sellingPrice: result.sellingPrice,
    );
  }

  Future<void> _editBatch(BuildContext context, BatchModel batch) async {
    final cubit = context.read<InventoryCubit>();
    final result = await BatchFormDialog.show(context, batch: batch);
    if (result == null || batch.id == null) return;
    await cubit.editBatch(
      id: batch.id!,
      quantity: result.quantity,
      batchNumber: result.batchNumber,
      expiryDate: result.expiryDate,
      purchasePrice: result.purchasePrice,
      sellingPrice: result.sellingPrice,
    );
  }

  Future<void> _deleteBatch(BuildContext context, BatchModel batch) async {
    final cubit = context.read<InventoryCubit>();
    if (batch.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete batch?'),
        content: Text('Remove batch "${batch.batchNumber}" from stock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.deleteBatch(batch.id!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drug.commercialNameEn,
                        style: AppTextStyles.h2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (drug.commercialNameAR.isNotEmpty &&
                          drug.commercialNameAR != 'N/A')
                        Text(
                          drug.commercialNameAR,
                          style: AppTextStyles.bodyLarge,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // ── Catalog metadata ──────────────────────────────────────
                Text('Details', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                _metaRow('Scientific name', drug.scientificName),
                _metaRow('Manufacturer', drug.manufacturer),
                _metaRow('Category', drug.drugClass),
                _metaRow('Route', drug.route),
                _metaRow('Price (EGP)', drug.priceEGP.toStringAsFixed(2)),
                _metaRow('Total stock', '${drug.stock}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editDrug(context),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deleteDrug(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Batches ───────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Batches', style: AppTextStyles.titleMedium),
                    TextButton.icon(
                      onPressed: () => _addBatch(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add batch'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (drug.id != null)
                  _BatchList(
                    drugId: drug.id!,
                    onEdit: (b) => _editBatch(context, b),
                    onDelete: (b) => _deleteBatch(context, b),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.tableCell.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.tableCell.copyWith(
                color: AppColors.textHeadline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Live-updating list of a drug's active batches, driven by the repository's
/// `watchBatchesForDrug` stream.
///
/// Stateful so the stream is created once in [initState] and reused across
/// rebuilds. Building the stream inline in `build` would re-subscribe (and
/// re-run the DB query) on every rebuild, e.g. when the keyboard opens.
class _BatchList extends StatefulWidget {
  const _BatchList({
    required this.drugId,
    required this.onEdit,
    required this.onDelete,
  });

  final int drugId;
  final ValueChanged<BatchModel> onEdit;
  final ValueChanged<BatchModel> onDelete;

  @override
  State<_BatchList> createState() => _BatchListState();
}

class _BatchListState extends State<_BatchList> {
  late final Stream<List<BatchModel>> _batches;

  @override
  void initState() {
    super.initState();
    _batches = context
        .read<InventoryCubit>()
        .drugRepository
        .watchBatchesForDrug(widget.drugId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BatchModel>>(
      stream: _batches,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final batches = snapshot.data!;
        if (batches.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No active batches. Add one to start tracking stock.',
              style: AppTextStyles.tableCell.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          );
        }
        return Column(
          children: batches
              .map(
                (b) => _BatchTile(
                  batch: b,
                  onEdit: widget.onEdit,
                  onDelete: widget.onDelete,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _BatchTile extends StatelessWidget {
  const _BatchTile({
    required this.batch,
    required this.onEdit,
    required this.onDelete,
  });

  final BatchModel batch;
  final ValueChanged<BatchModel> onEdit;
  final ValueChanged<BatchModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.batchNumber,
                  style: AppTextStyles.tableCell.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeadline,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Qty ${batch.quantity}  ·  Exp ${batch.expiryDate}',
                  style: AppTextStyles.tableCell.copyWith(
                    fontSize: 12,
                    color: AppColors.textBody,
                  ),
                ),
                Text(
                  'Buy ${batch.purchasePrice.toStringAsFixed(2)}  ·  '
                  'Sell ${batch.sellingPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.tableCell.copyWith(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit, size: 18, color: AppColors.textBody),
            onPressed: () => onEdit(batch),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline,
              size: 18,
              color: AppColors.error,
            ),
            onPressed: () => onDelete(batch),
          ),
        ],
      ),
    );
  }
}

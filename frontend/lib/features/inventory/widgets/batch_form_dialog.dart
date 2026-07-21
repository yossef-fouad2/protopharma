import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../drugs/models/batch_model.dart';

/// Result returned by [BatchFormDialog] on save.
class BatchFormResult {
  const BatchFormResult({
    required this.quantity,
    required this.batchNumber,
    required this.expiryDate,
    required this.purchasePrice,
    required this.sellingPrice,
  });

  final int quantity;
  final String batchNumber;

  /// ISO-8601 date string (yyyy-MM-dd).
  final String expiryDate;
  final double purchasePrice;
  final double sellingPrice;
}

/// Modal form for adding or editing an inventory batch (lot).
///
/// Pass an existing [batch] to edit it, or omit it to add a new one. Returns a
/// [BatchFormResult] via `Navigator.pop` when saved, or null when cancelled.
class BatchFormDialog extends StatefulWidget {
  const BatchFormDialog({super.key, this.batch});

  final BatchModel? batch;

  bool get isEditing => batch != null;

  static Future<BatchFormResult?> show(
    BuildContext context, {
    BatchModel? batch,
  }) {
    return showDialog<BatchFormResult>(
      context: context,
      builder: (_) => BatchFormDialog(batch: batch),
    );
  }

  @override
  State<BatchFormDialog> createState() => _BatchFormDialogState();
}

class _BatchFormDialogState extends State<BatchFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _quantity;
  late final TextEditingController _batchNumber;
  late final TextEditingController _purchasePrice;
  late final TextEditingController _sellingPrice;
  late DateTime _expiry;

  @override
  void initState() {
    super.initState();
    final b = widget.batch;
    _quantity = TextEditingController(text: b?.quantity.toString() ?? '');
    _batchNumber = TextEditingController(text: b?.batchNumber ?? '');
    _purchasePrice = TextEditingController(
      text: b != null ? b.purchasePrice.toStringAsFixed(2) : '',
    );
    _sellingPrice = TextEditingController(
      text: b != null ? b.sellingPrice.toStringAsFixed(2) : '',
    );
    _expiry = b != null
        ? (DateTime.tryParse(b.expiryDate) ??
              DateTime.now().add(const Duration(days: 365)))
        : DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _quantity.dispose();
    _batchNumber.dispose();
    _purchasePrice.dispose();
    _sellingPrice.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      BatchFormResult(
        quantity: int.parse(_quantity.text.trim()),
        batchNumber: _batchNumber.text.trim().isEmpty
            ? 'N/A'
            : _batchNumber.text.trim(),
        expiryDate: _fmtDate(_expiry),
        purchasePrice: double.parse(_purchasePrice.text.trim()),
        sellingPrice: double.parse(_sellingPrice.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.isEditing ? 'Edit Batch' : 'Add Batch',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 16),
                _field(_batchNumber, 'Batch / lot number'),
                _field(_quantity, 'Quantity', required: true, isInt: true),
                _field(
                  _purchasePrice,
                  'Purchase price (EGP)',
                  required: true,
                  isNumber: true,
                ),
                _field(
                  _sellingPrice,
                  'Selling price (EGP)',
                  required: true,
                  isNumber: true,
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: _pickExpiry,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Expiry date',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fmtDate(_expiry),
                          style: AppTextStyles.tableCell.copyWith(
                            color: AppColors.textHeadline,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                      ),
                      onPressed: _submit,
                      child: Text(widget.isEditing ? 'Save' : 'Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = false,
    bool isNumber = false,
    bool isInt = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: (isNumber || isInt)
            ? TextInputType.numberWithOptions(decimal: isNumber)
            : TextInputType.text,
        style: AppTextStyles.tableCell.copyWith(color: AppColors.textHeadline),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final v = value?.trim() ?? '';
          if (required && v.isEmpty) return 'Required';
          if (isInt && v.isNotEmpty) {
            final parsed = int.tryParse(v);
            if (parsed == null) return 'Enter a whole number';
            if (parsed < 0) return 'Must be zero or positive';
          }
          if (isNumber && v.isNotEmpty) {
            final parsed = double.tryParse(v);
            if (parsed == null) return 'Enter a valid number';
            if (parsed < 0) return 'Must be zero or positive';
          }
          return null;
        },
      ),
    );
  }
}

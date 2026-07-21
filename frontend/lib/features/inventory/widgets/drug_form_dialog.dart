import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../drugs/models/drug_model.dart';

/// Result returned by [DrugFormDialog] on save.
class DrugFormResult {
  const DrugFormResult({
    required this.commercialNameEn,
    required this.commercialNameAR,
    required this.scientificName,
    required this.manufacturer,
    required this.drugClass,
    required this.route,
    required this.priceEGP,
  });

  final String commercialNameEn;
  final String commercialNameAR;
  final String scientificName;
  final String manufacturer;
  final String drugClass;
  final String route;
  final double priceEGP;
}

/// Modal form for creating or editing a drug's catalog metadata.
///
/// Pass an existing [drug] to edit it, or omit it to create a new one. Returns
/// a [DrugFormResult] via `Navigator.pop` when saved, or null when cancelled.
class DrugFormDialog extends StatefulWidget {
  const DrugFormDialog({super.key, this.drug});

  final DrugModel? drug;

  bool get isEditing => drug != null;

  static Future<DrugFormResult?> show(BuildContext context, {DrugModel? drug}) {
    return showDialog<DrugFormResult>(
      context: context,
      builder: (_) => DrugFormDialog(drug: drug),
    );
  }

  @override
  State<DrugFormDialog> createState() => _DrugFormDialogState();
}

class _DrugFormDialogState extends State<DrugFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameEn;
  late final TextEditingController _nameAr;
  late final TextEditingController _scientific;
  late final TextEditingController _manufacturer;
  late final TextEditingController _drugClass;
  late final TextEditingController _route;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final d = widget.drug;
    _nameEn = TextEditingController(text: d?.commercialNameEn ?? '');
    _nameAr = TextEditingController(text: d?.commercialNameAR ?? '');
    _scientific = TextEditingController(text: d?.scientificName ?? '');
    _manufacturer = TextEditingController(text: d?.manufacturer ?? '');
    _drugClass = TextEditingController(text: d?.drugClass ?? '');
    _route = TextEditingController(text: d?.route ?? '');
    _price = TextEditingController(
      text: d != null ? d.priceEGP.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _scientific.dispose();
    _manufacturer.dispose();
    _drugClass.dispose();
    _route.dispose();
    _price.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    String orNa(String v) => v.trim().isEmpty ? 'N/A' : v.trim();

    Navigator.of(context).pop(
      DrugFormResult(
        commercialNameEn: _nameEn.text.trim(),
        commercialNameAR: orNa(_nameAr.text),
        scientificName: orNa(_scientific.text),
        manufacturer: orNa(_manufacturer.text),
        drugClass: orNa(_drugClass.text),
        route: orNa(_route.text),
        priceEGP: double.parse(_price.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.isEditing ? 'Edit Medication' : 'Add Medication',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 16),
                _field(_nameEn, 'Commercial name (EN)', required: true),
                _field(_nameAr, 'Commercial name (AR)'),
                _field(_scientific, 'Scientific name'),
                _field(_manufacturer, 'Manufacturer'),
                _field(_drugClass, 'Category / drug class'),
                _field(_route, 'Route'),
                _field(_price, 'Price (EGP)', required: true, isNumber: true),
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
                      child: Text(widget.isEditing ? 'Save' : 'Create'),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
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

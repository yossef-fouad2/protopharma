import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protopharma/core/config/app_theme.dart';

/// Recent Activity table showing the latest pharmacy operations.
class RecentActivityTable extends StatelessWidget {
  const RecentActivityTable({super.key});

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
          // Header
          Container(
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
                  onTap: () {},
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
          ),

          // Table content
          Expanded(
            child: SingleChildScrollView(
              child: _buildTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
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
            _headerCell('Patient / Ref'),
            _headerCell('Action'),
            _headerCell('Status', align: TextAlign.right),
          ],
        ),
        // Data rows
        ..._demoRows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : AppColors.background,
              border: const Border(
                bottom: BorderSide(color: AppColors.borderDark, width: 0.5),
              ),
            ),
            children: [
              _dataCell(row.time, color: AppColors.textMuted),
              _patientCell(row.patient, row.refCode),
              _dataCell(row.action),
              _statusCell(row.status, row.statusType),
            ],
          );
        }),
      ],
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

  Widget _patientCell(String name, String refCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeadline,
            ),
          ),
          Text(
            refCode,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _statusCell(String label, _StatusType type) {
    final (Color bg, Color fg, Color border) = switch (type) {
      _StatusType.completed => (
        const Color(0xFFE8F5E9),
        const Color(0xFF00714D),
        const Color(0xFF00714D).withValues(alpha: 0.2),
      ),
      _StatusType.pending => (
        const Color(0xFFE8EAF6),
        const Color(0xFF283593),
        const Color(0xFF283593).withValues(alpha: 0.2),
      ),
      _StatusType.processed => (
        const Color(0xFFE8F5E9),
        const Color(0xFF00714D),
        const Color(0xFF00714D).withValues(alpha: 0.2),
      ),
      _StatusType.hold => (
        const Color(0xFFFFEBEE),
        const Color(0xFF93000A),
        const Color(0xFF93000A).withValues(alpha: 0.2),
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
            label,
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
}

// ── Demo data ──

enum _StatusType { completed, pending, processed, hold }

class _ActivityRow {
  const _ActivityRow(
    this.time,
    this.patient,
    this.refCode,
    this.action,
    this.status,
    this.statusType,
  );
  final String time;
  final String patient;
  final String refCode;
  final String action;
  final String status;
  final _StatusType statusType;
}

const _demoRows = [
  _ActivityRow('10:42 AM', 'John Doe', 'RX-98234-A',
      'Amoxicillin 500mg Dispensed', 'Completed', _StatusType.completed),
  _ActivityRow('10:38 AM', 'Sarah Jenkins', 'RX-98235-B',
      'Lisinopril 10mg Verification', 'Pending', _StatusType.pending),
  _ActivityRow('10:15 AM', 'Inventory System', 'INV-PO-442',
      'McKesson Order Received', 'Processed', _StatusType.processed),
  _ActivityRow('09:55 AM', 'Robert Chen', 'RX-98230-C',
      'Atorvastatin 20mg Refill', 'Insurance Hold', _StatusType.hold),
  _ActivityRow('09:30 AM', 'Maria Garcia', 'RX-98228-A',
      'Metformin 1000mg Dispensed', 'Completed', _StatusType.completed),
];

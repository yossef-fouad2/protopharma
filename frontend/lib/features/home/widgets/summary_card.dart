import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protopharma/core/config/app_theme.dart';

/// A single metric card used in the summary row.
///
/// Set [isAccented] to `true` for the dark inverted variant (e.g. Active Prescriptions).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.subtitle,
    this.subtitleIcon,
    this.subtitleColor,
    this.isAccented = false,
    this.actionLabel,
    this.onActionTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final String subtitle;
  final IconData? subtitleIcon;
  final Color? subtitleColor;
  final bool isAccented;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final bg = isAccented ? AppColors.textHeadline : Colors.white;
    final fg = isAccented ? Colors.white : AppColors.textHeadline;
    final mutedFg = isAccented
        ? Colors.white.withValues(alpha: 0.65)
        : AppColors.textMuted;
    final iconBg = isAccented
        ? Colors.white.withValues(alpha: 0.12)
        : AppColors.surfaceContainerLow;
    final iconFg = isAccented ? Colors.white.withValues(alpha: 0.8) : fg;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(
          color: isAccented ? Colors.transparent : AppColors.borderDark,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isAccented ? 0.08 : 0.04),
            blurRadius: isAccented ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: mutedFg,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconFg),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Value + subtitle + optional action
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.publicSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: fg,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (subtitleIcon != null) ...[
                          Icon(
                            subtitleIcon,
                            size: 16,
                            color: subtitleColor ?? mutedFg,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: subtitleColor ?? mutedFg,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Optional action button (e.g. "Review")
              if (actionLabel != null)
                Material(
                  color: isAccented ? Colors.white : AppColors.textHeadline,
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    onTap: onActionTap ?? () {},
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        actionLabel!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isAccented ? AppColors.textHeadline : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

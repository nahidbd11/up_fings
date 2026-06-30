import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class ProjectListTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showSanctionButton;
  final String? sanctionLabel;
  final VoidCallback? onSanction;

  const ProjectListTile({
    super.key,
    required this.project,
    required this.onTap,
    this.trailing,
    this.showSanctionButton = false,
    this.sanctionLabel,
    this.onSanction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: project.hasDuplicateAlert ? AppColors.warningBorder : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project.hasDuplicateAlert)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.warningBorder),
                            ),
                            child: Text('⚠️ Duplicate Alert', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                          ),
                        ),
                      Text(
                        project.name,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        project.nameBn,
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: project.status),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _MetaItem(icon: Icons.tag, text: project.id),
                _MetaItem(icon: Icons.location_on_outlined, text: '${project.ward} · ${project.union.split('/').first.trim()}'),
                _MetaItem(icon: Icons.attach_money, text: '৳ ${_formatMoney(project.cost)}'),
              ],
            ),
            if (project.completionPercent > 0 && project.status == ProjectStatus.ongoing) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: project.completionPercent / 100,
                        backgroundColor: AppColors.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          project.completionPercent >= 80 ? AppColors.success : AppColors.warning,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${project.completionPercent}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                ],
              ),
            ],
            if (showSanctionButton && onSanction != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSanction,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: Text(sanctionLabel ?? 'Action', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
            if (trailing != null) ...[const SizedBox(height: 10), trailing!],
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(text, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
      ],
    );
  }
}

String _formatMoney(double amount) {
  if (amount >= 100000) {
    return '${(amount / 100000).toStringAsFixed(1)} L';
  }
  if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
  return amount.toStringAsFixed(0);
}

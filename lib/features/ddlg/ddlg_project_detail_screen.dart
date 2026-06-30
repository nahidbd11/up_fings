import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class DdlgProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const DdlgProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final p = MockData.allProjects.firstWhere((pr) => pr.id == projectId, orElse: () => MockData.allProjects[0]);

    return AppScaffold(
      title: 'Project Details / প্রকল্পের বিবরণ',
      subtitle: 'DDLG Read-Only View',
      user: MockData.ddlgUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('Read-only view — DDLG can monitor but not modify projects.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Project Overview / প্রকল্পের সারসংক্ষেপ',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Row('Project ID', p.id),
                _Row('Name', p.name),
                _Row('Bangla Name', p.nameBn),
                _Row('Type', p.type),
                _Row('Fund Source', p.fundSource.name.toUpperCase()),
                _Row('Ward / Area', p.ward),
                _Row('Total Cost', '৳ ${p.cost >= 100000 ? "${(p.cost / 100000).toStringAsFixed(2)} L" : p.cost.toStringAsFixed(0)}'),
                _Row('Timeline', '${p.startDate} → ${p.endDate}'),
                _Row('Fiscal Year', p.fiscalYear),
                _Row('Progress', '${p.progressPercent.toStringAsFixed(0)}%'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Progress / অগ্রগতি',
            leadingEmoji: '📊',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Completion', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
                    Text('${p.progressPercent.toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.success)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: p.progressPercent / 100,
                    backgroundColor: AppColors.cardBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(p.currentStage, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Budget Breakdown / বাজেট বিভাজন',
            leadingEmoji: '💰',
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ...p.khatwariRows.map((row) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.description, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                      Text('৳ ${row.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      Expanded(child: Text('Total', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      Text('৳ ${p.khatwariRows.fold<double>(0, (s, r) => s + r.amount).toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

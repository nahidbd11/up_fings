import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class EngineerProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const EngineerProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final p = MockData.allProjects.firstWhere((pr) => pr.id == projectId, orElse: () => MockData.allProjects[0]);

    return AppScaffold(
      title: 'Project Details / প্রকল্পের বিবরণ',
      subtitle: p.id,
      user: MockData.engineerUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: 'Project Information / প্রকল্পের তথ্য',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Row('Project ID', p.id),
                _Row('Name / নাম', p.name),
                _Row('Bangla', p.nameBn),
                _Row('Type / ধরন', p.type),
                _Row('Fund Source', p.fundSource.name.toUpperCase()),
                _Row('Ward', p.ward),
                _Row('Cost / ব্যয়', '৳ ${p.cost >= 100000 ? "${(p.cost / 100000).toStringAsFixed(2)} L" : p.cost.toStringAsFixed(0)}'),
                _Row('Start Date', p.startDate),
                _Row('End Date', p.endDate),
                _Row('Fiscal Year', p.fiscalYear),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Khatwari BOQ / খতিয়ারি বিওকিউ',
            leadingEmoji: '📊',
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ...p.khatwariRows.map((row) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.description, style: GoogleFonts.inter(fontSize: 13))),
                      Text('৳ ${row.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      Expanded(child: Text('Total', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      Text('৳ ${p.khatwariRows.fold<double>(0, (s, r) => s + r.amount).toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'GPS & Location / জিপিএস ও অবস্থান',
            leadingEmoji: '📍',
            child: Column(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(color: const Color(0xFFE8F4F8), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.infoBorder)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined, size: 32, color: AppColors.primary),
                        const SizedBox(height: 6),
                        Text('${p.gpsLat}, ${p.gpsLng}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('GPS Coordinates', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Assigned sub-engineers
          SectionCard(
            title: 'Assigned Sub-Engineers / নিয়োগপ্রাপ্ত উপ-প্রকৌশলী',
            leadingEmoji: '👷',
            padding: EdgeInsets.zero,
            child: Column(
              children: MockData.subEngineers.take(2).map((se) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                child: Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: AppColors.engineerBg, child: Text(se.name[0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.engineerFg))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(se.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('${se.designation} · ${se.phone}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Text(se.area, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),

          if (p.status == ProjectStatus.awaitingEngineerVet)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.engineering, size: 18),
                label: const Text('Start Technical Vetting / যাচাই শুরু করুন'),
                onPressed: () => context.push('/engineer/vet/${p.id}'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.engineerFg, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
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


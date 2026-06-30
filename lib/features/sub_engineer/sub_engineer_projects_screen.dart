import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_badge.dart';

class SubEngineerProjectsScreen extends StatelessWidget {
  const SubEngineerProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = MockData.allProjects.take(5).toList();
    return AppScaffold(
      title: 'My Projects / আমার প্রকল্প',
      subtitle: 'Ward 1-3 Field Monitoring',
      user: MockData.subEngineerUser,
      navItems: const [],
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final p = projects[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('${p.nameBn} · ${p.id}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    StatusBadge(status: p.status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(child: Text(p.ward, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                    Text('৳ ${p.cost >= 100000 ? "${(p.cost / 100000).toStringAsFixed(1)} L" : p.cost.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Progress / অগ্রগতি', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted))),
                        Text('${p.progressPercent.toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: p.progressPercent / 100,
                        backgroundColor: AppColors.cardBorder,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.engineerFg),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined, size: 16),
                        label: const Text('Upload Photos'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload (simulated)'))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.engineerFg, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.note_add_outlined, size: 16),
                        label: const Text('Field Notes'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Field notes (simulated)'))),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), foregroundColor: AppColors.engineerFg),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

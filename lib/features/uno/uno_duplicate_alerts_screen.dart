import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';

class UnoDuplicateAlertsScreen extends StatelessWidget {
  const UnoDuplicateAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Duplicate Alerts / সন্দেহজনক প্রকল্প',
      subtitle: 'AI-powered similarity detection',
      user: MockData.unoUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚨 AI Duplicate Detection / এআই সনাক্তকরণ', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                const SizedBox(height: 4),
                Text(
                  'The system automatically scans for projects with similar names, locations, or GPS coordinates to prevent double-spending of public funds.\n\nসিস্টেম স্বয়ংক্রিয়ভাবে একই এলাকায় একই ধরনের প্রকল্প শনাক্ত করে।',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF991B1B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('${MockData.duplicateAlerts.length} Active Alerts / সক্রিয় সতর্কতা', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
          const SizedBox(height: 12),

          ...MockData.duplicateAlerts.map((alert) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x08F87171), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Text('${(alert.similarityScore * 100).toStringAsFixed(0)}% Similar / একই রকম', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.error)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PairCard('Project A / প্রকল্প ক', alert.project1Id, alert.project1Name, const Color(0xFFFFF1F2), const Color(0xFFFECACA)),
                const SizedBox(height: 8),
                _PairCard('Project B / প্রকল্প খ', alert.project2Id, alert.project2Name, const Color(0xFFFFF7ED), const Color(0xFFFDE68A)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Similarity Factors / মিলের কারণসমূহ:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      ...alert.matchReasons.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('⚠️ ', style: GoogleFonts.inter(fontSize: 11)),
                            Expanded(child: Text(r, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary))),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.block, size: 14),
                        label: const Text('Flag Duplicate'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flagged as duplicate. Secretary notified.'), backgroundColor: AppColors.error)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.check_circle_outline, size: 14),
                        label: const Text('Mark as OK'),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cleared — not a duplicate.'), backgroundColor: AppColors.success)),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), foregroundColor: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _PairCard extends StatelessWidget {
  final String label;
  final String projectId;
  final String projectName;
  final Color bg;
  final Color border;

  const _PairCard(this.label, this.projectId, this.projectName, this.bg, this.border);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(projectName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(projectId, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }
}

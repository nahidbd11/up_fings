import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';

class UnoMeetingMinutesScreen extends StatelessWidget {
  const UnoMeetingMinutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Meeting Minutes / কার্যবিবরণী',
      subtitle: 'All Union Parishads — Narayanganj Sadar',
      user: MockData.unoUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Text(
              'ℹ️ Meeting minutes submitted by UP Administrators are shown here. As UNO, you can review and download them.\n\nইউপি প্রশাসকের দেওয়া কার্যবিবরণী এখানে দেখা যাচ্ছে।',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),

          ...MockData.minutesList.map((m) => Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                          Text(m.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('${m.unionName} · ${m.date}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.successBorder)),
                      child: Text(m.status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${m.presentMembers}/${m.totalMembers} present', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(child: Text(m.venue, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight))),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Text('Decisions:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                ...m.decisions.take(2).map((d) => Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      Expanded(child: Text(d, style: GoogleFonts.inter(fontSize: 12))),
                    ],
                  ),
                )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                      child: Text('View Full / পূর্ণ দেখুন', style: GoogleFonts.inter(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download_outlined, size: 14),
                      label: Text('Download', style: GoogleFonts.inter(fontSize: 12)),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
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

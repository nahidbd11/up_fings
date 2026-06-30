import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';

class SecretaryMinutesListScreen extends StatelessWidget {
  const SecretaryMinutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Meeting Minutes / কার্যবিবরণী তালিকা',
      subtitle: 'Fatullah Union — All submitted minutes',
      user: MockData.secretaryUser,
      navItems: const [],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/secretary/minutes/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Minutes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.minutesList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final m = MockData.minutesList[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
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
                          Text(m.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('${m.unionName} · ${m.date}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.successBorder),
                      ),
                      child: Text(m.status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _MetaChip(icon: Icons.people_outline, text: '${m.presentMembers}/${m.totalMembers} present'),
                    _MetaChip(icon: Icons.location_on_outlined, text: m.venue),
                    _MetaChip(icon: Icons.person_outline, text: 'By: ${m.submittedBy}'),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Text('Key Decisions:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                ...m.decisions.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      Expanded(child: Text(d, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textPrimary))),
                    ],
                  ),
                )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                      child: Text('View Full', style: GoogleFonts.inter(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download_outlined, size: 14),
                      label: Text('Download PDF', style: GoogleFonts.inter(fontSize: 12)),
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaChip({required this.icon, required this.text});

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

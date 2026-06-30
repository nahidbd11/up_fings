import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';

class UnoDashboardScreen extends StatelessWidget {
  const UnoDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/uno/dashboard'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'All Projects / সকল প্রকল্প', route: '/uno/projects'),
    NavigationItem(icon: Icons.warning_amber_outlined, activeIcon: Icons.warning_amber, label: 'Duplicate Alerts / সন্দেহজনক প্রকল্প', route: '/uno/duplicate-alerts'),
    NavigationItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Meeting Minutes / কার্যবিবরণী', route: '/uno/meeting-minutes'),
    NavigationItem(icon: Icons.approval_outlined, activeIcon: Icons.approval, label: 'Sanction / অনুমোদন পত্র', route: '/uno/sanction/PM-2026-W03-041'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'UNO Dashboard / ড্যাশবোর্ড',
      subtitle: 'Narayanganj Sadar Upazila',
      user: MockData.unoUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // UNO overview header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Narayanganj Sadar Upazila', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('নারায়ণগঞ্জ সদর উপজেলা · 5 Union Parishads', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _WhiteStatPill('156', 'Total Projects'),
                      const SizedBox(width: 10),
                      _WhiteStatPill('62', 'Ongoing'),
                      const SizedBox(width: 10),
                      _WhiteStatPill('3', 'Sanction Needed'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sanction pending alert
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warningBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⚠️ 3 Projects Awaiting UNO Sanction / অনুমোদনের অপেক্ষায়', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                  const SizedBox(height: 4),
                  Text('Chairman has approved these projects. Issue sanction orders to proceed.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF78350F))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/uno/sanction/PM-2026-W03-041'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                      child: Text('📋 Issue Sanction / অনুমোদন পত্র দিন', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Duplicate alerts
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Text('🚨', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2 Duplicate Project Alerts', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
                        Text('AI-detected similarity ≥ 85% — review immediately', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF991B1B))),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/uno/duplicate-alerts'),
                    child: Text('Review', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StatCardWidget(value: '156', label: 'Total Projects', labelBn: 'মোট প্রকল্প', icon: Icons.folder, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
                StatCardWidget(value: '62', label: 'Ongoing', labelBn: 'চলমান', icon: Icons.construction, iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFF9A3412)),
                StatCardWidget(value: '3', label: 'Sanction Pending', labelBn: 'অনুমোদন বাকি', icon: Icons.pending_actions, iconBg: AppColors.warningLight, iconColor: AppColors.warning, isHighlighted: true),
                StatCardWidget(value: '5', label: 'Union Parishads', labelBn: 'ইউনিয়ন পরিষদ', icon: Icons.location_city, iconBg: AppColors.successLight, iconColor: AppColors.success),
              ],
            ),
            const SizedBox(height: 20),

            // Union summary
            SectionCard(
              title: 'Union Parishad Summary / ইউনিয়ন পরিষদ সারসংক্ষেপ',
              leadingEmoji: '🏘️',
              padding: EdgeInsets.zero,
              child: Column(
                children: MockData.unionSummaries.map((u) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(u.code, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Text('${u.totalProjects} total', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: u.ongoingProjects > 0 ? AppColors.primaryLight : AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${u.ongoingProjects} ongoing', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: u.ongoingProjects > 0 ? AppColors.primary : AppColors.success)),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Quick actions
            SectionCard(
              title: 'Quick Actions / দ্রুত অ্যাকশন',
              leadingEmoji: '⚡',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuickActionChip(Icons.approval, 'Issue Sanction', () => context.push('/uno/sanction/PM-2026-W03-041')),
                  _QuickActionChip(Icons.warning_amber, 'Duplicate Alerts', () => context.go('/uno/duplicate-alerts')),
                  _QuickActionChip(Icons.folder_open, 'View Projects', () => context.go('/uno/projects')),
                  _QuickActionChip(Icons.menu_book, 'Meeting Minutes', () => context.go('/uno/meeting-minutes')),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WhiteStatPill extends StatelessWidget {
  final String value;
  final String label;

  const _WhiteStatPill(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: AppColors.primary),
      label: Text(label, style: GoogleFonts.inter(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.infoBorder),
    );
  }
}



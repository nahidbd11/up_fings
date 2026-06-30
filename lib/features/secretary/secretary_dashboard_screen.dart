import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class SecretaryDashboardScreen extends StatelessWidget {
  const SecretaryDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/secretary/dashboard'),
    NavigationItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Duplicate Check / সদৃশ যাচাই', route: '/secretary/duplicate-check'),
    NavigationItem(icon: Icons.add_circle_outline, activeIcon: Icons.add_circle, label: 'Create Project / প্রকল্প তৈরি', route: '/secretary/create-project'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'Projects / প্রকল্পসমূহ', route: '/secretary/projects'),
    NavigationItem(icon: Icons.photo_outlined, activeIcon: Icons.photo, label: 'Update Progress / অগ্রগতি', route: '/secretary/projects/PM-2026-W05-002/progress'),
    NavigationItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today, label: 'Extend Deadline / সময় বৃদ্ধি', route: '/secretary/projects/PM-2026-W05-002/extend'),
    NavigationItem(icon: Icons.check_circle_outline, activeIcon: Icons.check_circle, label: 'Mark Complete / সম্পন্ন করুন', route: '/secretary/projects/PM-2026-W07-010/complete'),
    NavigationItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Minutes List / তালিকা', route: '/secretary/minutes'),
    NavigationItem(icon: Icons.edit_note_outlined, activeIcon: Icons.edit_note, label: 'New Minutes / নতুন কার্যবিবরণী', route: '/secretary/minutes/new'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = MockData.secretaryUser;
    return AppScaffold(
      title: 'Dashboard / ড্যাশবোর্ড',
      subtitle: 'Administrator · Fatullah Union, Narayanganj Sadar',
      user: user,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Page header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overview / সার্বিক চিত্র', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('Fatullah Union Parishad · UP Code: BD-NAR-SJR-UP05 · FY 2025-26', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note, size: 16),
                  label: const Text('New Minutes'),
                  onPressed: () => context.push('/secretary/minutes/new'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action-needed banners
            _ActionBanner(
              icon: '⚡',
              title: '1 Project Needs Attention',
              subtitle: 'PM-2026-W03-041 was sent back by Chairman. Please revise.',
              bg: AppColors.errorLight,
              border: AppColors.errorBorder,
              buttonLabel: 'Review',
              buttonColor: AppColors.error,
              onTap: () => context.go('/secretary/projects'),
            ),
            const SizedBox(height: 10),
            _ActionBanner(
              icon: '📋',
              title: 'Submit May 2026 Meeting Minutes',
              subtitle: 'Last submitted: April 2026. Monthly minutes are due.',
              bg: AppColors.warningLight,
              border: AppColors.warningBorder,
              buttonLabel: 'Submit Now',
              buttonColor: AppColors.warning,
              onTap: () => context.push('/secretary/minutes/new'),
            ),
            const SizedBox(height: 20),

            // Stat grid
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StatCardWidget(value: '34', label: 'Total Projects', labelBn: 'মোট প্রকল্প', icon: Icons.folder, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
                StatCardWidget(value: '14', label: 'Ongoing', labelBn: 'চলমান', icon: Icons.construction, iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFF9A3412)),
                StatCardWidget(value: '17', label: 'Completed', labelBn: 'সম্পন্ন', icon: Icons.check_circle_outline, iconBg: AppColors.successLight, iconColor: AppColors.success),
                StatCardWidget(value: '1', label: 'Awaiting Approval', labelBn: 'অনুমোদনের অপেক্ষায়', icon: Icons.hourglass_empty, iconBg: AppColors.warningLight, iconColor: AppColors.warning, isHighlighted: true),
              ],
            ),
            const SizedBox(height: 20),

            // Quick actions
            Text('Quick Actions / দ্রুত অ্যাকশন', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _QuickAction(icon: '⚠️', label: 'Duplicate Check', labelBn: 'সদৃশ যাচাই', highlighted: true, onTap: () => context.push('/secretary/duplicate-check')),
                _QuickAction(icon: '➕', label: 'Create Project', labelBn: 'প্রকল্প তৈরি', onTap: () => context.push('/secretary/create-project')),
                _QuickAction(icon: '📁', label: 'Projects', labelBn: 'প্রকল্পসমূহ', onTap: () => context.go('/secretary/projects')),
                _QuickAction(icon: '📊', label: 'Update Progress', labelBn: 'অগ্রগতি', onTap: () => context.push('/secretary/projects/PM-2026-W05-002/progress')),
                _QuickAction(icon: '📅', label: 'Extend Deadline', labelBn: 'সময় বৃদ্ধি', onTap: () => context.push('/secretary/projects/PM-2026-W05-002/extend')),
                _QuickAction(icon: '📝', label: 'New Minutes', labelBn: 'নতুন কার্যবিবরণী', onTap: () => context.push('/secretary/minutes/new')),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Projects
            SectionCard(
              title: 'Recent Projects / সাম্প্রতিক প্রকল্প',
              leadingEmoji: '📁',
              trailing: TextButton(
                onPressed: () => context.go('/secretary/projects'),
                child: const Text('View All'),
              ),
              padding: EdgeInsets.zero,
              child: Column(
                children: MockData.allProjects.take(4).map((p) {
                  return _ProjectRow(project: p, onTap: () => context.go('/secretary/projects'));
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Activity feed
            SectionCard(
              title: 'Recent Activity / সাম্প্রতিক কার্যক্রম',
              leadingEmoji: '📋',
              child: Column(
                children: MockData.recentActivity.take(5).map((a) => _ActivityRow(item: a)).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ActionBanner extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color bg;
  final Color border;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback onTap;

  const _ActionBanner({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.border,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon;
  final String label;
  final String labelBn;
  final bool highlighted;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.labelBn, required this.onTap, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.warningLight : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: highlighted ? AppColors.warningBorder : AppColors.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(labelBn, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectRow({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('${project.ward} · ${project.union.split('/').first.trim()} · ${project.id}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: project.status),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;

  const _ActivityRow({required this.item});

  Color get _dotColor {
    switch (item.type) {
      case ActivityType.completed: return AppColors.success;
      case ActivityType.warning: return AppColors.error;
      case ActivityType.progress: return AppColors.warning;
      case ActivityType.minutes: return AppColors.purple;
      case ActivityType.new_: return AppColors.blue;
      default: return AppColors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(width: 8, height: 8, decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(item.subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(item.time, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}



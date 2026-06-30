import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';

class ChairmanDashboardScreen extends StatelessWidget {
  const ChairmanDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/chairman/dashboard'),
    NavigationItem(icon: Icons.new_releases_outlined, activeIcon: Icons.new_releases, label: 'New Proposals / নতুন প্রস্তাব', route: '/chairman/approve/PM-2026-W03-041'),
    NavigationItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Budget Review / বাজেট পর্যালোচনা', route: '/chairman/budget-review/PM-2026-W05-002'),
    NavigationItem(icon: Icons.check_circle_outline, activeIcon: Icons.check_circle, label: 'Completion Review / সমাপ্তি যাচাই', route: '/chairman/review/PM-2026-W07-010'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'All Projects / সকল প্রকল্প', route: '/secretary/projects'),
    NavigationItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Meeting Minutes / কার্যবিবরণী', route: '/uno/meeting-minutes'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard / ড্যাশবোর্ড',
      subtitle: 'Chairman · Fatullah Union Parishad',
      user: MockData.chairmanUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overview / সার্বিক চিত্র', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('Fatullah Union Parishad · BD-NAR-SJR-UP05 · NJ Sadar', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Review Pending (2)'),
                  onPressed: () => context.push('/chairman/review/PM-2026-W07-010'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // New project proposal banner
            _AlertBanner(
              emoji: '⚡',
              title: '1 New Project Proposal — Awaiting Your Approval',
              subtitle: 'Submitted by Rahim Uddin (UP Administrator) · 29 Jun 2026\nPM-2026-W03-041 · Ward-3 Main Road Repair',
              bg: AppColors.infoLight,
              border: AppColors.infoBorder,
              titleColor: AppColors.primary,
              subtitleColor: const Color(0xFF1E40AF),
              buttonLabel: '🔎 Review New Project',
              buttonColor: AppColors.primary,
              onTap: () => context.push('/chairman/approve/PM-2026-W03-041'),
            ),
            const SizedBox(height: 10),

            // Completion approval alert
            _AlertBanner(
              emoji: '⚡',
              title: '2 Projects Awaiting Your Approval',
              subtitle: 'Administrator has submitted completion for your review. Please approve or send back.',
              bg: AppColors.warningLight,
              border: AppColors.warningBorder,
              titleColor: const Color(0xFF92400E),
              subtitleColor: const Color(0xFF78350F),
              buttonLabel: '✅ Review Now',
              buttonColor: AppColors.warning,
              onTap: () => context.push('/chairman/review/PM-2026-W07-010'),
            ),
            const SizedBox(height: 20),

            // Stats
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
                StatCardWidget(value: '2', label: 'Awaiting Approval', labelBn: 'অনুমোদনের অপেক্ষায়', icon: Icons.hourglass_empty, iconBg: AppColors.warningLight, iconColor: AppColors.warning, isHighlighted: true),
              ],
            ),
            const SizedBox(height: 20),

            // Awaiting approval cards
            SectionCard(
              title: 'Awaiting Your Approval / অনুমোদনের অপেক্ষায়',
              leadingEmoji: '⏳',
              trailing: TextButton(onPressed: () => context.push('/chairman/review/PM-2026-W07-010'), child: const Text('Review All')),
              child: Column(
                children: [
                  _ApprovalCard(
                    title: 'Ward-7 Mosque Expansion',
                    titleBn: 'ওয়ার্ড-৭ মসজিদ সম্প্রসারণ',
                    projectId: 'PM-2026-W07-010',
                    cost: '৳ 4,90,000',
                    completedDate: '30 Nov 2025',
                    photos: 4,
                    docs: 2,
                    onReview: () => context.push('/chairman/review/PM-2026-W07-010'),
                  ),
                  const SizedBox(height: 12),
                  _ApprovalCard(
                    title: 'Ward-6 Footpath Construction',
                    titleBn: 'ওয়ার্ড-৬ ফুটপাথ নির্মাণ',
                    projectId: 'PM-2026-W06-013',
                    cost: '৳ 2,10,000',
                    completedDate: '30 Apr 2026',
                    photos: 5,
                    docs: 3,
                    onReview: () => context.push('/chairman/review/PM-2026-W06-013'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recently approved
            SectionCard(
              title: 'Recently Approved / সম্প্রতি অনুমোদিত',
              leadingEmoji: '✅',
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _RecentApprovalRow('Mosque Renovation', 'মসজিদ সংস্কার', 'Ward 2', '৳ 3,20,000', '5 Jun'),
                  _RecentApprovalRow('Market Road', 'বাজার সড়ক', 'Ward 1', '৳ 3,80,000', '28 Feb'),
                  _RecentApprovalRow('School Wall', 'স্কুল প্রাচীর', 'Ward 4', '৳ 5,60,000', '15 Jan'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Completion rate
            SectionCard(
              title: 'Completion Rate / সম্পন্নের হার',
              leadingEmoji: '📊',
              child: Column(
                children: [
                  _ProgressRow('Completed / সম্পন্ন', '50% (17/34)', 0.50, AppColors.success),
                  const SizedBox(height: 12),
                  _ProgressRow('Ongoing / চলমান', '41% (14/34)', 0.41, AppColors.warning),
                  const SizedBox(height: 8),
                  Text('FY 2025-26 · Fatullah Union · BD-NAR-SJR-UP05', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
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

class _AlertBanner extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bg;
  final Color border;
  final Color titleColor;
  final Color subtitleColor;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.emoji, required this.title, required this.subtitle,
    required this.bg, required this.border, required this.titleColor,
    required this.subtitleColor, required this.buttonLabel,
    required this.buttonColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: titleColor)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: subtitleColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10)),
              child: Text(buttonLabel, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final String title;
  final String titleBn;
  final String projectId;
  final String cost;
  final String completedDate;
  final int photos;
  final int docs;
  final VoidCallback onReview;

  const _ApprovalCard({
    required this.title, required this.titleBn, required this.projectId,
    required this.cost, required this.completedDate, required this.photos,
    required this.docs, required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warningBorder),
        boxShadow: const [BoxShadow(color: Color(0x0DFDE68A), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text('$titleBn · $projectId', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              Text('💰 $cost', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              Text('✅ Completed: $completedDate', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              Text('📷 $photos photos', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              Text('📄 $docs docs', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onReview,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  child: Text('✅ Review & Approve', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onReview,
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                child: Text('Details', style: GoogleFonts.inter(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentApprovalRow extends StatelessWidget {
  final String name;
  final String nameBn;
  final String ward;
  final String cost;
  final String date;

  const _RecentApprovalRow(this.name, this.nameBn, this.ward, this.cost, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(nameBn, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          Text(ward, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Text(cost, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          Text('📅 $date', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _ProgressRow(this.label, this.value, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
            Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.cardBorder,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}



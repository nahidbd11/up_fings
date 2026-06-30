import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';

class DdlgDashboardScreen extends StatelessWidget {
  const DdlgDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/ddlg/dashboard'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'All Projects / সকল প্রকল্প', route: '/ddlg/projects'),
    NavigationItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map View / মানচিত্র', route: '/ddlg/map'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DDLG Dashboard / ড্যাশবোর্ড',
      subtitle: 'Narayanganj District — Overview',
      user: MockData.ddlgUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // District header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.ddlgBg, Color(0xFF1B4332)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Narayanganj District', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ddlgFg)),
                  Text('নারায়ণগঞ্জ জেলা · Deputy Director LGD', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatPill('5', 'Upazilas'),
                      const SizedBox(width: 10),
                      _StatPill('23', 'Union Parishads'),
                      const SizedBox(width: 10),
                      _StatPill('847', 'Total Projects'),
                    ],
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
                StatCardWidget(value: '847', label: 'Total Projects', labelBn: 'মোট প্রকল্প', icon: Icons.folder, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
                StatCardWidget(value: '312', label: 'Ongoing', labelBn: 'চলমান', icon: Icons.construction, iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFF9A3412)),
                StatCardWidget(value: '494', label: 'Completed', labelBn: 'সম্পন্ন', icon: Icons.check_circle_outline, iconBg: AppColors.successLight, iconColor: AppColors.success),
                StatCardWidget(value: '৳ 4.2 Cr', label: 'Total Budget', labelBn: 'মোট বাজেট', icon: Icons.account_balance_wallet, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
              ],
            ),
            const SizedBox(height: 20),

            // Upazila summary
            SectionCard(
              title: 'Upazila Summary / উপজেলা সারসংক্ষেপ',
              leadingEmoji: '🏘️',
              trailing: TextButton(onPressed: () => context.go('/ddlg/map'), child: const Text('Map View')),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _UpazilaRow('Narayanganj Sadar', '156', '62', '৳ 1.2 Cr', 0.40),
                  _UpazilaRow('Fatullah', '210', '88', '৳ 1.6 Cr', 0.58),
                  _UpazilaRow('Siddhirganj', '180', '74', '৳ 1.0 Cr', 0.42),
                  _UpazilaRow('Rupganj', '145', '52', '৳ 0.8 Cr', 0.37),
                  _UpazilaRow('Araihazar', '156', '36', '৳ 0.6 Cr', 0.23),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // District performance
            SectionCard(
              title: 'District Performance / জেলা কর্মক্ষমতা',
              leadingEmoji: '📊',
              child: Column(
                children: [
                  _ProgressItem('Completion Rate / সম্পন্নের হার', '58%', 0.58, AppColors.success),
                  const SizedBox(height: 10),
                  _ProgressItem('Budget Utilization / বাজেট ব্যবহার', '71%', 0.71, AppColors.primary),
                  const SizedBox(height: 10),
                  _ProgressItem('On-time Delivery / সময়মতো সমাপ্তি', '45%', 0.45, AppColors.warning),
                  const SizedBox(height: 8),
                  Text('FY 2025-26 · Narayanganj District', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: const Text('All Projects'),
                    onPressed: () => context.go('/ddlg/projects'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: AppColors.ddlgBg, foregroundColor: AppColors.ddlgFg),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Map View'),
                    onPressed: () => context.go('/ddlg/map'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  const _StatPill(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _UpazilaRow extends StatelessWidget {
  final String name;
  final String total;
  final String ongoing;
  final String budget;
  final double completion;

  const _UpazilaRow(this.name, this.total, this.ongoing, this.budget, this.completion);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
              Text(budget, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$total total · $ongoing ongoing', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              const Spacer(),
              Text('${(completion * 100).toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: completion, backgroundColor: AppColors.cardBorder, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success), minHeight: 5),
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _ProgressItem(this.label, this.value, this.progress, this.color);

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
          child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.cardBorder, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 8),
        ),
      ],
    );
  }
}

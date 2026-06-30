import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';

class SubEngineerDashboardScreen extends StatelessWidget {
  const SubEngineerDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/sub-engineer/dashboard'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'My Projects / আমার প্রকল্প', route: '/sub-engineer/projects'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sub-Engineer Dashboard',
      subtitle: 'Ward 1-3 · Fatullah Union',
      user: MockData.subEngineerUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Assigned by Engineer Kamal Hossain
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.engineerBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF6EE7B7)),
              ),
              child: Row(
                children: [
                  const Text('👷', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assigned by Engineer Kamal Hossain', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                        Text('Area: Ward 1, 2, 3 · Fatullah Union Parishad', style: GoogleFonts.inter(fontSize: 12, color: AppColors.engineerFg)),
                        const SizedBox(height: 4),
                        Text('5 projects assigned for field monitoring', style: GoogleFonts.inter(fontSize: 11, color: AppColors.engineerFg)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StatCardWidget(value: '5', label: 'Assigned Projects', labelBn: 'নিয়োগপ্রাপ্ত প্রকল্প', icon: Icons.assignment, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
                StatCardWidget(value: '3', label: 'Ongoing', labelBn: 'চলমান', icon: Icons.construction, iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFF9A3412)),
                StatCardWidget(value: '2', label: 'Monitoring Due', labelBn: 'পরিদর্শন বাকি', icon: Icons.schedule, iconBg: AppColors.warningLight, iconColor: AppColors.warning, isHighlighted: true),
                StatCardWidget(value: '1', label: 'Completed', labelBn: 'সম্পন্ন', icon: Icons.check_circle_outline, iconBg: AppColors.successLight, iconColor: AppColors.success),
              ],
            ),
            const SizedBox(height: 20),

            // Monitoring due
            SectionCard(
              title: 'Monitoring Due / পরিদর্শন বাকি',
              leadingEmoji: '📍',
              child: Column(
                children: MockData.allProjects.where((p) => p.status == ProjectStatus.ongoing).take(3).map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.warningBorder)),
                        child: const Center(child: Icon(Icons.schedule, size: 18, color: AppColors.warning)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('${p.ward} · ${p.id}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: p.progressPercent / 100,
                              backgroundColor: AppColors.cardBorder,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
                              minHeight: 4,
                            ),
                            const SizedBox(height: 2),
                            Text('${p.progressPercent.toStringAsFixed(0)}% complete', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: const Text('View Projects'),
                    onPressed: () => context.go('/sub-engineer/projects'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: AppColors.engineerFg, foregroundColor: Colors.white),
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


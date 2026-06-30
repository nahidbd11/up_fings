import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/stat_card_widget.dart';
import '../../core/widgets/section_card.dart';
import '../../core/models/models.dart';

class EngineerDashboardScreen extends StatelessWidget {
  const EngineerDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/engineer/dashboard'),
    NavigationItem(icon: Icons.folder_outlined, activeIcon: Icons.folder, label: 'Projects / প্রকল্প', route: '/engineer/projects'),
    NavigationItem(icon: Icons.engineering_outlined, activeIcon: Icons.engineering, label: 'Vetting / যাচাই', route: '/engineer/vet/PM-2026-W03-041'),
    NavigationItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Sub-Engineers / উপ-প্রকৌশলী', route: '/engineer/project/PM-2026-W03-041'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Engineer Dashboard / ড্যাশবোর্ড',
      subtitle: 'Narayanganj Sadar · Civil Engineering',
      user: MockData.engineerUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Vetting alert
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
                  Text('⚙️ 2 Projects Awaiting Technical Vetting / প্রযুক্তিগত যাচাই', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                  const SizedBox(height: 4),
                  Text('UNO has sanctioned these. Conduct site visit and verify BOQ/estimate.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF78350F))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/engineer/vet/PM-2026-W03-041'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                      child: Text('⚙️ Start Vetting / যাচাই শুরু করুন', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
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
                StatCardWidget(value: '156', label: 'Total Projects', labelBn: 'মোট প্রকল্প', icon: Icons.folder, iconBg: AppColors.primaryLight, iconColor: AppColors.primary),
                StatCardWidget(value: '2', label: 'Awaiting Vetting', labelBn: 'যাচাই বাকি', icon: Icons.engineering, iconBg: AppColors.warningLight, iconColor: AppColors.warning, isHighlighted: true),
                StatCardWidget(value: '3', label: 'Sub-Engineers', labelBn: 'উপ-প্রকৌশলী', icon: Icons.people, iconBg: AppColors.successLight, iconColor: AppColors.success),
                StatCardWidget(value: '62', label: 'Ongoing', labelBn: 'চলমান', icon: Icons.construction, iconBg: Color(0xFFFFF7ED), iconColor: Color(0xFF9A3412)),
              ],
            ),
            const SizedBox(height: 20),

            // Sub-engineer assignments
            SectionCard(
              title: 'Sub-Engineer Assignments / উপ-প্রকৌশলী নিয়োগ',
              leadingEmoji: '👷',
              padding: EdgeInsets.zero,
              child: Column(
                children: MockData.subEngineers.map((se) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.engineerBg,
                        child: Text(se.name[0], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.engineerFg)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(se.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('${se.designation} · ${se.area}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${se.assignedProjects} projects', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              title: 'Recent Vetting Activity / সাম্প্রতিক যাচাই',
              leadingEmoji: '📊',
              child: Column(
                children: [
                  _VettingRow('Ward-1 Market Renovation', 'Vetted & Approved', AppColors.success, Icons.check_circle_outline),
                  _VettingRow('Ward-4 School Boundary', 'Under Vetting', AppColors.warning, Icons.engineering),
                  _VettingRow('Ward-7 Mosque Construction', 'Awaiting Visit', AppColors.primary, Icons.schedule),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.engineering, size: 18),
                    label: const Text('Vet Projects'),
                    onPressed: () => context.push('/engineer/vet/PM-2026-W03-041'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: const Text('View All'),
                    onPressed: () => context.go('/engineer/projects'),
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

class _VettingRow extends StatelessWidget {
  final String name;
  final String status;
  final Color color;
  final IconData icon;

  const _VettingRow(this.name, this.status, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
          Text(status, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}



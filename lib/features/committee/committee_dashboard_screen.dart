import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class CommitteeDashboardScreen extends StatelessWidget {
  const CommitteeDashboardScreen({super.key});

  static const _navItems = [
    NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard / ড্যাশবোর্ড', route: '/committee/dashboard'),
    NavigationItem(icon: Icons.upload_file_outlined, activeIcon: Icons.upload_file, label: 'Upload Documents / নথি আপলোড', route: '/committee/upload/PM-2026-W03-041'),
  ];

  @override
  Widget build(BuildContext context) {
    final assignedProjects = MockData.allProjects.where((p) => p.status == ProjectStatus.ongoing || p.status == ProjectStatus.awaitingEngineerVet).take(3).toList();

    return AppScaffold(
      title: 'Committee Dashboard / কমিটি ড্যাশবোর্ড',
      subtitle: 'Implementation Committee Member',
      user: MockData.committeeUser,
      navItems: _navItems,
      currentNavIndex: 0,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Role banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4338CA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('👑', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Project Implementation Committee', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('প্রকল্প বাস্তবায়ন কমিটি সদস্য', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text('Fatullah Union Parishad · Ward 1-3', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Upload needed alert
          if (assignedProjects.isNotEmpty)
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
                  Text('🔎 3 Projects Need Document Upload / নথি আপলোড প্রয়োজন', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                  const SizedBox(height: 4),
                  Text('Upload required documents: meeting resolution, measurement book, completion photos.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF78350F))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/committee/upload/${assignedProjects.first.id}'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                      child: Text('📤 Upload Documents / নথি আপলোড করুন', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'My Assigned Projects / আমার প্রকল্পসমূহ',
            leadingEmoji: '📋',
            child: Column(
              children: assignedProjects.map((p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(p.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700))),
                          StatusBadge(status: p.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${p.id} · ${p.ward}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.upload_file, size: 14),
                              label: const Text('Upload Docs'),
                              onPressed: () => context.push('/committee/upload/${p.id}'),
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6), backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // My role info
          SectionCard(
            title: 'My Role / আমার ভূমিকা',
            leadingEmoji: '📝',
            child: Column(
              children: [
                _RoleItem('Upload meeting resolution / সভার সিদ্ধান্ত আপলোড করুন'),
                _RoleItem('Upload measurement book / পরিমাপ বই আপলোড করুন'),
                _RoleItem('Upload completion photos / সমাপ্তির ছবি আপলোড করুন'),
                _RoleItem('Upload contractor invoice / ঠিকাদারের বিল আপলোড করুন'),
                _RoleItem('Assist in physical verification / শারীরিক যাচাইতে সহায়তা করুন'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RoleItem extends StatelessWidget {
  final String text;
  const _RoleItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}


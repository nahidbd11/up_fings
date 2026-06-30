import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  static const _roles = [
    _RoleOption('🏛️', 'DDLG', 'District Level Government', '/ddlg/dashboard', AppColors.ddlgBg, AppColors.ddlgFg),
    _RoleOption('🏢', 'UNO', 'Upazila Nirbahi Officer', '/uno/dashboard', AppColors.unoBg, AppColors.unoFg),
    _RoleOption('⚙️', 'Upazila Engineer', 'Cost Estimation & Vetting', '/engineer/dashboard', AppColors.engineerBg, AppColors.engineerFg),
    _RoleOption('⚙️', 'Sub-Engineer', 'Junior / Assistant Engineer', '/sub-engineer/dashboard', AppColors.engineerBg, AppColors.engineerFg),
    _RoleOption('📋', 'UP Administrator', 'Union Parishad Secretary', '/secretary/dashboard', AppColors.secretaryBg, AppColors.secretaryFg),
    _RoleOption('👑', 'UP Chairman', 'Union Parishad Chairman', '/chairman/dashboard', AppColors.chairmanBg, AppColors.chairmanFg),
    _RoleOption('📸', 'Committee Member', 'Scheme Supervision Committee', '/committee/dashboard', AppColors.committeeBg, AppColors.committeeFg),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text('Select Role (Demo)', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.successBorder),
            ),
            child: Row(
              children: [
                const Text('✅', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login Successful!', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                      Text('Select a role to preview the dashboard (Demo only)', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _roles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final role = _roles[i];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.go(role.route),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: role.bg, borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text(role.emoji, style: const TextStyle(fontSize: 22))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(role.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(role.subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: role.fg),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOption {
  final String emoji;
  final String title;
  final String subtitle;
  final String route;
  final Color bg;
  final Color fg;

  const _RoleOption(this.emoji, this.title, this.subtitle, this.route, this.bg, this.fg);
}

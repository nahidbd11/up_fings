import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class RoleChip extends StatelessWidget {
  final UserRole role;
  final bool small;

  const RoleChip({super.key, required this.role, this.small = false});

  @override
  Widget build(BuildContext context) {
    final config = _roleConfig(role);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: small ? 3 : 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        '${config.emoji}  ${config.label}',
        style: GoogleFonts.inter(
          fontSize: small ? 11 : 12,
          fontWeight: FontWeight.w700,
          color: config.fg,
        ),
      ),
    );
  }
}

class _RoleConfig {
  final Color bg;
  final Color fg;
  final String emoji;
  final String label;

  const _RoleConfig(this.bg, this.fg, this.emoji, this.label);
}

_RoleConfig _roleConfig(UserRole role) {
  switch (role) {
    case UserRole.ddlg:
      return const _RoleConfig(AppColors.ddlgBg, AppColors.ddlgFg, '🏛️', 'DDLG');
    case UserRole.uno:
      return const _RoleConfig(AppColors.unoBg, AppColors.unoFg, '🏢', 'UNO');
    case UserRole.engineer:
      return const _RoleConfig(AppColors.engineerBg, AppColors.engineerFg, '⚙️', 'Upazila Engineer');
    case UserRole.subEngineer:
      return const _RoleConfig(AppColors.engineerBg, AppColors.engineerFg, '⚙️', 'Sub-Engineer');
    case UserRole.secretary:
      return const _RoleConfig(AppColors.secretaryBg, AppColors.secretaryFg, '📋', 'UP Administrator');
    case UserRole.chairman:
      return const _RoleConfig(AppColors.chairmanBg, AppColors.chairmanFg, '👑', 'UP Chairman');
    case UserRole.committee:
      return const _RoleConfig(AppColors.committeeBg, AppColors.committeeFg, '📸', 'Committee Member');
  }
}

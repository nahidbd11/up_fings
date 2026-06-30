import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _config(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.border),
      ),
      child: Text(
        config.label,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: config.fg),
      ),
    );
  }
}

class _Cfg {
  final Color bg, fg, border;
  final String label;
  const _Cfg(this.bg, this.fg, this.border, this.label);
}

_Cfg _config(ProjectStatus s) {
  switch (s) {
    case ProjectStatus.completed:
      return const _Cfg(AppColors.successLight, AppColors.engineerFg, AppColors.successBorder, '✓ Completed');
    case ProjectStatus.ongoing:
      return const _Cfg(Color(0xFFFFF7ED), Color(0xFF9A3412), Color(0xFFFED7AA), '🔧 Ongoing');
    case ProjectStatus.upcoming:
      return const _Cfg(AppColors.infoLight, AppColors.primary, AppColors.infoBorder, '🕐 Upcoming');
    case ProjectStatus.awaitingApproval:
      return const _Cfg(AppColors.warningLight, Color(0xFF92400E), AppColors.warningBorder, '⏳ Awaiting Approval');
    case ProjectStatus.awaitingVetting:
      return const _Cfg(AppColors.primaryLight, AppColors.primary, AppColors.infoBorder, '🔍 Awaiting Vetting');
    case ProjectStatus.awaitingFundSanction:
      return const _Cfg(AppColors.successLight, AppColors.engineerFg, AppColors.successBorder, '💰 Awaiting Sanction');
    case ProjectStatus.sentBack:
      return const _Cfg(AppColors.errorLight, AppColors.error, AppColors.errorBorder, '↩ Sent Back');
    case ProjectStatus.pendingApproval:
      return const _Cfg(AppColors.warningLight, Color(0xFF92400E), AppColors.warningBorder, '📋 Pending Approval');
    case ProjectStatus.awaitingChairmanApproval:
      return const _Cfg(AppColors.warningLight, Color(0xFF92400E), AppColors.warningBorder, '👑 Awaiting Chairman');
    case ProjectStatus.awaitingEngineerVet:
      return const _Cfg(AppColors.primaryLight, AppColors.primary, AppColors.infoBorder, '⚙️ Awaiting Vetting');
  }
}

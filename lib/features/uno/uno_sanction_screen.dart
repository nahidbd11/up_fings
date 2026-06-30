import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class UnoSanctionScreen extends StatefulWidget {
  final String projectId;
  const UnoSanctionScreen({super.key, required this.projectId});

  @override
  State<UnoSanctionScreen> createState() => _UnoSanctionScreenState();
}

class _UnoSanctionScreenState extends State<UnoSanctionScreen> {
  bool _isIssuing = false;
  final _conditionsCtrl = TextEditingController();
  String _sanctionDate = '2026-07-01';

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[0]);

  @override
  void dispose() {
    _conditionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _project;
    return AppScaffold(
      title: 'Issue Sanction Order / অনুমোদন পত্র',
      subtitle: 'UNO — Narayanganj Sadar',
      user: MockData.unoUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📋 UNO Sanction Letter / অনুমোদন পত্র', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('This project has been approved by the Chairman. Issue the formal UNO sanction to authorize fund release.\n\nচেয়ারম্যান অনুমোদনের পর ইউএনও অনুমোদন পত্র দিতে হবে।', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF1E40AF))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Project Overview / প্রকল্পের সারসংক্ষেপ',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow('Project ID', p.id),
                _InfoRow('Name / নাম', p.name),
                _InfoRow('Bangla / বাংলা', p.nameBn),
                _InfoRow('Union', p.ward),
                _InfoRow('Type', p.type),
                _InfoRow('Fund Source', p.fundSource.name.toUpperCase()),
                _InfoRow('Cost / ব্যয়', '৳ ${_fmt(p.cost)}'),
                _InfoRow('Timeline', '${p.startDate} → ${p.endDate}'),
                _InfoRow('Fiscal Year', p.fiscalYear),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sanction preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryDark, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('গণপ্রজাতন্ত্রী বাংলাদেশ সরকার', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      Text('Government of the People\'s Republic of Bangladesh', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('নারায়ণগঞ্জ সদর উপজেলা', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      Text('Narayanganj Sadar Upazila', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Divider(height: 24),
                Text('অনুমোদন পত্র / SANCTION ORDER', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('No: UNO/NJR/${p.id}/$_sanctionDate', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('Date: $_sanctionDate', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Text(
                  'This is to certify that the following project has been sanctioned under ${p.fundSource.name.toUpperCase()} for implementation by Fatullah Union Parishad:',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text('Project: ${p.name}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                Text('(${p.nameBn})', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('Amount Sanctioned: ৳ ${_fmt(p.cost)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Text('Timeline: ${p.startDate} to ${p.endDate}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const Divider(height: 20),
                Text('(Authorized Signature)', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
                Text('Upazila Nirbahi Officer / উপজেলা নির্বাহী অফিসার', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                Text('Narayanganj Sadar Upazila', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Special Conditions / বিশেষ শর্তাবলী',
            leadingEmoji: '📝',
            child: TextField(
              controller: _conditionsCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any special conditions or notes (optional) / বিশেষ শর্ত যোগ করুন (ঐচ্ছিক)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isIssuing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, size: 18),
              label: Text(_isIssuing ? 'Issuing Sanction...' : '📋 Issue Sanction Order / অনুমোদন পত্র দিন'),
              onPressed: _isIssuing ? null : _issueSanction,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/uno/projects'),
              child: const Text('Cancel / বাতিল'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmt(double a) => a >= 100000 ? '৳${(a / 100000).toStringAsFixed(2)} Lakh' : a.toStringAsFixed(0);

  Future<void> _issueSanction() async {
    setState(() => _isIssuing = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isIssuing = false);
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📋', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Sanction Issued!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.success)),
            Text('অনুমোদন পত্র দেওয়া হয়েছে!', style: GoogleFonts.inter(fontSize: 14, color: AppColors.success)),
            const SizedBox(height: 8),
            Text('UNO/NJR/${_project.id}/$_sanctionDate', style: GoogleFonts.robotoMono(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.successBorder)),
              child: Text('Project can now proceed. Engineer team will be assigned for site inspection.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.engineerFg), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Navigator.pop(ctx); context.go('/uno/dashboard'); },
                child: const Text('Back to Dashboard'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class ChairmanReviewScreen extends StatefulWidget {
  final String projectId;
  const ChairmanReviewScreen({super.key, required this.projectId});

  @override
  State<ChairmanReviewScreen> createState() => _ChairmanReviewScreenState();
}

class _ChairmanReviewScreenState extends State<ChairmanReviewScreen> {
  bool _isApproving = false;
  bool _isSendingBack = false;
  final _remarksCtrl = TextEditingController();
  int _rating = 4;

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[3]);

  @override
  void dispose() {
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _project;
    return AppScaffold(
      title: 'Completion Review / সমাপ্তি পর্যালোচনা',
      subtitle: 'Chairman Final Approval',
      user: MockData.chairmanUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.successBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🏁 Project Completion Review / সমাপ্তি যাচাই', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                const SizedBox(height: 4),
                Text('Administrator submitted this completion. Your approval is the final step.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF166534))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Project Details / প্রকল্পের তথ্য',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow('Project ID', p.id),
                _InfoRow('Name / নাম', '${p.name}\n${p.nameBn}'),
                _InfoRow('Ward', p.ward),
                _InfoRow('Fund Source', p.fundSource.name.toUpperCase()),
                _InfoRow('Total Cost', '৳ ${_fmt(p.cost)}'),
                _InfoRow('Fiscal Year', p.fiscalYear),
                _InfoRow('Completion Date', p.endDate),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Photo evidence
          SectionCard(
            title: 'Completion Photos / সমাপ্তির ছবি',
            leadingEmoji: '📸',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                  itemCount: 4,
                  itemBuilder: (_, i) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.successBorder),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.image_outlined, size: 24, color: AppColors.success),
                          const SizedBox(height: 4),
                          Text('Photo ${i + 1}', style: GoogleFonts.inter(fontSize: 10, color: AppColors.engineerFg)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('4 completion photos uploaded by Administrator', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quality rating
          SectionCard(
            title: 'Quality Rating / মানের মূল্যায়ন',
            leadingEmoji: '⭐',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rate the project quality:', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        i < _rating ? Icons.star : Icons.star_border,
                        size: 32,
                        color: i < _rating ? const Color(0xFFF59E0B) : AppColors.textMuted,
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 4),
                Text(
                  _rating == 5 ? 'Excellent / অসাধারণ' : _rating == 4 ? 'Good / ভালো' : _rating == 3 ? 'Average / গড়' : _rating == 2 ? 'Below Average / গড়ের নিচে' : 'Poor / খারাপ',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Completion checklist
          SectionCard(
            title: 'Completion Checklist / চেকলিস্ট',
            leadingEmoji: '☑️',
            child: Column(
              children: [
                _CheckRow('All work completed as per sanction', true),
                _CheckRow('Photos submitted and verified', true),
                _CheckRow('Measurement book signed', true),
                _CheckRow('Community satisfaction reported', true),
                _CheckRow('Final expenditure statement submitted', false),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Chairman Remarks / চেয়ারম্যানের মন্তব্য',
            leadingEmoji: '✍️',
            child: TextField(
              controller: _remarksCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add remarks for completion certificate / সমাপ্তি সার্টিফিকেটের জন্য মন্তব্য যোগ করুন',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isApproving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.verified, size: 18),
              label: Text(_isApproving ? 'Certifying...' : '🏆 Approve & Issue Completion Certificate'),
              onPressed: (_isApproving || _isSendingBack) ? null : _approve,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: _isSendingBack
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.reply, size: 18),
              label: Text(_isSendingBack ? 'Sending Back...' : '↩️ Send Back for Revision / পুনরায় পাঠান'),
              onPressed: (_isApproving || _isSendingBack) ? null : _sendBack,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), foregroundColor: AppColors.warning),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.go('/chairman/dashboard'),
            child: const Text('Cancel / বাতিল'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmt(double a) => a >= 100000 ? '${(a / 100000).toStringAsFixed(2)} L' : a.toStringAsFixed(0);

  Future<void> _approve() async {
    setState(() => _isApproving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isApproving = false);
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
            const Text('🏆', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Completion Certified!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.success)),
            Text('সমাপ্তি সার্টিফিকেট জারি হয়েছে!', style: GoogleFonts.inter(fontSize: 14, color: AppColors.success)),
            const SizedBox(height: 8),
            Text(_project.name, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Rating: $_rating/5 Stars', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Navigator.pop(ctx); context.go('/chairman/dashboard'); },
                child: const Text('Back to Dashboard'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _sendBack() async {
    if (_remarksCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add remarks before sending back.'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isSendingBack = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSendingBack = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sent back to Administrator for revision.'), backgroundColor: AppColors.warning),
    );
    context.go('/chairman/dashboard');
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
          SizedBox(width: 120, child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool checked;

  const _CheckRow(this.label, this.checked);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(checked ? Icons.check_circle : Icons.cancel_outlined, size: 18, color: checked ? AppColors.success : AppColors.error),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: checked ? AppColors.textPrimary : AppColors.textMuted))),
        ],
      ),
    );
  }
}

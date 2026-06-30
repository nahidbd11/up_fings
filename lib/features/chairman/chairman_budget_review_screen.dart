import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class ChairmanBudgetReviewScreen extends StatefulWidget {
  final String projectId;
  const ChairmanBudgetReviewScreen({super.key, required this.projectId});

  @override
  State<ChairmanBudgetReviewScreen> createState() => _ChairmanBudgetReviewScreenState();
}

class _ChairmanBudgetReviewScreenState extends State<ChairmanBudgetReviewScreen> {
  bool _isApproving = false;
  final _remarksCtrl = TextEditingController();

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[1]);

  @override
  void dispose() {
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _project;
    final totalKhatwari = p.khatwariRows.fold<double>(0, (sum, r) => sum + r.amount);

    return AppScaffold(
      title: 'Budget Review / বাজেট পর্যালোচনা',
      subtitle: p.name,
      user: MockData.chairmanUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                Text('💰 Budget Approval Required / বাজেট অনুমোদন প্রয়োজন', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                const SizedBox(height: 4),
                Text('Engineer has submitted revised BOQ. Review and approve.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF78350F))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    _MetaChip(p.id),
                    _MetaChip(p.ward),
                    _MetaChip(p.fiscalYear),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Project overview
          SectionCard(
            title: 'Project Summary / সারসংক্ষেপ',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow('Project', p.name),
                _InfoRow('Type', p.type),
                _InfoRow('Fund Source', p.fundSource.name.toUpperCase()),
                _InfoRow('Timeline', '${p.startDate} → ${p.endDate}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Khatwari table
          SectionCard(
            title: 'Khatwari Budget / খাতওয়ারি বাজেট',
            leadingEmoji: '📊',
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFF1F5F9),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text('Description / বিবরণ', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted))),
                      Expanded(flex: 2, child: Text('Amount / পরিমাণ (৳)', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted), textAlign: TextAlign.end)),
                    ],
                  ),
                ),
                ...p.khatwariRows.map((row) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(row.description, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary))),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '৳ ${_fmt(row.amount)}',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text('Grand Total / সর্বমোট', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary))),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '৳ ${_fmt(totalKhatwari)}',
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Budget breakdown visual
          SectionCard(
            title: 'Budget Breakdown / বাজেটের বিভাজন',
            leadingEmoji: '🧮',
            child: Column(
              children: p.khatwariRows.map((row) {
                final pct = totalKhatwari > 0 ? row.amount / totalKhatwari : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(row.description, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                          Text('${(pct * 100).toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: AppColors.cardBorder,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
                hintText: 'Add remarks (optional) / মন্তব্য যোগ করুন (ঐচ্ছিক)',
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
                  : const Icon(Icons.check, size: 18),
              label: Text(_isApproving ? 'Approving Budget...' : '✅ Approve Budget / বাজেট অনুমোদন করুন'),
              onPressed: _isApproving ? null : _approveBudget,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget sent back for revision.'))),
                  child: const Text('Send Back / ফেরত পাঠান'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () => context.go('/chairman/dashboard'),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(2)} L';
    if (amount >= 1000) return amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return amount.toStringAsFixed(0);
  }

  Future<void> _approveBudget() async {
    setState(() => _isApproving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isApproving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget approved! UNO has been notified.'), backgroundColor: AppColors.success));
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
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  const _MetaChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF92400E))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class ChairmanApproveScreen extends StatefulWidget {
  final String projectId;
  const ChairmanApproveScreen({super.key, required this.projectId});

  @override
  State<ChairmanApproveScreen> createState() => _ChairmanApproveScreenState();
}

class _ChairmanApproveScreenState extends State<ChairmanApproveScreen> {
  final _remarksCtrl = TextEditingController();
  bool _isApproving = false;
  bool _isRejecting = false;

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[0]);

  @override
  void dispose() {
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _project;
    return AppScaffold(
      title: 'Review New Project / নতুন প্রকল্প পর্যালোচনা',
      subtitle: 'Chairman Decision Required',
      user: MockData.chairmanUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Decision needed banner
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
                Text('🆕 New Project Proposal / নতুন প্রকল্প প্রস্তাব', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('Submitted by Administrator · Requires your approval to proceed', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF1E40AF))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Project Information / প্রকল্পের তথ্য',
            leadingEmoji: '📋',
            trailing: StatusBadge(status: p.status),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow('Project ID', p.id),
                _InfoRow('Name / নাম', p.name),
                _InfoRow('Bangla Name', p.nameBn),
                _InfoRow('Type / ধরন', p.type),
                _InfoRow('Fund Source', p.fundSource.name.toUpperCase()),
                _InfoRow('Ward', p.ward),
                _InfoRow('Financial Year', p.fiscalYear),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Financial Details / আর্থিক তথ্য',
            leadingEmoji: '💰',
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow('Total Cost / মোট ব্যয়', '৳ ${_formatMoney(p.cost)}'),
                _InfoRow('Start Date / শুরুর তারিখ', p.startDate),
                _InfoRow('End Date / শেষের তারিখ', p.endDate),
                _InfoRow('Duration', _calcDuration(p.startDate, p.endDate)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Khatwari summary
          SectionCard(
            title: 'Khatwari / খাতওয়ারি বিভাজন',
            leadingEmoji: '📊',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...p.khatwariRows.take(4).map((row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.description, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary))),
                      Text('৳ ${_formatMoney(row.amount)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: Text('Total / মোট', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    Text('৳ ${_formatMoney(p.cost)}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Committee
          SectionCard(
            title: 'Committee Members / কমিটি সদস্য',
            leadingEmoji: '👥',
            padding: EdgeInsets.zero,
            child: Column(
              children: p.committee.take(4).map((m) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(m.name[0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(m.role, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Text(m.phone, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // GPS location
          SectionCard(
            title: 'GPS Location / জিপিএস অবস্থান',
            leadingEmoji: '📍',
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.infoBorder),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined, size: 32, color: AppColors.primary),
                        const SizedBox(height: 6),
                        Text('${p.gpsLat}, ${p.gpsLng}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        Text('Map view (prototype placeholder)', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chairman remarks
          SectionCard(
            title: 'Your Remarks / আপনার মন্তব্য',
            leadingEmoji: '✍️',
            child: TextField(
              controller: _remarksCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Optional: Add remarks before deciding / মন্তব্য যোগ করুন (ঐচ্ছিক)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Decision buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: _isApproving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check, size: 18),
                  label: Text(_isApproving ? 'Approving...' : '✅ Approve / অনুমোদন'),
                  onPressed: (_isApproving || _isRejecting) ? null : _approve,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: _isRejecting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.close, size: 18),
                  label: Text(_isRejecting ? 'Rejecting...' : '❌ Reject / প্রত্যাখ্যান'),
                  onPressed: (_isApproving || _isRejecting) ? null : _reject,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/chairman/dashboard'),
              child: const Text('Back to Dashboard / ড্যাশবোর্ডে ফিরুন'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatMoney(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(2)} L';
    return amount.toStringAsFixed(0);
  }

  String _calcDuration(String start, String end) => '~6 months';

  Future<void> _approve() async {
    setState(() => _isApproving = true);
    await Future.delayed(const Duration(milliseconds: 800));
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
            const Text('✅', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Project Approved!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.success)),
            Text('প্রকল্প অনুমোদিত হয়েছে!', style: GoogleFonts.inter(fontSize: 14, color: AppColors.success)),
            const SizedBox(height: 8),
            Text('The project will now proceed to UNO for sanction.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
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

  Future<void> _reject() async {
    if (_remarksCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add remarks before rejecting.'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isRejecting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isRejecting = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project rejected. Secretary has been notified.'), backgroundColor: AppColors.error),
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
          SizedBox(
            width: 130,
            child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';

class EngineerVetDetailScreen extends StatefulWidget {
  final String projectId;
  const EngineerVetDetailScreen({super.key, required this.projectId});

  @override
  State<EngineerVetDetailScreen> createState() => _EngineerVetDetailScreenState();
}

class _EngineerVetDetailScreenState extends State<EngineerVetDetailScreen> {
  bool _isApproving = false;
  bool _siteVisited = false;
  bool _boqVerified = false;
  bool _gpsVerified = false;
  final _remarksCtrl = TextEditingController();
  final List<Map<String, dynamic>> _khatwariEdits = [];

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[0]);

  @override
  void initState() {
    super.initState();
    _khatwariEdits.addAll(_project.khatwariRows.map((r) => {'description': r.description, 'amount': r.amount, 'ctrl': TextEditingController(text: r.amount.toStringAsFixed(0))}));
  }

  @override
  void dispose() {
    _remarksCtrl.dispose();
    for (final r in _khatwariEdits) { (r['ctrl'] as TextEditingController).dispose(); }
    super.dispose();
  }

  double get _totalEdited => _khatwariEdits.fold(0, (s, r) {
    final v = double.tryParse((r['ctrl'] as TextEditingController).text) ?? (r['amount'] as double);
    return s + v;
  });

  @override
  Widget build(BuildContext context) {
    final p = _project;
    return AppScaffold(
      title: 'Technical Vetting / প্রযুক্তিগত যাচাই',
      subtitle: p.name,
      user: MockData.engineerUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.engineerBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF6EE7B7))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⚙️ Engineer Technical Vetting / প্রকৌশলীর যাচাই', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                const SizedBox(height: 4),
                Text('Verify BOQ, GPS, and site conditions. You can modify the cost estimate if needed.\n\nবিওকিউ, জিপিএস এবং মাঠ পরিদর্শন যাচাই করুন।', style: GoogleFonts.inter(fontSize: 12, color: AppColors.engineerFg)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Checklist
          SectionCard(
            title: 'Vetting Checklist / যাচাই তালিকা',
            leadingEmoji: '☑️',
            child: Column(
              children: [
                _CheckTile('Site Visit Completed / মাঠ পরিদর্শন সম্পন্ন', _siteVisited, (v) => setState(() => _siteVisited = v)),
                _CheckTile('BOQ/Estimate Verified / বিওকিউ যাচাই', _boqVerified, (v) => setState(() => _boqVerified = v)),
                _CheckTile('GPS Coordinates Verified / জিপিএস যাচাই', _gpsVerified, (v) => setState(() => _gpsVerified = v)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Editable Khatwari
          SectionCard(
            title: 'Verify & Edit BOQ / বিওকিউ যাচাই ও সম্পাদনা',
            leadingEmoji: '✏️',
            padding: EdgeInsets.zero,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.infoBorder)),
              child: Text('৳ ${_fmt(_totalEdited)}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ),
            child: Column(
              children: [
                ..._khatwariEdits.asMap().entries.map((entry) {
                  final r = entry.value;
                  final ctrl = r['ctrl'] as TextEditingController;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                    child: Row(
                      children: [
                        Expanded(child: Text(r['description'] as String, style: GoogleFonts.inter(fontSize: 13))),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: ctrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.end,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(isDense: true, prefixText: '৳ ', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      Expanded(child: Text('Engineer Verified Total', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      Text('৳ ${_fmt(_totalEdited)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Engineer Remarks / প্রকৌশলীর মন্তব্য',
            leadingEmoji: '✍️',
            child: TextField(
              controller: _remarksCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Technical observations, site conditions, modifications made...',
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
              label: Text(_isApproving ? 'Submitting...' : '✅ Approve Vetting / যাচাই সম্পন্ন করুন'),
              onPressed: _isApproving ? null : _approve,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.engineerFg, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sent back to Secretary for revision.'))),
              child: const Text('↩️ Send Back for Revision / পুনরায় পাঠান'),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.go('/engineer/projects'),
            child: const Text('Cancel / বাতিল'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _fmt(double a) => a >= 100000 ? '${(a / 100000).toStringAsFixed(2)} L' : a.toStringAsFixed(0);

  Future<void> _approve() async {
    if (!_siteVisited || !_boqVerified || !_gpsVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all checklist items before approving.'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isApproving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isApproving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Technical vetting approved! Project can now proceed.'), backgroundColor: AppColors.success));
    context.go('/engineer/dashboard');
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckTile(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: AppColors.engineerFg,
            onChanged: (v) => onChanged(v ?? false),
          ),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: value ? AppColors.textPrimary : AppColors.textMuted))),
          Icon(value ? Icons.check_circle : Icons.radio_button_unchecked, size: 18, color: value ? AppColors.success : AppColors.textMuted),
        ],
      ),
    );
  }
}

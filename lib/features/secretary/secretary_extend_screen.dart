import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/form_widgets.dart';

class SecretaryExtendScreen extends StatefulWidget {
  final String projectId;
  const SecretaryExtendScreen({super.key, required this.projectId});

  @override
  State<SecretaryExtendScreen> createState() => _SecretaryExtendScreenState();
}

class _SecretaryExtendScreenState extends State<SecretaryExtendScreen> {
  String _newEndDate = '2026-09-30';
  String _reason = 'Weather Conditions / আবহাওয়া পরিস্থিতি';
  final _detailsCtrl = TextEditingController();
  bool _isSubmitting = false;

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[1]);

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reasons = [
      'Weather Conditions / আবহাওয়া পরিস্থিতি',
      'Material Shortage / উপকরণ সংকট',
      'Design Changes / নকশা পরিবর্তন',
      'Administrative Delay / প্রশাসনিক বিলম্ব',
      'Force Majeure / অনিবার্য কারণ',
      'Other / অন্যান্য',
    ];

    return AppScaffold(
      title: 'Extend Deadline / সময় বৃদ্ধি',
      subtitle: _project.name,
      user: MockData.secretaryUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current deadline info
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
                Text('⚠️ Deadline Extension Request / সময় বৃদ্ধির অনুরোধ', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoChip('Project', _project.name),
                    const SizedBox(width: 8),
                    _InfoChip('Ward', _project.ward),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InfoChip('Current End', _project.endDate),
                    const SizedBox(width: 8),
                    _InfoChip('ID', _project.id),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Extension Details / বিস্তারিত তথ্য',
            leadingEmoji: '📅',
            child: Column(
              children: [
                _ReadOnlyField('Current End Date / বর্তমান শেষ তারিখ', _project.endDate),
                const SizedBox(height: 14),
                AppDateField(
                  label: 'New End Date / নতুন শেষ তারিখ',
                  labelBn: 'সময় বাড়িয়ে নতুন তারিখ',
                  initialValue: _newEndDate,
                  required: true,
                  onChanged: (v) => setState(() => _newEndDate = v),
                ),
                const SizedBox(height: 14),
                AppDropdownField<String>(
                  label: 'Reason for Extension / সময় বৃদ্ধির কারণ',
                  value: _reason,
                  required: true,
                  items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() => _reason = v!),
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detailed Explanation / বিস্তারিত ব্যাখ্যা', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _detailsCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Explain why the deadline needs to be extended / কেন সময় বৃদ্ধি প্রয়োজন তা ব্যাখ্যা করুন...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Extension summary
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
                Text('Extension Summary / সারসংক্ষেপ', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 8),
                _SummaryRow('Original End Date', _project.endDate),
                _SummaryRow('New End Date', _newEndDate),
                _SummaryRow('Reason', _reason.split('/').first.trim()),
                _SummaryRow('Extension', 'Approx. 3 months'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, size: 18),
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit Extension Request / বৃদ্ধির আবেদন পাঠান'),
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/secretary/projects'),
              child: const Text('Cancel / বাতিল'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSubmitting = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Extension request submitted! / বৃদ্ধির আবেদন পাঠানো হয়েছে!'), backgroundColor: AppColors.success),
    );
    context.go('/secretary/projects');
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Text(value, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight))),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}

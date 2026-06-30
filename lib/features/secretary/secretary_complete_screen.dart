import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/form_widgets.dart';

class SecretaryCompleteScreen extends StatefulWidget {
  final String projectId;
  const SecretaryCompleteScreen({super.key, required this.projectId});

  @override
  State<SecretaryCompleteScreen> createState() => _SecretaryCompleteScreenState();
}

class _SecretaryCompleteScreenState extends State<SecretaryCompleteScreen> {
  String _completionDate = '2026-06-30';
  final _remarksCtrl = TextEditingController();
  final List<String> _completionPhotos = [];
  bool _isSubmitting = false;

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[2]);

  @override
  void dispose() {
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mark as Complete / সম্পন্ন হিসেবে চিহ্নিত করুন',
      subtitle: _project.name,
      user: MockData.secretaryUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Project summary
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
                Text('✅ Completion Submission / সমাপ্তি দাখিল', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                const SizedBox(height: 8),
                Text(_project.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${_project.id} · ${_project.ward}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.successBorder),
                  ),
                  child: Text(
                    'ℹ️ After you submit, this completion request will be sent to the UP Chairman for final review and approval.\n\nজমা দেওয়ার পর চেয়ারম্যান চূড়ান্ত যাচাই করবেন।',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.engineerFg),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Completion Details / সমাপ্তির তথ্য',
            leadingEmoji: '📋',
            child: Column(
              children: [
                AppDateField(
                  label: 'Completion Date / সমাপ্তির তারিখ',
                  initialValue: _completionDate,
                  required: true,
                  onChanged: (v) => setState(() => _completionDate = v),
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Final Remarks / চূড়ান্ত মন্তব্য', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _remarksCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Any final remarks about project completion...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Completion Photos / সমাপ্তির ছবি',
            leadingEmoji: '📸',
            child: Column(
              children: [
                if (_completionPhotos.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1),
                    itemCount: _completionPhotos.length,
                    itemBuilder: (_, i) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.successBorder),
                      ),
                      child: const Center(child: Icon(Icons.check_circle_outline, color: AppColors.success, size: 32)),
                    ),
                  ),
                if (_completionPhotos.isNotEmpty) const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() => _completionPhotos.add('completion_photo_${_completionPhotos.length + 1}.jpg')),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.success, style: BorderStyle.solid, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, size: 28, color: AppColors.success),
                        const SizedBox(height: 6),
                        Text('Add Completion Photo', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
                      ],
                    ),
                  ),
                ),
                if (_completionPhotos.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('${_completionPhotos.length} photo(s) added', style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Completion checklist
          SectionCard(
            title: 'Completion Checklist / সমাপ্তির চেকলিস্ট',
            leadingEmoji: '☑️',
            child: Column(
              children: [
                _ChecklistItem('All work items completed as per BOQ', true),
                _ChecklistItem('Site cleaned and debris removed', true),
                _ChecklistItem('Progress photos uploaded (at least 3)', _completionPhotos.length >= 3),
                _ChecklistItem('Meeting resolution available', true),
                _ChecklistItem('Final measurements verified', false),
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
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit Completion to Chairman / চেয়ারম্যানের কাছে পাঠান'),
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: AppColors.success),
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
            Text('Completion Submitted!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('সমাপ্তি দাখিল করা হয়েছে!', style: GoogleFonts.inter(fontSize: 14, color: AppColors.success, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(_project.id, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textLight)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warningBorder),
              ),
              child: Row(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Awaiting Chairman\'s final review and approval / চেয়ারম্যানের চূড়ান্ত যাচাইয়ের অপেক্ষায়', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF92400E))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go('/secretary/projects');
                },
                child: const Text('Back to Projects'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String label;
  final bool checked;

  const _ChecklistItem(this.label, this.checked);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: checked ? AppColors.success : AppColors.textMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: checked ? AppColors.textPrimary : AppColors.textMuted,
                decoration: checked ? null : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

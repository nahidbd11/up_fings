import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';

class CommitteeUploadScreen extends StatefulWidget {
  final String projectId;
  const CommitteeUploadScreen({super.key, required this.projectId});

  @override
  State<CommitteeUploadScreen> createState() => _CommitteeUploadScreenState();
}

class _CommitteeUploadScreenState extends State<CommitteeUploadScreen> {
  bool _isSubmitting = false;
  final Map<String, bool> _uploadedDocs = {
    'Meeting Resolution / সভার সিদ্ধান্ত': false,
    'Measurement Book / পরিমাপ বই': false,
    'Contractor Invoice / ঠিকাদারের বিল': false,
    'Completion Certificate / সমাপ্তি সার্টিফিকেট': false,
  };
  final List<String> _photos = [];

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[0]);

  int get _uploadedCount => _uploadedDocs.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Upload Documents / নথি আপলোড',
      subtitle: _project.name,
      user: MockData.committeeUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📤 Document Upload / নথি আপলোড', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF4338CA))),
                const SizedBox(height: 4),
                Text('${_project.id} · ${_project.ward}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6366F1))),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: _uploadedCount / _uploadedDocs.length,
                  backgroundColor: const Color(0xFFC7D2FE),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4338CA)),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text('$_uploadedCount / ${_uploadedDocs.length} documents uploaded', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6366F1))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Required documents
          SectionCard(
            title: 'Required Documents / প্রয়োজনীয় নথি',
            leadingEmoji: '📎',
            child: Column(
              children: _uploadedDocs.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: entry.value ? AppColors.successLight : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: entry.value ? AppColors.successBorder : AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          entry.value ? Icons.check_circle : Icons.upload_file_outlined,
                          size: 20,
                          color: entry.value ? AppColors.success : const Color(0xFF6366F1),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(entry.key, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: entry.value ? AppColors.engineerFg : AppColors.textPrimary)),
                        ),
                        if (!entry.value)
                          TextButton(
                            onPressed: () => setState(() => _uploadedDocs[entry.key] = true),
                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                            child: Text('Upload', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF4338CA))),
                          )
                        else
                          Text('✓ Uploaded', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Photo upload
          SectionCard(
            title: 'Progress Photos / অগ্রগতির ছবি',
            leadingEmoji: '📸',
            trailing: _photos.isNotEmpty
                ? Text('${_photos.length} added', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success))
                : null,
            child: Column(
              children: [
                if (_photos.isNotEmpty) ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                    itemCount: _photos.length,
                    itemBuilder: (_, i) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.successBorder),
                      ),
                      child: Stack(
                        children: [
                          const Center(child: Icon(Icons.image, size: 28, color: AppColors.success)),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _photos.removeAt(i)),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                GestureDetector(
                  onTap: () => setState(() => _photos.add('photo_${_photos.length + 1}.jpg')),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF6366F1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, size: 24, color: Color(0xFF4338CA)),
                        const SizedBox(height: 4),
                        Text('Add Photo / ছবি যোগ করুন', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF4338CA))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.cloud_upload, size: 18),
              label: Text(_isSubmitting ? 'Submitting...' : '📤 Submit All Documents / সকল নথি দাখিল করুন'),
              onPressed: (_isSubmitting || _uploadedCount == 0) ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4338CA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                disabledBackgroundColor: AppColors.textMuted,
              ),
            ),
          ),
          if (_uploadedCount == 0) ...[
            const SizedBox(height: 6),
            Text('Upload at least one document to submit / কমপক্ষে একটি নথি আপলোড করুন', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/committee/dashboard'),
              child: const Text('Back to Dashboard / ড্যাশবোর্ডে ফিরুন'),
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
      const SnackBar(content: Text('Documents submitted successfully! / নথি দাখিল হয়েছে!'), backgroundColor: AppColors.success),
    );
    context.go('/committee/dashboard');
  }
}

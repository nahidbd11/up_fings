import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/status_badge.dart';

class SecretaryProgressScreen extends StatefulWidget {
  final String projectId;
  const SecretaryProgressScreen({super.key, required this.projectId});

  @override
  State<SecretaryProgressScreen> createState() => _SecretaryProgressScreenState();
}

class _SecretaryProgressScreenState extends State<SecretaryProgressScreen> {
  double _completion = 60;
  String _stage = 'Foundation Work';
  final _notesCtrl = TextEditingController();
  final List<String> _uploadedPhotos = [];

  Project get _project => MockData.allProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => MockData.allProjects[1]);

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Update Progress / অগ্রগতি আপডেট',
      subtitle: _project.name,
      user: MockData.secretaryUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Project summary banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_project.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('${_project.id} · ${_project.ward} · ${_project.union.split('/').first.trim()}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
                StatusBadge(status: _project.status),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Current Progress / বর্তমান অগ্রগতি',
            leadingEmoji: '📊',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${_completion.toInt()}% Complete', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const Spacer(),
                    Text('Target: 100%', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _completion / 100,
                    backgroundColor: AppColors.cardBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(_completion >= 80 ? AppColors.success : AppColors.warning),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Adjust Completion %', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Slider(
                  value: _completion,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${_completion.toInt()}%',
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _completion = v),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [0, 25, 50, 75, 100].map((v) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _completion = v.toDouble()),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _completion == v ? AppColors.primary : AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('$v%', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _completion == v ? Colors.white : AppColors.textSecondary)),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Work Stage / কাজের ধাপ',
            leadingEmoji: '🔧',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Stage / বর্তমান ধাপ', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Site Preparation', 'Foundation Work', 'Main Construction', 'Finishing Works', 'Final Inspection'].map((s) {
                    return GestureDetector(
                      onTap: () => setState(() => _stage = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _stage == s ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _stage == s ? AppColors.primary : AppColors.cardBorder),
                        ),
                        child: Text(s, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _stage == s ? Colors.white : AppColors.textSecondary)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Progress Photos / অগ্রগতির ছবি',
            leadingEmoji: '📸',
            child: Column(
              children: [
                if (_uploadedPhotos.isNotEmpty) ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                    itemCount: _uploadedPhotos.length,
                    itemBuilder: (context, i) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.infoBorder),
                      ),
                      child: const Center(child: Icon(Icons.image, color: AppColors.primary, size: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                GestureDetector(
                  onTap: () {
                    setState(() => _uploadedPhotos.add('photo_${_uploadedPhotos.length + 1}.jpg'));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo added (simulated)')));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Tap to add photo', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        Text('Camera or Gallery / ক্যামেরা বা গ্যালারি', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ),
                if (_uploadedPhotos.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('${_uploadedPhotos.length} photo(s) added', style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Notes / মন্তব্য',
            leadingEmoji: '📝',
            child: TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add any notes about the current progress...', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save Progress Update / অগ্রগতি সংরক্ষণ করুন'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress updated successfully! / অগ্রগতি আপডেট হয়েছে!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.go('/secretary/projects');
              },
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
}

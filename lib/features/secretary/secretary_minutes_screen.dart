import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/section_card.dart';

class SecretaryMinutesScreen extends StatefulWidget {
  const SecretaryMinutesScreen({super.key});

  @override
  State<SecretaryMinutesScreen> createState() => _SecretaryMinutesScreenState();
}

class _SecretaryMinutesScreenState extends State<SecretaryMinutesScreen> {
  String _meetingDate = '2026-06-28';
  String _fy = '2025–26';
  final _venueCtrl = TextEditingController(text: 'UP Office, Fatullah Union Parishad');
  final _agendaCtrl = TextEditingController();
  final _decisionsCtrl = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _members = [
    {'name': 'Alhaj Jahangir Alam', 'designation': 'Chairman', 'present': true},
    {'name': 'Rahim Uddin', 'designation': 'Administrator', 'present': true},
    {'name': 'Ward 1 Member', 'designation': 'UP Member', 'present': true},
    {'name': 'Ward 2 Member', 'designation': 'UP Member', 'present': false},
    {'name': 'Ward 3 Member', 'designation': 'UP Member', 'present': true},
    {'name': 'Ward 4 Member', 'designation': 'UP Member', 'present': false},
  ];

  int get _presentCount => _members.where((m) => m['present'] == true).length;

  @override
  void dispose() {
    _venueCtrl.dispose();
    _agendaCtrl.dispose();
    _decisionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Submit Meeting Minutes / কার্যবিবরণী দাখিল',
      subtitle: 'Fatullah Union Parishad',
      user: MockData.secretaryUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Text(
              'ℹ️ Record the official meeting minutes of the Union Parishad. These will be visible to the UNO, DDLG, and the Chairman.\n\nইউনিয়ন পরিষদের সভার কার্যবিবরণী লিপিবদ্ধ করুন।',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Meeting Information / সভার তথ্য',
            leadingEmoji: '📋',
            child: Column(
              children: [
                AppDateField(
                  label: 'Meeting Date / সভার তারিখ',
                  initialValue: _meetingDate,
                  required: true,
                  onChanged: (v) => setState(() => _meetingDate = v),
                ),
                const SizedBox(height: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venue / সভার স্থান', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(controller: _venueCtrl, decoration: const InputDecoration(isDense: true, border: OutlineInputBorder())),
                  ],
                ),
                const SizedBox(height: 14),
                AppDropdownField<String>(
                  label: 'Financial Year / অর্থবছর',
                  value: _fy,
                  items: ['2025–26', '2024–25', '2026–27'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  onChanged: (v) => setState(() => _fy = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Attendance / উপস্থিতি',
            leadingEmoji: '👥',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.infoBorder),
              ),
              child: Text('$_presentCount / ${_members.length} Present', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
            padding: EdgeInsets.zero,
            child: Column(
              children: _members.asMap().entries.map((e) {
                final m = e.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: m['present'] == true ? AppColors.primaryLight : AppColors.cardBorder,
                        child: Text(
                          (m['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: m['present'] == true ? AppColors.primary : AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name'] as String, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(m['designation'] as String, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Switch(
                        value: m['present'] as bool,
                        activeColor: AppColors.success,
                        onChanged: (v) => setState(() => _members[e.key] = {...m, 'present': v}),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Agenda Items / আলোচ্যসূচি',
            leadingEmoji: '📌',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agenda / আলোচ্যসূচি', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextField(
                  controller: _agendaCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'List the agenda items (one per line) / আলোচ্যসূচি লিখুন (প্রতিটি আলাদা লাইনে)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Decisions & Resolutions / সিদ্ধান্তসমূহ',
            leadingEmoji: '✅',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Decisions / সিদ্ধান্ত', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                TextField(
                  controller: _decisionsCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Record all decisions made (one per line) / সকল সিদ্ধান্ত লিখুন',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Document attachment
          SectionCard(
            title: 'Attach Document / নথি সংযুক্ত করুন',
            leadingEmoji: '📎',
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File picker (simulated)'))),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attach_file, color: AppColors.primary, size: 24),
                      const SizedBox(height: 4),
                      Text('Attach signed minutes PDF / স্বাক্ষরিত কার্যবিবরণী সংযুক্ত করুন', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, size: 18),
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit Minutes / কার্যবিবরণী দাখিল করুন'),
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved!'))),
                  child: const Text('💾 Save Draft'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () => context.go('/secretary/minutes'),
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

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSubmitting = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting minutes submitted successfully! / কার্যবিবরণী দাখিল হয়েছে!'), backgroundColor: AppColors.success),
    );
    context.go('/secretary/minutes');
  }
}

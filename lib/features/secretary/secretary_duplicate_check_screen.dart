import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/section_card.dart';

class SecretaryDuplicateCheckScreen extends StatefulWidget {
  const SecretaryDuplicateCheckScreen({super.key});

  @override
  State<SecretaryDuplicateCheckScreen> createState() => _SecretaryDuplicateCheckScreenState();
}

class _SecretaryDuplicateCheckScreenState extends State<SecretaryDuplicateCheckScreen> {
  final _latCtrl = TextEditingController(text: '23.6241');
  final _lngCtrl = TextEditingController(text: '90.4981');
  bool _hasChecked = false;

  @override
  void dispose() {
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Duplicate Check / সদৃশ যাচাই',
      subtitle: 'Verify no duplicate project exists nearby',
      user: MockData.secretaryUser,
      navItems: const [],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.infoLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.infoBorder)),
            child: Text(
              'ℹ️ Enter GPS coordinates below to check if a similar project already exists within 500m radius. This step is required before creating a new project.\n\nনতুন প্রকল্প তৈরির আগে নিকটবর্তী সদৃশ প্রকল্প যাচাই করা আবশ্যক।',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Enter Project Coordinates / স্থানাংক দিন',
            leadingEmoji: '📍',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitude / অক্ষাংশ', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          TextField(controller: _latCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(isDense: true)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Longitude / দ্রাঘিমাংশ', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          TextField(controller: _lngCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(isDense: true)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Map placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4E8F0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.infoBorder),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.map, size: 48, color: AppColors.primary),
                            const SizedBox(height: 8),
                            Text('Map View — Fatullah Union', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            Text('Lat: ${_latCtrl.text} · Lng: ${_lngCtrl.text}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                            const SizedBox(height: 6),
                            const Text('📍', style: TextStyle(fontSize: 28)),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.cardBorder)),
                          child: Text('500m radius check', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textLight)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('Run Duplicate Check / সদৃশ যাচাই করুন'),
                    onPressed: () => setState(() => _hasChecked = true),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_hasChecked) ...[
            SectionCard(
              title: 'Check Results / যাচাই ফলাফল',
              leadingEmoji: '🔍',
              child: Column(
                children: [
                  ...MockData.duplicateAlerts.map((alert) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.warningBorder),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.projectName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              Text('${alert.ward} — Similar to ${alert.similarTo} within ${alert.distance}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.warningBorder),
                    ),
                    child: Text(
                      '⚠️ 2 potential duplicate projects found nearby. Please review before submitting a new project.\n\nনিকটবর্তী ২টি সম্ভাব্য সদৃশ প্রকল্প পাওয়া গেছে। নতুন প্রকল্প জমার আগে পর্যালোচনা করুন।',
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF92400E)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/secretary/create-project'),
                          child: const Text('Proceed Anyway'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _hasChecked = false),
                          child: const Text('Re-check'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (!_hasChecked) ...[
            SectionCard(
              title: 'Known Duplicate Alerts / পরিচিত সদৃশ সতর্কতা',
              leadingEmoji: '⚠️',
              child: Column(
                children: MockData.duplicateAlerts.map((alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alert.projectName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('${alert.ward} — similar to ${alert.similarTo} (${alert.distance})', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

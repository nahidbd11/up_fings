import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/form_widgets.dart';

class SecretaryCreateProjectScreen extends StatefulWidget {
  const SecretaryCreateProjectScreen({super.key});

  @override
  State<SecretaryCreateProjectScreen> createState() => _SecretaryCreateProjectScreenState();
}

class _SecretaryCreateProjectScreenState extends State<SecretaryCreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;
  bool _isSubmitting = false;

  // Step 1 — Location
  String _district = 'Narayanganj / নারায়ণগঞ্জ';
  String _upazila = 'Narayanganj Sadar / নারায়ণগঞ্জ সদর';
  String _union = 'Fatullah / ফতুল্লা';
  String _ward = 'Ward 3';

  // Step 2 — Project Info
  final _nameCtrl = TextEditingController(text: 'Ward-3 Main Road Repair');
  String _projectType = 'Road / সড়ক';
  String _fundSource = 'ADP';
  String _khatSector = 'Communication & Transport / যোগাযোগ ও পরিবহন';
  final _descCtrl = TextEditingController();

  // Step 3 — Cost & Khatwari
  final _costCtrl = TextEditingController(text: '769650');
  String _startDate = '2026-03-01';
  String _endDate = '2026-06-30';
  String _fy = '2025-26';

  final List<Map<String, dynamic>> _khatRows = [
    {'name': 'Earthwork / মাটির কাজ', 'unit': 'm³', 'qty': 120.0, 'rate': 800.0},
    {'name': 'Brick-Soling / ইটের সোলিং', 'unit': 'm²', 'qty': 800.0, 'rate': 280.0},
    {'name': 'Cement Concrete / সিমেন্ট কংক্রিট', 'unit': 'm³', 'qty': 40.0, 'rate': 4200.0},
    {'name': 'Bituminous Overlay / বিটুমিনাস আস্তর', 'unit': 'm²', 'qty': 800.0, 'rate': 120.0},
    {'name': 'Side Drain Repair / পার্শ্ব নালা', 'unit': 'm', 'qty': 250.0, 'rate': 380.0},
    {'name': 'Labour / শ্রমিক', 'unit': 'days', 'qty': 60.0, 'rate': 600.0},
    {'name': 'Supervision / তদারকি', 'unit': 'LS', 'qty': 1.0, 'rate': 18000.0},
    {'name': 'Contingency / আনুষঙ্গিক (5%)', 'unit': 'LS', 'qty': 1.0, 'rate': 36650.0},
  ];

  // GPS
  final _latCtrl = TextEditingController(text: '23.6241');
  final _lngCtrl = TextEditingController(text: '90.4981');
  final _addressCtrl = TextEditingController(text: 'Near Fatullah Bazar, Ward-3 main road, Fatullah Union');

  // Committee members
  final List<Map<String, String>> _members = [
    {'name': 'Jalal Uddin', 'role': 'Chairman, Committee', 'contact': '01755-111222'},
    {'name': 'Anowara Begum', 'role': 'Member', 'contact': '01855-333444'},
  ];

  double get _grandTotal => _khatRows.fold(0, (s, r) => s + (r['qty'] as double) * (r['rate'] as double));

  String _fmt(double v) {
    if (v >= 100000) return '৳ ${(v / 100000).toStringAsFixed(2)} L';
    return '৳ ${v.toStringAsFixed(0)}';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _costCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Create Project / প্রকল্প তৈরি',
      subtitle: 'UP Administrator · Fatullah Union',
      user: MockData.secretaryUser,
      navItems: const [],
      body: Column(
        children: [
          // Stepper indicator
          _StepIndicator(currentStep: _step, steps: const ['Location', 'Project Info', 'Cost & GPS', 'Committee']),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Workflow banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.infoBorder),
                    ),
                    child: Text(
                      'ℹ️ After you submit, the project goes to the UP Chairman for initial approval. The Chairman then forwards to the Upazila Engineer or directly to the UNO.\n\nজমা দেওয়ার পর চেয়ারম্যান পর্যালোচনা করবেন।',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
                    ),
                  ),

                  if (_step == 0) _buildStep1(),
                  if (_step == 1) _buildStep2(),
                  if (_step == 2) _buildStep3(),
                  if (_step == 3) _buildStep4(),

                  const SizedBox(height: 24),
                  _NavigationButtons(
                    step: _step,
                    totalSteps: 4,
                    isSubmitting: _isSubmitting,
                    onBack: _step > 0 ? () => setState(() => _step--) : null,
                    onNext: _step < 3
                        ? () { if (_formKey.currentState!.validate()) setState(() => _step++); }
                        : null,
                    onSubmit: _submit,
                    onSaveDraft: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Draft saved! / খসড়া সংরক্ষিত হয়েছে!')),
                      );
                    },
                    onCancel: () => context.go('/secretary/dashboard'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    final districts = ['Narayanganj / নারায়ণগঞ্জ', 'Dhaka / ঢাকা'];
    final upazilas = ['Narayanganj Sadar / নারায়ণগঞ্জ সদর', 'Rupganj / রূপগঞ্জ', 'Araihazar / আড়াইহাজার'];
    final unions = ['Fatullah / ফতুল্লা', 'Siddhirganj / সিদ্ধিরগঞ্জ', 'Kashipur / কাশীপুর'];
    final wards = List.generate(9, (i) => 'Ward ${i + 1}');

    return FormSectionCard(
      title: 'Location Hierarchy / প্রশাসনিক এলাকা',
      titleBn: 'District → Upazila → Union → Ward',
      emoji: '📍',
      child: Column(
        children: [
          AppDropdownField<String>(
            label: 'District / জেলা',
            value: _district,
            required: true,
            items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => _district = v!),
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Upazila / উপজেলা',
            value: _upazila,
            required: true,
            items: upazilas.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setState(() => _upazila = v!),
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Union / ইউনিয়ন',
            value: _union,
            required: true,
            items: unions.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setState(() => _union = v!),
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Ward / ওয়ার্ড',
            value: _ward,
            required: true,
            items: wards.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
            onChanged: (v) => setState(() => _ward = v!),
          ),
          const SizedBox(height: 14),
          AppFormField(
            label: 'UP Code / ইউপি কোড',
            initialValue: 'BD-NAR-SJR-UP05',
            readOnly: true,
          ),
          const SizedBox(height: 8),
          Text(
            '🔄 Auto-generated · you may edit if needed / স্বয়ংক্রিয়ভাবে তৈরি',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.map_outlined, size: 16),
            label: const Text('Check Duplicates First / আগে সদৃশ যাচাই করুন'),
            onPressed: () => context.push('/secretary/duplicate-check'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final types = ['Road / সড়ক', 'Drainage / নালা', 'Bridge / সেতু', 'Mosque / মসজিদ', 'Education / শিক্ষা', 'Water Supply / পানি সরবরাহ', 'Other / অন্যান্য'];
    final funds = ['ADP', '1% Fund / ১% তহবিল', 'Own Fund / নিজস্ব তহবিল', 'Special Allocation / বিশেষ বরাদ্দ'];
    final khats = ['Communication & Transport / যোগাযোগ ও পরিবহন', 'Agriculture & Irrigation / কৃষি ও সেচ', 'Public Health & Sanitation / জনস্বাস্থ্য', 'Education & Human Resource / শিক্ষা', 'Social Welfare / সমাজকল্যাণ'];

    return FormSectionCard(
      title: 'Project Information / প্রকল্পের তথ্য',
      emoji: '📋',
      child: Column(
        children: [
          AppFormField(
            label: 'Project Name / প্রকল্পের নাম',
            controller: _nameCtrl,
            required: true,
            hint: 'English or Bangla / ইংরেজি কথবা বাংলায় লিখুন',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Project name is required' : null,
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Project Type / প্রকল্পের ধরন',
            value: _projectType,
            required: true,
            items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _projectType = v!),
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Source of Fund / অর্থায়নের উৎস',
            value: _fundSource,
            required: true,
            items: funds.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
            onChanged: (v) => setState(() => _fundSource = v!),
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            label: 'Allocation Sector / খাত (Khat)',
            value: _khatSector,
            required: true,
            items: khats.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (v) => setState(() => _khatSector = v!),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              'ℹ️ Source of Fund = which funding stream. Allocation Sector (Khat) = which government expenditure category.',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight),
            ),
          ),
          const SizedBox(height: 14),
          AppFormField(
            label: 'Project Description / বিবরণ',
            controller: _descCtrl,
            maxLines: 3,
            hint: 'Brief description of the project scope and objectives...',
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final fyOptions = ['2025-26', '2024-25', '2026-27'];

    return Column(
      children: [
        // Cost & Timeline
        FormSectionCard(
          title: 'Cost & Timeline / ব্যয় ও সময়সীমা',
          emoji: '💰',
          child: Column(
            children: [
              AppFormField(
                label: 'Project Cost (৳) / প্রকল্প ব্যয়',
                controller: _costCtrl,
                required: true,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Cost is required' : null,
              ),
              const SizedBox(height: 8),
              Text('Grand total from breakdown: ${_fmt(_grandTotal)}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: AppDateField(
                      label: 'Start Date',
                      labelBn: 'শুরুর তারিখ',
                      initialValue: _startDate,
                      required: true,
                      onChanged: (v) => setState(() => _startDate = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppDateField(
                      label: 'End Date',
                      labelBn: 'শেষের তারিখ',
                      initialValue: _endDate,
                      required: true,
                      onChanged: (v) => setState(() => _endDate = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppDropdownField<String>(
                label: 'Financial Year / অর্থবছর',
                value: _fy,
                required: true,
                items: fyOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => setState(() => _fy = v!),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Khatwari breakdown
        FormSectionCard(
          title: 'Khatwari Cost Breakdown / খাতওয়ারি ব্যয় বিভাজন',
          titleBn: 'Line totals auto-calculate and sync to Project Cost',
          emoji: '📊',
          headerTrailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(4)),
            child: Text('✏️ Editable', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.warningBorder),
                ),
                child: Text(
                  '⚠️ ADP / 1% / Special Allocation: This breakdown is an initial estimate — the Upazila Engineer will review and may update figures.',
                  style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF92400E)),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFFF8FAFC),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text('Sub-Head / উপ-খাত', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    Expanded(flex: 2, child: Text('Unit', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    Expanded(flex: 2, child: Text('Qty', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    Expanded(flex: 2, child: Text('Rate', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    Expanded(flex: 3, child: Text('Amount', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
              const Divider(height: 1),
              ..._khatRows.asMap().entries.map((e) => _KhatwariRowWidget(
                row: e.value,
                onChanged: (updated) {
                  setState(() {
                    _khatRows[e.key] = updated;
                    _costCtrl.text = _grandTotal.toStringAsFixed(0);
                  });
                },
                onRemove: _khatRows.length > 1 ? () => setState(() => _khatRows.removeAt(e.key)) : null,
              )),
              const Divider(height: 1, thickness: 2, color: Color(0xFF22C55E)),
              Container(
                color: AppColors.successLight,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Spacer(),
                    Text('Total / সর্বমোট', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.engineerFg)),
                    const SizedBox(width: 12),
                    Text(_fmt(_grandTotal), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.engineerFg, fontFeatures: const [FontFeature.tabularFigures()])),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Sub-Head / উপ-খাত যোগ করুন'),
                onPressed: () {
                  setState(() {
                    _khatRows.add({'name': '', 'unit': '', 'qty': 0.0, 'rate': 0.0});
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // GPS Location
        FormSectionCard(
          title: 'GPS Location / জিপিএস অবস্থান',
          titleBn: 'Used for duplicate detection / সদৃশ যাচাইয়ে ব্যবহৃত হয়',
          emoji: '📍',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: AppFormField(label: 'Latitude / অক্ষাংশ', controller: _latCtrl, required: true, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppFormField(label: 'Longitude / দ্রাঘিমাংশ', controller: _lngCtrl, required: true, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 14),
              AppFormField(label: 'Project Location (Address)', labelBn: 'প্রকল্পের স্থান', controller: _addressCtrl),
              const SizedBox(height: 12),
              // Map placeholder
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E8F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.infoBorder, style: BorderStyle.solid),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined, size: 40, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text('Map View', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      Text('Lat: ${_latCtrl.text} · Lng: ${_lngCtrl.text}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      Text('📍 Set coordinates in the fields above', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => context.push('/secretary/duplicate-check'),
                child: Text(
                  '⚠️ Run Duplicate Check with these coordinates before submitting.',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      children: [
        // Committee members
        FormSectionCard(
          title: 'Scheme Supervision Committee / প্রকল্প তদারকি কমিটি',
          titleBn: 'Members who will upload progress photos',
          emoji: '👷',
          child: Column(
            children: [
              Text(
                'Add committee members (at least 1 required) / কমপক্ষে ১ জন সদস্য যোগ করুন',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight),
              ),
              const SizedBox(height: 12),
              ..._members.asMap().entries.map((e) => _CommitteeMemberRow(
                member: e.value,
                canRemove: _members.length > 1,
                onRemove: () => setState(() => _members.removeAt(e.key)),
                onChanged: (updated) => setState(() => _members[e.key] = updated),
              )),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.person_add_outlined, size: 16),
                label: const Text('Add Member / সদস্য যোগ করুন'),
                onPressed: () {
                  setState(() {
                    _members.add({'name': '', 'role': '', 'contact': ''});
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Documents
        FormSectionCard(
          title: 'Documents / দলিলপত্র',
          titleBn: 'Upload scanned copies of relevant documents',
          emoji: '📄',
          child: Column(
            children: [
              _DocumentUploadRow(type: 'Meeting Resolution / সভার সিদ্ধান্ত'),
              const SizedBox(height: 10),
              _DocumentUploadRow(type: 'Site Plan / স্থান নকশা'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Add Document / আরেকটি নথি যোগ করুন'),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              Text('PDF, JPG or PNG · Max 5MB each / সর্বোচ্চ ৫ এমবি', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSubmitting = false);
    if (!mounted) return;
    _showSuccessBottomSheet();
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 48, height: 4, decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('📤', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Submitted to UP Chairman!', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('চেয়ারম্যানের কাছে পাঠানো হয়েছে!', style: GoogleFonts.inter(fontSize: 14, color: AppColors.success, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Project ID: PM-2026-W03-041', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textLight)),
            Text('${_union.split('/').first.trim()} · $_ward · ${_fmt(_grandTotal)}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textLight)),
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
                  const Text('⏳', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: Awaiting Chairman Approval', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF92400E))),
                        Text('চেয়ারম্যানের অনুমোদনের অপেক্ষায়', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF78350F))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/secretary/projects');
                    },
                    child: const Text('View Projects'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/secretary/create-project');
                    },
                    child: const Text('Create Another'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _KhatwariRowWidget extends StatelessWidget {
  final Map<String, dynamic> row;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback? onRemove;

  const _KhatwariRowWidget({required this.row, required this.onChanged, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final amount = (row['qty'] as double) * (row['rate'] as double);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              initialValue: row['name'] as String,
              style: GoogleFonts.inter(fontSize: 12),
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), isDense: true),
              onChanged: (v) => onChanged({...row, 'name': v}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: row['unit'] as String,
              style: GoogleFonts.inter(fontSize: 12),
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), isDense: true),
              onChanged: (v) => onChanged({...row, 'unit': v}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: (row['qty'] as double).toStringAsFixed(0),
              style: GoogleFonts.inter(fontSize: 12),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), isDense: true),
              onChanged: (v) => onChanged({...row, 'qty': double.tryParse(v) ?? 0.0}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: (row['rate'] as double).toStringAsFixed(0),
              style: GoogleFonts.inter(fontSize: 12),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), isDense: true),
              onChanged: (v) => onChanged({...row, 'rate': double.tryParse(v) ?? 0.0}),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              '৳ ${amount.toStringAsFixed(0)}',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          SizedBox(
            width: 28,
            child: onRemove != null
                ? IconButton(
                    icon: const Icon(Icons.close, size: 14, color: AppColors.error),
                    onPressed: onRemove,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _CommitteeMemberRow extends StatelessWidget {
  final Map<String, String> member;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<Map<String, String>> onChanged;

  const _CommitteeMemberRow({required this.member, required this.canRemove, required this.onRemove, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: member['name'],
                  decoration: const InputDecoration(labelText: 'Name / নাম', isDense: true),
                  onChanged: (v) => onChanged({...member, 'name': v}),
                ),
              ),
              if (canRemove) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                  onPressed: onRemove,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: member['role'],
                  decoration: const InputDecoration(labelText: 'Role / ভূমিকা', isDense: true),
                  onChanged: (v) => onChanged({...member, 'role': v}),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: member['contact'],
                  decoration: const InputDecoration(labelText: 'Contact / যোগাযোগ', isDense: true),
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => onChanged({...member, 'contact': v}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentUploadRow extends StatefulWidget {
  final String type;

  const _DocumentUploadRow({required this.type});

  @override
  State<_DocumentUploadRow> createState() => _DocumentUploadRowState();
}

class _DocumentUploadRowState extends State<_DocumentUploadRow> {
  String _fileName = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _fileName.isNotEmpty ? AppColors.successLight : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _fileName.isNotEmpty ? AppColors.successBorder : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(_fileName.isNotEmpty ? '✅' : '📄', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.type, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(_fileName.isNotEmpty ? _fileName : 'No file chosen', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() => _fileName = 'document_${widget.type.split('/').first.trim().toLowerCase().replaceAll(' ', '_')}.pdf'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(_fileName.isNotEmpty ? 'Change' : 'Choose', style: GoogleFonts.inter(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const _StepIndicator({required this.currentStep, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final isActive = i == currentStep;
          final isDone = i < currentStep;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.success : (isActive ? AppColors.primary : AppColors.cardBorder),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : Text('${i + 1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: isActive ? Colors.white : AppColors.textMuted)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.value,
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400, color: isActive ? AppColors.primary : AppColors.textMuted),
                    ),
                  ],
                ),
                if (i < steps.length - 1) Expanded(child: Container(height: 2, color: i < currentStep ? AppColors.success : AppColors.cardBorder, margin: const EdgeInsets.only(bottom: 18))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final int step;
  final int totalSteps;
  final bool isSubmitting;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;
  final VoidCallback onCancel;

  const _NavigationButtons({
    required this.step,
    required this.totalSteps,
    required this.isSubmitting,
    this.onBack,
    this.onNext,
    required this.onSubmit,
    required this.onSaveDraft,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (step == totalSteps - 1) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              icon: isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send, size: 18),
              label: Text(isSubmitting ? 'Submitting...' : 'Submit to Chairman / চেয়ারম্যানের কাছে পাঠান'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            if (onBack != null)
              OutlinedButton(onPressed: onBack, child: const Text('← Back'))
            else
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
            const Spacer(),
            OutlinedButton(onPressed: onSaveDraft, child: const Text('💾 Save Draft')),
            if (onNext != null) ...[
              const SizedBox(width: 10),
              ElevatedButton(onPressed: onNext, child: const Text('Next →')),
            ],
          ],
        ),
      ],
    );
  }
}

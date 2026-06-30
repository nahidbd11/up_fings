import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdCtrl = TextEditingController(text: '01711-000001');
  final _passCtrl = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);
    if (mounted) context.go('/role-select');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Hero(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _LoginCard(
                      formKey: _formKey,
                      userIdCtrl: _userIdCtrl,
                      passCtrl: _passCtrl,
                      obscure: _obscure,
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                      errorMsg: _errorMsg,
                    ),
                    const SizedBox(height: 20),
                    _RolePills(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('🏛️', style: TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
              children: const [
                TextSpan(text: 'UP'),
                TextSpan(text: '@', style: TextStyle(color: Color(0xFF93C5FD))),
                TextSpan(text: 'Fingertips'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Digital Union Parishad Management System',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 4),
          Text(
            'ডিজিটাল ইউনিয়ন পরিষদ ব্যবস্থাপনা সিস্টেম',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🇧🇩  Ministry of Local Government, Rural Development and Co-operatives',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.85)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userIdCtrl;
  final TextEditingController passCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final bool isLoading;
  final String? errorMsg;

  const _LoginCard({
    required this.formKey,
    required this.userIdCtrl,
    required this.passCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.onLogin,
    required this.isLoading,
    this.errorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In / লগইন',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Enter your credentials to continue',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight),
            ),
            if (errorMsg != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.errorBorder),
                ),
                child: Text(
                  '⚠️ $errorMsg',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
                ),
              ),
            ],
            const SizedBox(height: 20),
            // User ID
            Text(
              'User ID / Mobile Number',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: userIdCtrl,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'User ID is required' : null,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline, size: 20, color: AppColors.textLight)),
            ),
            const SizedBox(height: 14),
            Text(
              'Password / পাসওয়ার্ড',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: passCtrl,
              obscureText: obscure,
              validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.textLight),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppColors.textLight),
                  onPressed: onToggleObscure,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
                child: Text(
                  'Forgot Password? / পাসওয়ার্ড ভুলে গেছেন?',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onLogin,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Login / লগইন  →', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Role is detected automatically after login', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Text(
                '🔐 After 5 failed attempts, account will be temporarily locked.\n৫ বার ব্যর্থ হলে অ্যাকাউন্ট সাময়িকভাবে লক হবে।',
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF9A3412)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RolePills extends StatelessWidget {
  final _roles = const [
    ('🏛️', 'DDLG'),
    ('🏢', 'UNO'),
    ('⚙️', 'Upazila Engineer'),
    ('📋', 'UP Administrator'),
    ('👑', 'UP Chairman'),
    ('📸', 'Committee Member'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Available for / যাদের জন্য:', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _roles.map((r) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                '${r.$1}  ${r.$2}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

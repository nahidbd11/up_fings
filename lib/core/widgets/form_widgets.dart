import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final String? labelBn;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppFormField({
    super.key,
    required this.label,
    this.labelBn,
    this.hint,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            if (labelBn != null) ...[
              const SizedBox(width: 4),
              Text(
                '/ $labelBn',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
            if (required)
              Text(' *', style: GoogleFonts.inter(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 14, color: readOnly ? AppColors.textSecondary : AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: readOnly ? const Color(0xFFF8FAFC) : AppColors.surface,
          ),
        ),
      ],
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String? labelBn;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool required;
  final bool readOnly;

  const AppDropdownField({
    super.key,
    required this.label,
    this.labelBn,
    required this.value,
    required this.items,
    required this.onChanged,
    this.required = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            if (labelBn != null) ...[
              const SizedBox(width: 4),
              Text('/ $labelBn', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
            ],
            if (required)
              Text(' *', style: GoogleFonts.inter(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: readOnly ? null : onChanged,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFF8FAFC) : AppColors.surface,
          ),
          isExpanded: true,
        ),
      ],
    );
  }
}

class FormSectionHeader extends StatelessWidget {
  final String title;
  final String? titleBn;
  final String emoji;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.titleBn,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              if (titleBn != null)
                Text(titleBn!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }
}

class FormSectionCard extends StatelessWidget {
  final String title;
  final String? titleBn;
  final String emoji;
  final Widget child;
  final Widget? headerTrailing;

  const FormSectionCard({
    super.key,
    required this.title,
    this.titleBn,
    required this.emoji,
    required this.child,
    this.headerTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      if (titleBn != null)
                        Text(titleBn!, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ),
                if (headerTrailing != null) headerTrailing!,
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class AppDateField extends StatefulWidget {
  final String label;
  final String? labelBn;
  final String initialValue;
  final bool required;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const AppDateField({
    super.key,
    required this.label,
    this.labelBn,
    required this.initialValue,
    this.required = false,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            if (widget.labelBn != null) ...[
              const SizedBox(width: 4),
              Text('/ ${widget.labelBn}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
            ],
            if (widget.required)
              Text(' *', style: GoogleFonts.inter(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          readOnly: widget.readOnly,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.readOnly ? const Color(0xFFF8FAFC) : AppColors.surface,
            suffixIcon: widget.readOnly ? null : const Icon(Icons.calendar_today, size: 18, color: AppColors.textLight),
          ),
          onTap: widget.readOnly
              ? null
              : () async {
                  final parts = _controller.text.split('-');
                  DateTime? initial;
                  try {
                    initial = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
                  } catch (_) {
                    initial = DateTime.now();
                  }
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initial,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    final formatted =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                    _controller.text = formatted;
                    widget.onChanged?.call(formatted);
                  }
                },
        ),
      ],
    );
  }
}

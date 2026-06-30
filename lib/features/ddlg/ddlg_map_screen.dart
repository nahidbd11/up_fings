import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';

class DdlgMapScreen extends StatefulWidget {
  const DdlgMapScreen({super.key});

  @override
  State<DdlgMapScreen> createState() => _DdlgMapScreenState();
}

class _DdlgMapScreenState extends State<DdlgMapScreen> {
  String _filterStatus = 'All';

  final List<String> _statusFilters = ['All', 'Ongoing', 'Completed', 'Pending'];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Map View / মানচিত্র দৃশ্য',
      subtitle: 'Narayanganj District — Project Locations',
      user: MockData.ddlgUser,
      navItems: const [],
      body: Column(
        children: [
          // Filter bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusFilters.map((f) {
                  final sel = _filterStatus == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f, style: GoogleFonts.inter(fontSize: 12)),
                      selected: sel,
                      onSelected: (_) => setState(() => _filterStatus = f),
                      selectedColor: AppColors.ddlgBg,
                      labelStyle: TextStyle(color: sel ? AppColors.ddlgFg : AppColors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.infoBorder, width: 1.5),
              ),
              child: Stack(
                children: [
                  // Map background grid
                  CustomPaint(painter: _MapGridPainter(), size: Size.infinite),
                  // Center content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined, size: 56, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text('Narayanganj District Map', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                        Text('নারায়ণগঞ্জ জেলা মানচিত্র', style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Text('Interactive map placeholder', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                        Text('(Google Maps or Mapbox integration needed)', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  // Fake project pins
                  ..._buildFakePins(),
                ],
              ),
            ),
          ),

          // Project list below map
          Expanded(
            flex: 2,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.allProjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = MockData.allProjects[i];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _statusColor(p.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Icon(Icons.location_on, size: 18, color: _statusColor(p.status))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('${p.ward} · ${p.gpsLat}, ${p.gpsLng}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _statusColor(p.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(p.status.name, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor(p.status))),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFakePins() {
    final positions = [
      const Offset(0.3, 0.35), const Offset(0.55, 0.5), const Offset(0.7, 0.25),
      const Offset(0.45, 0.65), const Offset(0.2, 0.6), const Offset(0.8, 0.7),
      const Offset(0.6, 0.8),
    ];
    final colors = [AppColors.success, AppColors.warning, AppColors.error, AppColors.primary, AppColors.success, AppColors.warning, AppColors.primary];
    return List.generate(positions.length, (i) => Positioned.fill(
      child: LayoutBuilder(builder: (ctx, constraints) => Stack(
        children: [
          Positioned(
            left: constraints.maxWidth * positions[i].dx,
            top: constraints.maxHeight * positions[i].dy,
            child: Icon(Icons.location_on, size: 24, color: colors[i % colors.length]),
          ),
        ],
      )),
    ));
  }

  Color _statusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.ongoing: return AppColors.warning;
      case ProjectStatus.completed: return AppColors.success;
      case ProjectStatus.pendingApproval: return AppColors.textMuted;
      default: return AppColors.primary;
    }
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.infoBorder
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

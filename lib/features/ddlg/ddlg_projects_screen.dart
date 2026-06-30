import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/project_list_tile.dart';

class DdlgProjectsScreen extends StatefulWidget {
  const DdlgProjectsScreen({super.key});

  @override
  State<DdlgProjectsScreen> createState() => _DdlgProjectsScreenState();
}

class _DdlgProjectsScreenState extends State<DdlgProjectsScreen> {
  String _search = '';
  String _filter = 'All';
  final List<String> _filters = ['All', 'Ongoing', 'Completed', 'Pending'];

  List<Project> get _filtered => MockData.allProjects.where((p) {
    final matchSearch = _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase());
    final matchFilter = _filter == 'All' ||
        (_filter == 'Ongoing' && p.status == ProjectStatus.ongoing) ||
        (_filter == 'Completed' && p.status == ProjectStatus.completed) ||
        (_filter == 'Pending' && p.status == ProjectStatus.pendingApproval);
    return matchSearch && matchFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;
    return AppScaffold(
      title: 'All Projects / সকল প্রকল্প',
      subtitle: 'Narayanganj District — Read Only',
      user: MockData.ddlgUser,
      navItems: const [],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: 'Search projects / প্রকল্প খুঁজুন',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = _filter == f;
                return ChoiceChip(
                  label: Text(f, style: GoogleFonts.inter(fontSize: 12)),
                  selected: sel,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.ddlgBg,
                  labelStyle: TextStyle(color: sel ? AppColors.ddlgFg : AppColors.textSecondary, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('${projects.length} project(s) · Read-only view', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: projects.isEmpty
                ? Center(child: Text('No projects found', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => ProjectListTile(project: projects[i], onTap: () => context.push('/ddlg/project/${projects[i].id}')),
                  ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/project_list_tile.dart';
import '../../core/widgets/status_badge.dart';

class UnoProjectsScreen extends StatefulWidget {
  const UnoProjectsScreen({super.key});

  @override
  State<UnoProjectsScreen> createState() => _UnoProjectsScreenState();
}

class _UnoProjectsScreenState extends State<UnoProjectsScreen> {
  String _search = '';
  String _filter = 'All';
  String _unionFilter = 'All Unions';

  final List<String> _filters = ['All', 'Ongoing', 'Completed', 'Awaiting Sanction', 'Pending Approval'];
  final List<String> _unions = ['All Unions', 'Fatullah', 'Siddhirganj', 'Kashipur', 'Enayetnagar'];

  List<Project> get _filtered {
    return MockData.allProjects.where((p) {
      final matchSearch = _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase()) || p.id.toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _filter == 'All' ||
          (_filter == 'Ongoing' && p.status == ProjectStatus.ongoing) ||
          (_filter == 'Completed' && p.status == ProjectStatus.completed) ||
          (_filter == 'Awaiting Sanction' && p.status == ProjectStatus.awaitingChairmanApproval) ||
          (_filter == 'Pending Approval' && p.status == ProjectStatus.pendingApproval);
      final matchUnion = _unionFilter == 'All Unions' || p.ward.contains(_unionFilter);
      return matchSearch && matchFilter && matchUnion;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;
    return AppScaffold(
      title: 'All Projects / সকল প্রকল্প',
      subtitle: 'Narayanganj Sadar — All Union Parishads',
      user: MockData.unoUser,
      navItems: const [],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: 'Search projects, IDs / প্রকল্প বা আইডি খুঁজুন',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Union filter
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _unions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final u = _unions[i];
                final selected = _unionFilter == u;
                return ChoiceChip(
                  label: Text(u, style: GoogleFonts.inter(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => setState(() => _unionFilter = u),
                  selectedColor: const Color(0xFF6366F1),
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = _filter == f;
                return ChoiceChip(
                  label: Text(f, style: GoogleFonts.inter(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${projects.length} project(s) found', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.folder_open_outlined, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 8),
                        Text('No projects found', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final p = projects[i];
                      return ProjectListTile(
                        project: p,
                        onTap: () => context.push('/uno/sanction/${p.id}'),
                        showSanctionButton: p.status == ProjectStatus.awaitingChairmanApproval,
                        sanctionLabel: '📋 Issue Sanction',
                        onSanction: () => context.push('/uno/sanction/${p.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


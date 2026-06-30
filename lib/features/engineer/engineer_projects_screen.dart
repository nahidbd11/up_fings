import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/project_list_tile.dart';

class EngineerProjectsScreen extends StatefulWidget {
  const EngineerProjectsScreen({super.key});

  @override
  State<EngineerProjectsScreen> createState() => _EngineerProjectsScreenState();
}

class _EngineerProjectsScreenState extends State<EngineerProjectsScreen> {
  String _search = '';
  String _filter = 'All';

  final List<String> _filters = ['All', 'Awaiting Vetting', 'Ongoing', 'Completed'];

  List<Project> get _filtered => MockData.allProjects.where((p) {
    final matchSearch = _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase()) || p.id.toLowerCase().contains(_search.toLowerCase());
    final matchFilter = _filter == 'All' ||
        (_filter == 'Awaiting Vetting' && p.status == ProjectStatus.awaitingEngineerVet) ||
        (_filter == 'Ongoing' && p.status == ProjectStatus.ongoing) ||
        (_filter == 'Completed' && p.status == ProjectStatus.completed);
    return matchSearch && matchFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;
    return AppScaffold(
      title: 'Projects / প্রকল্প তালিকা',
      subtitle: 'Engineering View · All Unions',
      user: MockData.engineerUser,
      navItems: const [],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: 'Search projects...',
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
                final selected = _filter == f;
                return ChoiceChip(
                  label: Text(f, style: GoogleFonts.inter(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.engineerFg,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: projects.isEmpty
                ? Center(child: Text('No projects found', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = projects[i];
                      return ProjectListTile(
                        project: p,
                        onTap: () => context.push('/engineer/project/${p.id}'),
                        showSanctionButton: p.status == ProjectStatus.awaitingEngineerVet,
                        sanctionLabel: '⚙️ Start Vetting',
                        onSanction: () => context.push('/engineer/vet/${p.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


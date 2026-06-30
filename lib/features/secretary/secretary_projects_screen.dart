import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock_data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/project_list_tile.dart';

class SecretaryProjectsScreen extends StatefulWidget {
  const SecretaryProjectsScreen({super.key});

  @override
  State<SecretaryProjectsScreen> createState() => _SecretaryProjectsScreenState();
}

class _SecretaryProjectsScreenState extends State<SecretaryProjectsScreen> {
  ProjectStatus? _filterStatus;
  String _search = '';

  List<Project> get _filtered {
    return MockData.allProjects.where((p) {
      final matchStatus = _filterStatus == null || p.status == _filterStatus;
      final matchSearch = _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase()) || p.id.toLowerCase().contains(_search.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Projects / প্রকল্পসমূহ',
      subtitle: 'Fatullah Union · FY 2025-26',
      user: MockData.secretaryUser,
      navItems: const [],
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search projects / প্রকল্প খুঁজুন',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                _FilterChip(label: 'All', isSelected: _filterStatus == null, onTap: () => setState(() => _filterStatus = null)),
                const SizedBox(width: 8),
                _FilterChip(label: '📁 Ongoing', isSelected: _filterStatus == ProjectStatus.ongoing, onTap: () => setState(() => _filterStatus = ProjectStatus.ongoing)),
                const SizedBox(width: 8),
                _FilterChip(label: '✅ Completed', isSelected: _filterStatus == ProjectStatus.completed, onTap: () => setState(() => _filterStatus = ProjectStatus.completed)),
                const SizedBox(width: 8),
                _FilterChip(label: '📅 Upcoming', isSelected: _filterStatus == ProjectStatus.upcoming, onTap: () => setState(() => _filterStatus = ProjectStatus.upcoming)),
                const SizedBox(width: 8),
                _FilterChip(label: '⏳ Awaiting', isSelected: _filterStatus == ProjectStatus.awaitingApproval, onTap: () => setState(() => _filterStatus = ProjectStatus.awaitingApproval)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${_filtered.length} projects', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight)),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Create'),
                  onPressed: () => context.push('/secretary/create-project'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final p = _filtered[i];
                      return ProjectListTile(
                        project: p,
                        onTap: () {},
                        trailing: Row(
                          children: [
                            if (p.status == ProjectStatus.ongoing)
                              OutlinedButton(
                                onPressed: () => context.push('/secretary/projects/${p.id}/progress'),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                child: Text('Progress', style: GoogleFonts.inter(fontSize: 11)),
                              ),
                            if (p.status == ProjectStatus.ongoing) ...[
                              const SizedBox(width: 6),
                              OutlinedButton(
                                onPressed: () => context.push('/secretary/projects/${p.id}/complete'),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                child: Text('Complete', style: GoogleFonts.inter(fontSize: 11)),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/secretary/create-project'),
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📁', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('No projects found', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Try changing the filters', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}



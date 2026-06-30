import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';
import 'features/auth/role_select_screen.dart';

import 'features/ddlg/ddlg_dashboard_screen.dart';
import 'features/ddlg/ddlg_projects_screen.dart';
import 'features/ddlg/ddlg_project_detail_screen.dart';
import 'features/ddlg/ddlg_map_screen.dart';

import 'features/uno/uno_dashboard_screen.dart';
import 'features/uno/uno_projects_screen.dart';
import 'features/uno/uno_duplicate_alerts_screen.dart';
import 'features/uno/uno_meeting_minutes_screen.dart';
import 'features/uno/uno_sanction_screen.dart';

import 'features/engineer/engineer_dashboard_screen.dart';
import 'features/engineer/engineer_projects_screen.dart';
import 'features/engineer/engineer_project_detail_screen.dart';
import 'features/engineer/engineer_vet_detail_screen.dart';

import 'features/sub_engineer/sub_engineer_dashboard_screen.dart';
import 'features/sub_engineer/sub_engineer_projects_screen.dart';

import 'features/secretary/secretary_dashboard_screen.dart';
import 'features/secretary/secretary_projects_screen.dart';
import 'features/secretary/secretary_create_project_screen.dart';
import 'features/secretary/secretary_duplicate_check_screen.dart';
import 'features/secretary/secretary_progress_screen.dart';
import 'features/secretary/secretary_extend_screen.dart';
import 'features/secretary/secretary_complete_screen.dart';
import 'features/secretary/secretary_minutes_list_screen.dart';
import 'features/secretary/secretary_minutes_screen.dart';

import 'features/chairman/chairman_dashboard_screen.dart';
import 'features/chairman/chairman_approve_screen.dart';
import 'features/chairman/chairman_budget_review_screen.dart';
import 'features/chairman/chairman_review_screen.dart';

import 'features/committee/committee_dashboard_screen.dart';
import 'features/committee/committee_upload_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectScreen()),

    // DDLG
    GoRoute(path: '/ddlg/dashboard', builder: (_, __) => const DdlgDashboardScreen()),
    GoRoute(path: '/ddlg/projects', builder: (_, __) => const DdlgProjectsScreen()),
    GoRoute(path: '/ddlg/projects/:id', builder: (_, state) => DdlgProjectDetailScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/ddlg/project/:id', builder: (_, state) => DdlgProjectDetailScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/ddlg/map', builder: (_, __) => const DdlgMapScreen()),

    // UNO
    GoRoute(path: '/uno/dashboard', builder: (_, __) => const UnoDashboardScreen()),
    GoRoute(path: '/uno/projects', builder: (_, __) => const UnoProjectsScreen()),
    GoRoute(path: '/uno/duplicate-alerts', builder: (_, __) => const UnoDuplicateAlertsScreen()),
    GoRoute(path: '/uno/meeting-minutes', builder: (_, __) => const UnoMeetingMinutesScreen()),
    GoRoute(path: '/uno/sanction', builder: (_, __) => const UnoSanctionScreen(projectId: 'PM-2026-W03-041')),
    GoRoute(path: '/uno/sanction/:id', builder: (_, state) => UnoSanctionScreen(projectId: state.pathParameters['id']!)),

    // Engineer
    GoRoute(path: '/engineer/dashboard', builder: (_, __) => const EngineerDashboardScreen()),
    GoRoute(path: '/engineer/projects', builder: (_, __) => const EngineerProjectsScreen()),
    GoRoute(path: '/engineer/projects/:id', builder: (_, state) => EngineerProjectDetailScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/engineer/project/:id', builder: (_, state) => EngineerProjectDetailScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/engineer/vet/:id', builder: (_, state) => EngineerVetDetailScreen(projectId: state.pathParameters['id']!)),

    // Sub-Engineer
    GoRoute(path: '/sub-engineer/dashboard', builder: (_, __) => const SubEngineerDashboardScreen()),
    GoRoute(path: '/sub-engineer/projects', builder: (_, __) => const SubEngineerProjectsScreen()),

    // Secretary (UP Administrator)
    GoRoute(path: '/secretary/dashboard', builder: (_, __) => const SecretaryDashboardScreen()),
    GoRoute(path: '/secretary/projects', builder: (_, __) => const SecretaryProjectsScreen()),
    GoRoute(path: '/secretary/create-project', builder: (_, __) => const SecretaryCreateProjectScreen()),
    GoRoute(path: '/secretary/duplicate-check', builder: (_, __) => const SecretaryDuplicateCheckScreen()),
    GoRoute(path: '/secretary/projects/:id/progress', builder: (_, state) => SecretaryProgressScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/secretary/projects/:id/extend', builder: (_, state) => SecretaryExtendScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/secretary/projects/:id/complete', builder: (_, state) => SecretaryCompleteScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/secretary/minutes', builder: (_, __) => const SecretaryMinutesListScreen()),
    GoRoute(path: '/secretary/minutes/new', builder: (_, __) => const SecretaryMinutesScreen()),

    // Chairman
    GoRoute(path: '/chairman/dashboard', builder: (_, __) => const ChairmanDashboardScreen()),
    GoRoute(path: '/chairman/approve/:id', builder: (_, state) => ChairmanApproveScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/chairman/budget-review/:id', builder: (_, state) => ChairmanBudgetReviewScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/chairman/review/:id', builder: (_, state) => ChairmanReviewScreen(projectId: state.pathParameters['id']!)),

    // Committee
    GoRoute(path: '/committee/dashboard', builder: (_, __) => const CommitteeDashboardScreen()),
    GoRoute(path: '/committee/projects/:id/upload', builder: (_, state) => CommitteeUploadScreen(projectId: state.pathParameters['id']!)),
    GoRoute(path: '/committee/upload/:id', builder: (_, state) => CommitteeUploadScreen(projectId: state.pathParameters['id']!)),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);

import '../models/models.dart';

class MockData {
  MockData._();

  // ─── Users ───────────────────────────────────────────────────────────────
  static const ddlgUser = AppUser(
    id: 'ddlg-001',
    name: 'SM Anisur Rahman',
    initials: 'AR',
    role: UserRole.ddlg,
    designation: 'DDLG, Narayanganj',
    location: 'Narayanganj District',
    notificationCount: 4,
  );

  static const unoUser = AppUser(
    id: 'uno-001',
    name: 'Abdul Karim Chowdhury',
    initials: 'AK',
    role: UserRole.uno,
    designation: 'UNO, NJ Sadar',
    location: 'Narayanganj Sadar Upazila',
    notificationCount: 5,
  );

  static const engineerUser = AppUser(
    id: 'eng-001',
    name: 'Yiaser Arafat',
    initials: 'YA',
    role: UserRole.engineer,
    designation: 'Upazila Engineer, NJ Sadar',
    location: 'Narayanganj Sadar',
    notificationCount: 2,
  );

  static const subEngineerUser = AppUser(
    id: 'sub-001',
    name: 'Kamrul Hasan',
    initials: 'KH',
    role: UserRole.subEngineer,
    designation: 'Junior Engineer',
    location: 'Narayanganj Sadar',
    notificationCount: 1,
  );

  static const secretaryUser = AppUser(
    id: 'sec-001',
    name: 'Rahim Uddin',
    initials: 'RU',
    role: UserRole.secretary,
    designation: 'Administrator, Fatullah UP',
    location: 'Fatullah Union, Narayanganj Sadar',
    notificationCount: 3,
  );

  static const chairmanUser = AppUser(
    id: 'chr-001',
    name: 'Alhaj Jahangir Alam',
    initials: 'JA',
    role: UserRole.chairman,
    designation: 'Chairman, Fatullah UP',
    location: 'Fatullah Union Parishad',
    notificationCount: 3,
  );

  static const committeeUser = AppUser(
    id: 'com-001',
    name: 'Jalal Uddin',
    initials: 'JU',
    role: UserRole.committee,
    designation: 'Committee Member',
    location: 'Ward 3, Fatullah Union',
    notificationCount: 0,
  );

  // ─── Khatwari Rows ───────────────────────────────────────────────────────
  static const List<KhatwariRow> ward3RoadKhatwari = [
    KhatwariRow(subHead: 'Earthwork / মাটির কাজ', unit: 'm³', qty: 120, rate: 800),
    KhatwariRow(subHead: 'Brick-Soling / ইটের সোলিং', unit: 'm²', qty: 800, rate: 280),
    KhatwariRow(subHead: 'Cement Concrete / সিমেন্ট কংক্রিট', unit: 'm³', qty: 40, rate: 4200),
    KhatwariRow(subHead: 'Bituminous Overlay / বিটুমিনাস আস্তর', unit: 'm²', qty: 800, rate: 120),
    KhatwariRow(subHead: 'Side Drain Repair / পার্শ্ব নালা', unit: 'm', qty: 250, rate: 380),
    KhatwariRow(subHead: 'Labour / শ্রমিক', unit: 'days', qty: 60, rate: 600),
    KhatwariRow(subHead: 'Supervision / তদারকি', unit: 'LS', qty: 1, rate: 18000),
    KhatwariRow(subHead: 'Contingency / আনুষঙ্গিক (5%)', unit: 'LS', qty: 1, rate: 36650),
  ];

  // ─── Committee Members ────────────────────────────────────────────────────
  static const List<CommitteeMember> ward3Committee = [
    CommitteeMember(name: 'Jalal Uddin', roleTitle: 'Chairman, Committee', contact: '01755-111222'),
    CommitteeMember(name: 'Anowara Begum', roleTitle: 'Member', contact: '01855-333444'),
  ];

  // ─── Documents ───────────────────────────────────────────────────────────
  static const List<ProjectDocument> ward3Docs = [
    ProjectDocument(type: 'Meeting Resolution / সভার সিদ্ধান্ত', fileName: 'meeting_resolution_ward3.pdf', size: '1.2 MB', icon: '📄'),
    ProjectDocument(type: 'Site Plan / স্থান নকশা', fileName: 'site_plan_ward3.jpg', size: '2.4 MB', icon: '🖼️'),
    ProjectDocument(type: 'Cost Estimate / ব্যয় প্রাক্কলন', fileName: 'cost_estimate_ward3.pdf', size: '0.8 MB', icon: '📄'),
  ];

  // ─── Projects ─────────────────────────────────────────────────────────────
  static const List<Project> allProjects = [
    Project(
      id: 'PM-2026-W03-041',
      name: 'Ward-3 Main Road Repair',
      nameBn: 'ওয়ার্ড-৩ সড়ক মেরামত',
      status: ProjectStatus.awaitingApproval,
      fundSource: FundSource.adp,
      khatSector: KhatSector.communication,
      projectType: 'Road / সড়ক',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 3',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 769650,
      startDate: '2026-03-01',
      endDate: '2026-06-30',
      financialYear: '2025–26',
      description:
          'Repair and resurfacing of the main road in Ward-3, Fatullah. Total length: 800m. Includes pothole filling, bituminous overlay, and side drain repair.',
      latitude: 23.6241,
      longitude: 90.4981,
      address: 'Near Fatullah Bazar, Ward-3 main road, Fatullah Union',
      khatwariBreakdown: ward3RoadKhatwari,
      committee: ward3Committee,
      documents: ward3Docs,
      submittedBy: 'Rahim Uddin (UP Administrator)',
      submittedDate: '29 Jun 2026',
      completionPercent: 0,
    ),
    Project(
      id: 'PM-2026-W05-002',
      name: 'Ward-5 Drainage Improvement',
      nameBn: 'ওয়ার্ড-৫ নালা উন্নয়ন',
      status: ProjectStatus.ongoing,
      fundSource: FundSource.adp,
      khatSector: KhatSector.health,
      projectType: 'Drainage / নালা',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 5',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 320000,
      startDate: '2026-01-15',
      endDate: '2026-05-30',
      financialYear: '2025–26',
      description: 'Drainage improvement for Ward-5 to prevent waterlogging.',
      latitude: 23.6255,
      longitude: 90.4960,
      address: 'Ward-5, Fatullah Union',
      hasDuplicateAlert: true,
      contractorName: 'Rahman Construction',
      completionPercent: 60,
    ),
    Project(
      id: 'PM-2026-W07-010',
      name: 'Ward-7 Mosque Expansion',
      nameBn: 'ওয়ার্ড-৭ মসজিদ সম্প্রসারণ',
      status: ProjectStatus.completed,
      fundSource: FundSource.onePct,
      khatSector: KhatSector.social,
      projectType: 'Mosque / মসজিদ',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 7',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 490000,
      startDate: '2025-08-01',
      endDate: '2025-11-30',
      financialYear: '2025–26',
      description: 'Expansion of the Ward-7 main mosque — new wing and ablution area.',
      latitude: 23.6290,
      longitude: 90.5010,
      address: 'Ward-7 Central Mosque, Fatullah Union',
      completionPercent: 100,
    ),
    Project(
      id: 'PM-2026-W06-013',
      name: 'Ward-6 Footpath Construction',
      nameBn: 'ওয়ার্ড-৬ ফুটপাথ নির্মাণ',
      status: ProjectStatus.completed,
      fundSource: FundSource.adp,
      khatSector: KhatSector.communication,
      projectType: 'Road / সড়ক',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 6',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 210000,
      startDate: '2026-02-01',
      endDate: '2026-04-30',
      financialYear: '2025–26',
      description: 'Construction of 300m footpath along the main road in Ward-6.',
      latitude: 23.6275,
      longitude: 90.4995,
      address: 'Ward-6 Main Road, Fatullah Union',
      completionPercent: 100,
    ),
    Project(
      id: 'PM-2026-W09-005',
      name: 'Road Repair near Bazar',
      nameBn: 'বাজারের নিকট সড়ক মেরামত',
      status: ProjectStatus.ongoing,
      fundSource: FundSource.own,
      khatSector: KhatSector.communication,
      projectType: 'Road / সড়ক',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 9',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 185000,
      startDate: '2026-04-01',
      endDate: '2026-07-31',
      financialYear: '2025–26',
      description: 'Repair of road near Fatullah Bazar area.',
      latitude: 23.6210,
      longitude: 90.5025,
      address: 'Near Fatullah Bazar, Ward-9',
      hasDuplicateAlert: true,
      completionPercent: 35,
    ),
    Project(
      id: 'PM-2026-W04-006',
      name: 'Ward-4 School Wall',
      nameBn: 'ওয়ার্ড-৪ স্কুল প্রাচীর',
      status: ProjectStatus.ongoing,
      fundSource: FundSource.adp,
      khatSector: KhatSector.education,
      projectType: 'Education / শিক্ষা',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 4',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 560000,
      startDate: '2026-01-01',
      endDate: '2026-06-30',
      financialYear: '2025–26',
      description: 'Construction of boundary wall for Ward-4 primary school.',
      latitude: 23.6263,
      longitude: 90.4975,
      address: 'Ward-4 Primary School, Fatullah Union',
      completionPercent: 70,
    ),
    Project(
      id: 'PM-2025-W02-018',
      name: 'Ward-2 Mosque Renovation',
      nameBn: 'ওয়ার্ড-২ মসজিদ সংস্কার',
      status: ProjectStatus.completed,
      fundSource: FundSource.onePct,
      khatSector: KhatSector.social,
      projectType: 'Mosque / মসজিদ',
      district: 'Narayanganj / নারায়ণগঞ্জ',
      upazila: 'Narayanganj Sadar / নারায়ণগঞ্জ সদর',
      union: 'Fatullah / ফতুল্লা',
      ward: 'Ward 2',
      upCode: 'BD-NAR-SJR-UP05',
      cost: 320000,
      startDate: '2025-10-01',
      endDate: '2025-12-31',
      financialYear: '2024–25',
      description: 'Full renovation of Ward-2 central mosque.',
      latitude: 23.6230,
      longitude: 90.4950,
      address: 'Ward-2 Central Mosque, Fatullah Union',
      completionPercent: 100,
    ),
  ];

  // ─── Meeting Minutes ──────────────────────────────────────────────────────
  static const List<MeetingMinutes> minutesList = [
    MeetingMinutes(
      id: 'MTG-2026-05',
      title: 'Monthly Meeting — May 2026',
      date: '28 May 2026',
      venue: 'UP Office, Fatullah Union Parishad',
      unionName: 'Fatullah Union',
      financialYear: '2025–26',
      totalMembers: 12,
      presentMembers: 9,
      agendaItems: [
        'Review of ongoing projects',
        'Approval of new project proposals',
        'Budget utilization report — Q3 FY 2025–26',
        'Community grievances',
      ],
      decisions: [
        'Ward-3 Main Road Repair project approved for submission to UNO.',
        'Ward-7 Mosque Expansion completion certified.',
        'Budget utilization at 68% — satisfactory progress noted.',
      ],
      submittedBy: 'Rahim Uddin (Administrator)',
      submittedDate: '30 May 2026',
      status: 'Submitted',
    ),
    MeetingMinutes(
      id: 'MTG-2026-04',
      title: 'Monthly Meeting — April 2026',
      date: '25 Apr 2026',
      venue: 'UP Office, Fatullah Union Parishad',
      unionName: 'Fatullah Union',
      financialYear: '2025–26',
      totalMembers: 12,
      presentMembers: 11,
      agendaItems: [
        'Progress review of Ward-5 Drainage project',
        'Ward-6 Footpath completion certification',
        'New project proposal discussions',
      ],
      decisions: [
        'Ward-6 Footpath Construction marked as completed.',
        'Ward-5 Drainage progress satisfactory — 60% complete.',
        'Chairman directed administrator to prepare Ward-3 road repair proposal.',
      ],
      submittedBy: 'Rahim Uddin (Administrator)',
      submittedDate: '28 Apr 2026',
      status: 'Submitted',
    ),
    MeetingMinutes(
      id: 'MTG-2026-03',
      title: 'Monthly Meeting — March 2026',
      date: '27 Mar 2026',
      venue: 'UP Office, Fatullah Union Parishad',
      unionName: 'Fatullah Union',
      financialYear: '2025–26',
      totalMembers: 12,
      presentMembers: 8,
      agendaItems: [
        'Q2 budget review',
        'Ward-4 School Wall progress',
        'Duplicate project alert discussion',
      ],
      decisions: [
        'Q2 budget utilization reviewed — 45% utilized.',
        'Ward-4 School Wall — contractor performance satisfactory.',
        'Duplicate alert for Ward-9 road project to be investigated.',
      ],
      submittedBy: 'Rahim Uddin (Administrator)',
      submittedDate: '30 Mar 2026',
      status: 'Submitted',
    ),
  ];

  // ─── Activity Feed ────────────────────────────────────────────────────────
  static const List<ActivityItem> recentActivity = [
    ActivityItem(
      title: 'Ward-2 Mosque Renovation marked as Completed',
      subtitle: 'Fatullah Union · Chairman: Alhaj Jahangir Alam',
      time: '2h ago',
      type: ActivityType.completed,
    ),
    ActivityItem(
      title: 'Ward-5 Drainage — Details Extension added',
      subtitle: 'Fatullah Union · Contractor assigned',
      time: '5h ago',
      type: ActivityType.info,
    ),
    ActivityItem(
      title: '⚠️ Duplicate Alert: Road Repair near Bazar — Ward 9',
      subtitle: 'Similar project found within 200m',
      time: '1d ago',
      type: ActivityType.warning,
    ),
    ActivityItem(
      title: 'Ward-3 Main Road Repair — 3 progress photos uploaded',
      subtitle: 'By: Jalal Uddin (Committee Member)',
      time: '1d ago',
      type: ActivityType.progress,
    ),
    ActivityItem(
      title: 'Monthly Meeting Minutes submitted by Administrator',
      subtitle: 'Fatullah Union · May 2026 meeting',
      time: '2d ago',
      type: ActivityType.minutes,
    ),
    ActivityItem(
      title: 'Ward-7 Road Extension — New project created',
      subtitle: 'Murapara Union · Upcoming',
      time: '3d ago',
      type: ActivityType.new_,
    ),
  ];

  // ─── Duplicate Alerts ─────────────────────────────────────────────────────
  static const List<DuplicateAlert> duplicateAlerts = [
    DuplicateAlert(
      projectName: 'Road Repair near Bazar',
      ward: 'Ward 9, Fatullah',
      similarTo: 'PM-2023-W03-015 — Ward-3 Road Repair (Old)',
      distance: '200m',
      projectId: 'PM-2026-W09-005',
      project1Id: 'PM-2026-W09-005',
      project1Name: 'Road Repair near Bazar — Ward 9',
      project2Id: 'PM-2023-W03-015',
      project2Name: 'Ward-3 Road Repair (Completed 2023)',
      similarityScore: 0.91,
      matchReasons: [
        'Name similarity: 91% match ("Road Repair" keyword)',
        'GPS distance: only 200m apart',
        'Same project type: Road/Communication',
        'Same fund source: ADP',
      ],
    ),
    DuplicateAlert(
      projectName: 'Drainage Construction',
      ward: 'Ward 5, Fatullah',
      similarTo: 'PM-2024-W05-008 — Drainage Work (Old)',
      distance: '350m',
      projectId: 'PM-2026-W05-002',
      project1Id: 'PM-2026-W05-002',
      project1Name: 'Drainage Construction — Ward 5',
      project2Id: 'PM-2024-W05-008',
      project2Name: 'Ward-5 Drainage System (Completed 2024)',
      similarityScore: 0.87,
      matchReasons: [
        'Name similarity: 87% match ("Drainage" keyword)',
        'GPS distance: 350m apart',
        'Same khat sector: Agriculture/Drainage',
      ],
    ),
  ];

  // ─── Union Summary ────────────────────────────────────────────────────────
  static const List<UnionSummary> unionSummaries = [
    UnionSummary(name: 'Fatullah', nameBn: 'ফতুল্লা', total: 34, ongoing: 14, completed: 17, upcoming: 3, code: 'BD-NAR-SJR-UP05'),
    UnionSummary(name: 'Siddhirganj', nameBn: 'সিদ্ধিরগঞ্জ', total: 22, ongoing: 9, completed: 11, upcoming: 2, code: 'BD-NAR-SJR-UP06'),
    UnionSummary(name: 'Kashipur', nameBn: 'কাশীপুর', total: 14, ongoing: 5, completed: 7, upcoming: 2, code: 'BD-NAR-SJR-UP07'),
    UnionSummary(name: 'Enayetnagar', nameBn: 'এনায়েতনগর', total: 8, ongoing: 3, completed: 3, upcoming: 2, code: 'BD-NAR-SJR-UP08'),
  ];

  // ─── Sub-Engineers ────────────────────────────────────────────────────────
  static const List<SubEngineer> subEngineers = [
    SubEngineer(name: 'Kamrul Hasan', initials: 'KH', assignedCount: 3, colorHex: '#F59E0B', designation: 'Sub-Assistant Engineer', phone: '01711-234567', area: 'Ward 1-3'),
    SubEngineer(name: 'Shariful Islam', initials: 'SI', assignedCount: 2, colorHex: '#10B981', designation: 'Sub-Assistant Engineer', phone: '01812-345678', area: 'Ward 4-6'),
    SubEngineer(name: 'Nazmul Huda', initials: 'NH', assignedCount: 2, colorHex: '#8B5CF6', designation: 'Junior Engineer', phone: '01913-456789', area: 'Ward 7-9'),
  ];
}

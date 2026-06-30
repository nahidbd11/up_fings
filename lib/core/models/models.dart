enum UserRole {
  ddlg,
  uno,
  engineer,
  subEngineer,
  secretary,
  chairman,
  committee,
}

enum ProjectStatus {
  upcoming,
  ongoing,
  completed,
  awaitingApproval,
  awaitingVetting,
  awaitingFundSanction,
  sentBack,
  pendingApproval,
  awaitingChairmanApproval,
  awaitingEngineerVet,
}

enum FundSource { adp, onePct, own, special }

enum KhatSector { communication, agriculture, health, education, social }

class AppUser {
  final String id;
  final String name;
  final String initials;
  final UserRole role;
  final String designation;
  final String location;
  final int notificationCount;

  const AppUser({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.designation,
    required this.location,
    this.notificationCount = 0,
  });
}

class KhatwariRow {
  final String subHead;
  final String unit;
  final double qty;
  final double rate;
  final String description;

  const KhatwariRow({
    required this.subHead,
    required this.unit,
    required this.qty,
    required this.rate,
    String? description,
  }) : description = description ?? subHead;

  double get amount => qty * rate;
}

class CommitteeMember {
  final String name;
  final String roleTitle;
  final String contact;

  const CommitteeMember({
    required this.name,
    required this.roleTitle,
    required this.contact,
  });

  String get role => roleTitle;
  String get phone => contact;
}

class ProjectDocument {
  final String type;
  final String fileName;
  final String size;
  final String icon;

  const ProjectDocument({
    required this.type,
    required this.fileName,
    required this.size,
    required this.icon,
  });
}

class ProgressPhoto {
  final String caption;
  final String uploadedBy;
  final String date;
  final String stageName;

  const ProgressPhoto({
    required this.caption,
    required this.uploadedBy,
    required this.date,
    required this.stageName,
  });
}

class Project {
  final String id;
  final String name;
  final String nameBn;
  final ProjectStatus status;
  final FundSource fundSource;
  final KhatSector khatSector;
  final String projectType;
  final String district;
  final String upazila;
  final String union;
  final String ward;
  final String upCode;
  final double cost;
  final String startDate;
  final String endDate;
  final String financialYear;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final List<KhatwariRow> khatwariBreakdown;
  final List<CommitteeMember> committee;
  final List<ProjectDocument> documents;
  final List<ProgressPhoto> progressPhotos;
  final bool hasDuplicateAlert;
  final String? submittedBy;
  final String? submittedDate;
  final String? contractorName;
  final int completionPercent;

  const Project({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.status,
    required this.fundSource,
    required this.khatSector,
    required this.projectType,
    required this.district,
    required this.upazila,
    required this.union,
    required this.ward,
    required this.upCode,
    required this.cost,
    required this.startDate,
    required this.endDate,
    required this.financialYear,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.khatwariBreakdown = const [],
    this.committee = const [],
    this.documents = const [],
    this.progressPhotos = const [],
    this.hasDuplicateAlert = false,
    this.submittedBy,
    this.submittedDate,
    this.contractorName,
    this.completionPercent = 0,
  });

  // Convenience getters for screen compatibility
  double get progressPercent => completionPercent.toDouble();
  double get gpsLat => latitude;
  double get gpsLng => longitude;
  List<KhatwariRow> get khatwariRows => khatwariBreakdown;
  String get type => projectType;
  String get fiscalYear => financialYear;
  String get currentStage => status.name;
}

class MeetingMinutes {
  final String id;
  final String title;
  final String date;
  final String venue;
  final String unionName;
  final String financialYear;
  final int totalMembers;
  final int presentMembers;
  final List<String> agendaItems;
  final List<String> decisions;
  final String submittedBy;
  final String submittedDate;
  final String status;

  const MeetingMinutes({
    required this.id,
    required this.title,
    required this.date,
    required this.venue,
    required this.unionName,
    required this.financialYear,
    required this.totalMembers,
    required this.presentMembers,
    required this.agendaItems,
    required this.decisions,
    required this.submittedBy,
    required this.submittedDate,
    required this.status,
  });
}

class StatCard {
  final String value;
  final String label;
  final String labelBn;
  final String icon;
  final bool isHighlighted;

  const StatCard({
    required this.value,
    required this.label,
    required this.labelBn,
    required this.icon,
    this.isHighlighted = false,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final ActivityType type;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
  });
}

enum ActivityType { completed, info, warning, progress, minutes, new_ }

class DuplicateAlert {
  final String projectName;
  final String ward;
  final String similarTo;
  final String distance;
  final String projectId;
  final String project1Id;
  final String project1Name;
  final String project2Id;
  final String project2Name;
  final double similarityScore;
  final List<String> matchReasons;

  const DuplicateAlert({
    required this.projectName,
    required this.ward,
    required this.similarTo,
    required this.distance,
    required this.projectId,
    String? project1Id,
    String? project1Name,
    String? project2Id,
    String? project2Name,
    this.similarityScore = 0.85,
    this.matchReasons = const [],
  })  : project1Id = project1Id ?? projectId,
        project1Name = project1Name ?? projectName,
        project2Id = project2Id ?? '',
        project2Name = project2Name ?? similarTo;
}

class UnionSummary {
  final String name;
  final String nameBn;
  final int total;
  final int ongoing;
  final int completed;
  final int upcoming;
  final String code;

  const UnionSummary({
    required this.name,
    required this.nameBn,
    required this.total,
    required this.ongoing,
    required this.completed,
    required this.upcoming,
    this.code = '',
  });

  int get totalProjects => total;
  int get ongoingProjects => ongoing;
}

class SubEngineer {
  final String name;
  final String initials;
  final int assignedCount;
  final String colorHex;
  final String designation;
  final String phone;
  final String area;

  const SubEngineer({
    required this.name,
    required this.initials,
    required this.assignedCount,
    required this.colorHex,
    this.designation = 'Sub-Assistant Engineer',
    this.phone = '01700-000000',
    this.area = 'Ward 1-3',
  });

  int get assignedProjects => assignedCount;
}

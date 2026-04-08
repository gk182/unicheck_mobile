class AttendanceStatsModel {
  final int present;
  final int absent;
  final int late;
  final int excused;

  AttendanceStatsModel({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsModel(
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      late: json['Late'] ?? 0,
      excused: json['Excused'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Present': present,
      'Absent': absent,
      'Late': late,
      'Excused': excused,
    };
  }
}

import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, late, excused, unknown }

class AttendanceRecord {
  final int attendanceId;
  final String courseName;
  final String roomName;
  final DateTime date;
  final DateTime? checkInTime;
  final AttendanceStatus status;
  final String? note;

  AttendanceRecord({
    required this.attendanceId,
    required this.courseName,
    required this.roomName,
    required this.date,
    required this.checkInTime,
    required this.status,
    this.note,
  });
}

class SubjectStat {
  final String subject;
  final int attended;
  final int total;
  final int absent;

  SubjectStat({
    required this.subject,
    required this.attended,
    required this.total,
    required this.absent,
  });

  double get percentage {
    if (total <= 0) return 0;
    return attended / total;
  }
}

AttendanceStatus parseAttendanceStatus(String raw) {
  switch (raw.toUpperCase()) {
    case 'PRESENT':
      return AttendanceStatus.present;
    case 'ABSENT':
      return AttendanceStatus.absent;
    case 'LATE':
      return AttendanceStatus.late;
    case 'EXCUSED':
      return AttendanceStatus.excused;
    default:
      return AttendanceStatus.unknown;
  }
}

Color attendanceStatusColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return const Color(0xFF10B981);
    case AttendanceStatus.absent:
      return const Color(0xFFEF4444);
    case AttendanceStatus.late:
      return const Color(0xFFF59E0B);
    case AttendanceStatus.excused:
      return const Color(0xFF6366F1);
    case AttendanceStatus.unknown:
      return const Color(0xFF6B7280);
  }
}

String attendanceStatusText(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return 'Co mat';
    case AttendanceStatus.absent:
      return 'Vang mat';
    case AttendanceStatus.late:
      return 'Di muon';
    case AttendanceStatus.excused:
      return 'Co phep';
    case AttendanceStatus.unknown:
      return 'Khong xac dinh';
  }
}

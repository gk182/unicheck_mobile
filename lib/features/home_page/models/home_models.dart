class UserProfile {
  final String name;
  final int unreadNotifications;

  UserProfile({
    required this.name, 
    this.unreadNotifications = 0,
  });
}

class ClassSession {
  final String subject;
  final String room;
  final String teacher;
  final String startTime;
  final String endTime;
  final String period; 
  final bool isOngoing; 
  
  ClassSession({
    required this.subject,
    required this.room,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.period,
    this.isOngoing = false,
  });
}

class AttendanceStats {
  final double percentage;
  final int present;
  final int absent;
  final int late;

  AttendanceStats({
    required this.percentage,
    required this.present,
    required this.absent,
    required this.late,
  });
}
class AttendanceHistoryModel {
  final int attendanceId;
  final String courseName;
  final String roomName;
  final DateTime date;
  final DateTime? checkInTime;
  final String status;
  final String? note;

  AttendanceHistoryModel({
    required this.attendanceId,
    required this.courseName,
    required this.roomName,
    required this.date,
    this.checkInTime,
    required this.status,
    this.note,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      attendanceId: json['attendanceId'] ?? 0,
      courseName: json['courseName'] ?? '',
      roomName: json['roomName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      checkInTime: json['checkInTime'] != null ? DateTime.tryParse(json['checkInTime']) : null,
      status: json['status'] ?? 'UNKNOWN',
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'courseName': courseName,
      'roomName': roomName,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime?.toIso8601String(),
      'status': status,
      'note': note,
    };
  }
}

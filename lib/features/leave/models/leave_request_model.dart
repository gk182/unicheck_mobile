class LeaveRequestModel {
  final int requestId;
  final int scheduleId;
  final String courseName;
  final String roomName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String reason;
  final String status;
  final String? attachmentUrl;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final DateTime? createdAt;

  LeaveRequestModel({
    required this.requestId,
    required this.scheduleId,
    required this.courseName,
    required this.roomName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reason,
    required this.status,
    this.attachmentUrl,
    this.reviewedAt,
    this.reviewNote,
    this.createdAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      requestId: json['requestId'] ?? 0,
      scheduleId: json['scheduleId'] ?? 0,
      courseName: json['courseName'] ?? '',
      roomName: json['roomName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      startTime: json['startTime'] ?? '00:00:00',
      endTime: json['endTime'] ?? '00:00:00',
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'UNKNOWN',
      attachmentUrl: json['attachmentUrl'],
      reviewedAt: json['reviewedAt'] != null ? DateTime.tryParse(json['reviewedAt']) : null,
      reviewNote: json['reviewNote'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'scheduleId': scheduleId,
      'courseName': courseName,
      'roomName': roomName,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'reason': reason,
      'status': status,
      'attachmentUrl': attachmentUrl,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewNote': reviewNote,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

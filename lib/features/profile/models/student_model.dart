class StudentModel {
  final String studentId;
  final String fullName;
  final String classCode;
  final String faculty;
  final String major;
  final String email;
  final DateTime dateOfBirth;
  final bool isFaceRegistered;
  final String username;

  StudentModel({
    required this.studentId,
    required this.fullName,
    required this.classCode,
    required this.faculty,
    required this.major,
    required this.email,
    required this.dateOfBirth,
    required this.isFaceRegistered,
    required this.username,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'] ?? '',
      fullName: json['fullName'] ?? '',
      classCode: json['classCode'] ?? '',
      faculty: json['faculty'] ?? '',
      major: json['major'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
      isFaceRegistered: json['isFaceRegistered'] ?? false,
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'fullName': fullName,
      'classCode': classCode,
      'faculty': faculty,
      'major': major,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'isFaceRegistered': isFaceRegistered,
      'username': username,
    };
  }
}

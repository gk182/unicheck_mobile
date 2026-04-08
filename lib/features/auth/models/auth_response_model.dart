class AuthResponseModel {
  final String token;
  final String userId;
  final String username;
  final String role;
  final String fullName;
  final DateTime expiresAt;

  AuthResponseModel({
    required this.token,
    required this.userId,
    required this.username,
    required this.role,
    required this.fullName,
    required this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'username': username,
      'role': role,
      'fullName': fullName,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}

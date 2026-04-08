/// Model map đúng response từ POST /api/attendance/check-in
///
/// Response 200:
/// {
///   "success": true,
///   "status": "PRESENT",
///   "message": "Điểm danh thành công!",
///   "faceVerified": true,
///   "faceConfidence": 0.94,
///   "locationVerified": true,
///   "distanceMeter": 23.5
/// }
class CheckInResponseModel {
  final bool success;
  final String status; // PRESENT | LATE
  final String message;
  final bool faceVerified;
  final double faceConfidence;
  final bool locationVerified;
  final double distanceMeter;

  CheckInResponseModel({
    required this.success,
    required this.status,
    required this.message,
    required this.faceVerified,
    required this.faceConfidence,
    required this.locationVerified,
    required this.distanceMeter,
  });

  factory CheckInResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckInResponseModel(
      success: json['success'] as bool? ?? false,
      status: json['status'] as String? ?? 'PRESENT',
      message: json['message'] as String? ?? 'Điểm danh thành công!',
      faceVerified: json['faceVerified'] as bool? ?? false,
      faceConfidence: (json['faceConfidence'] as num?)?.toDouble() ?? 0.0,
      locationVerified: json['locationVerified'] as bool? ?? false,
      distanceMeter: (json['distanceMeter'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// PRESENT → hiển thị "Đúng giờ", LATE → "Trễ giờ"
  String get statusLabel => status == 'LATE' ? 'Trễ giờ' : 'Đúng giờ';

  /// Màu hiển thị theo trạng thái
  bool get isLate => status == 'LATE';

  /// Confidence dạng phần trăm vd "94%"
  String get confidencePercent => '${(faceConfidence * 100).round()}%';

  /// Khoảng cách làm tròn vd "23.5 m"
  String get distanceLabel => '${distanceMeter.toStringAsFixed(1)} m';
}

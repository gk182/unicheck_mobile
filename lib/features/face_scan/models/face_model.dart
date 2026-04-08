class FaceScanResult {
  final bool isSuccess;
  final String message;
  final double confidenceScore;

  FaceScanResult({
    required this.isSuccess,
    required this.message,
    this.confidenceScore = 0.0,
  });
}
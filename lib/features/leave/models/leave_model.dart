enum LeaveStatus { approved, pending, rejected }

class LeaveRequest {
  final String subject;
  final String leaveDate;
  final String submitDate;
  final String reason;
  final LeaveStatus status;
  final String statusMessage;

  LeaveRequest({
    required this.subject,
    required this.leaveDate,
    required this.submitDate,
    required this.reason,
    required this.status,
    required this.statusMessage,
  });
}
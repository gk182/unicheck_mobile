import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:unicheck_mobile/core/api/api_exceptions.dart';
import 'package:unicheck_mobile/features/home_page/models/schedule_model.dart';
import 'package:unicheck_mobile/features/leave/models/leave_request_model.dart';
import 'package:unicheck_mobile/services/api/leave_request_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class LeaveController extends GetxController {
  final LeaveRequestApiService _leaveApi = Get.find<LeaveRequestApiService>();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController reasonController = TextEditingController();

  bool isNewRequestTab = true;
  bool isLoading = true;
  bool isRefreshing = false;
  bool isSubmitting = false;
  bool isUploadingAttachment = false;
  String? errorMessage;

  List<ScheduleModel> schedules = [];
  List<LeaveRequestModel> requests = [];
  int? selectedScheduleId;
  File? attachmentFile;
  String? attachmentUrl;
  String? attachmentName;

  String get selectedScheduleLabel {
    final schedule = selectedSchedule;
    if (schedule == null) return 'Chon mon hoc';
    final date = DateFormat('dd/MM/yyyy').format(schedule.date);
    final start = formatScheduleTime(schedule.startTime);
    final end = formatScheduleTime(schedule.endTime);
    return '${schedule.courseName} - $date ($start-$end)';
  }

  ScheduleModel? get selectedSchedule {
    if (selectedScheduleId == null) return null;
    for (final schedule in schedules) {
      if (schedule.scheduleId == selectedScheduleId) {
        return schedule;
      }
    }
    return null;
  }

  List<ScheduleModel> get availableSchedules {
    final list = schedules.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  void toggleTab(bool isNew) {
    if (isNewRequestTab == isNew) return;
    isNewRequestTab = isNew;
    update();
  }

  void selectSchedule(int? scheduleId) {
    selectedScheduleId = scheduleId;
    update();
  }

  Future<void> fetchInitialData({bool isManualRefresh = false}) async {
    if (isManualRefresh) {
      isRefreshing = true;
    } else {
      isLoading = true;
    }
    errorMessage = null;
    update();

    try {
      final futures = await Future.wait([
        _leaveApi.getLeaveRequests(),
        _leaveApi.getEligibleSchedules(),
      ]);

      requests = futures[0] as List<LeaveRequestModel>;
      schedules = futures[1] as List<ScheduleModel>;
      requests.sort((a, b) => b.date.compareTo(a.date));

      if (selectedScheduleId != null &&
          !availableSchedules.any((e) => e.scheduleId == selectedScheduleId)) {
        selectedScheduleId = null;
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
    } finally {
      isLoading = false;
      isRefreshing = false;
      update();
    }
  }

  Future<void> refreshData() => fetchInitialData(isManualRefresh: true);

  Future<void> submitRequest() async {
    if (isSubmitting) return;

    final schedule = selectedSchedule;
    if (schedule == null) {
      _showError('Vui long chon buoi hoc can xin nghi.');
      return;
    }

    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      _showError('Vui long nhap ly do xin nghi.');
      return;
    }

    isSubmitting = true;
    update();

    try {
      await _leaveApi.submitLeaveRequest(
        scheduleId: schedule.scheduleId,
        reason: reason,
        attachmentUrl: attachmentUrl,
      );

      Get.snackbar(
        'Thanh cong',
        'Da gui don xin nghi.',
        snackPosition: SnackPosition.BOTTOM,
      );

      _resetForm();
      isNewRequestTab = false;
      await fetchInitialData(isManualRefresh: true);
    } catch (e) {
      _showError(_extractApiError(e));
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> pickAttachment() async {
    if (isUploadingAttachment) return;

    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    isUploadingAttachment = true;
    update();

    try {
      final result = await _leaveApi.uploadAttachment(File(file.path));
      attachmentFile = File(file.path);
      attachmentUrl = result['attachmentUrl']?.toString();
      attachmentName = result['originalFileName']?.toString() ?? file.name;
      Get.snackbar(
        'Tai len thanh cong',
        attachmentName ?? 'Da tai minh chung',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _showError(_extractApiError(e));
    } finally {
      isUploadingAttachment = false;
      update();
    }
  }

  Future<void> clearAttachment() async {
    attachmentFile = null;
    attachmentUrl = null;
    attachmentName = null;
    update();
  }

  Future<void> openAttachment(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showError('Minh chung khong hop le.');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      _showError('Khong mo duoc minh chung.');
    }
  }

  String formatLeaveDate(DateTime value) => DateFormat('dd/MM/yyyy').format(value);

  String formatTimeRange(String startTime, String endTime) {
    final start = _normalizeTime(startTime);
    final end = _normalizeTime(endTime);
    return '$start - $end';
  }

  String formatScheduleTime(TimeOfDay time) => _formatTime(time);

  String formatReviewedAt(DateTime? value) {
    if (value == null) return 'Chua duyet';
    return DateFormat('dd/MM/yyyy HH:mm').format(value.toLocal());
  }

  String formatCreatedAt(DateTime? value) {
    if (value == null) return 'Khong ro';
    return DateFormat('dd/MM/yyyy HH:mm').format(value.toLocal());
  }

  String formatStatus(String raw) {
    switch (raw.toUpperCase()) {
      case 'APPROVED':
        return 'Chap nhan';
      case 'PENDING':
        return 'Dang duyet';
      case 'REJECTED':
        return 'Tu choi';
      default:
        return 'Khong xac dinh';
    }
  }

  Color statusColor(String raw) {
    switch (raw.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xFF10B981);
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData statusIcon(String raw) {
    switch (raw.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle_rounded;
      case 'PENDING':
        return Icons.pending_actions_rounded;
      case 'REJECTED':
        return Icons.error_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _normalizeTime(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    final hour = parts[0].padLeft(2, '0');
    final minute = parts[1].padLeft(2, '0');
    return '$hour:$minute';
  }

  void _resetForm() {
    reasonController.clear();
    selectedScheduleId = null;
    attachmentFile = null;
    attachmentUrl = null;
    attachmentName = null;
  }

  String _extractApiError(Object error) {
    if (error is ApiException) {
      final data = error.data;
      if (data is Map<String, dynamic>) {
        final code = error.code ?? data['code']?.toString();
        final message = data['message']?.toString();
        return _messageForCode(code, fallback: message ?? error.message);
      }
      return _messageForCode(error.code, fallback: error.message);
    }
    return error.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
  }

  String _messageForCode(String? code, {required String fallback}) {
    switch (code) {
      case 'UNAUTHORIZED':
        return 'Phien dang nhap da het han. Vui long dang nhap lai.';
      case 'LEAVE_REASON_REQUIRED':
        return 'Vui long nhap ly do xin nghi.';
      case 'LEAVE_REASON_TOO_SHORT':
        return 'Ly do xin nghi qua ngan.';
      case 'SCHEDULE_NOT_FOUND':
        return 'Buoi hoc khong ton tai.';
      case 'STUDENT_NOT_ENROLLED_FOR_SCHEDULE':
        return 'Ban khong thuoc danh sach lop cua buoi hoc nay.';
      case 'LEAVE_DEADLINE_PASSED':
        return 'Buoi hoc da dien ra, khong the nop don.';
      case 'LEAVE_SUBMISSION_WINDOW_CLOSED':
        return 'Da qua han nop don cho buoi hoc nay.';
      case 'LEAVE_ALREADY_SUBMITTED':
        return 'Ban da nop don cho buoi hoc nay roi.';
      case 'LEAVE_ATTACHMENT_REQUIRED':
        return 'Buoi hoc nay yeu cau tai len minh chung.';
      case 'LEAVE_ATTACHMENT_TOO_LARGE':
        return 'Minh chung vuot qua dung luong cho phep.';
      case 'LEAVE_ATTACHMENT_INVALID_TYPE':
        return 'Dinh dang minh chung khong hop le.';
      default:
        return fallback;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Loi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red.shade800,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:unicheck_mobile/features/leave/view_models/leave_controller.dart';

class LeaveFormView extends StatelessWidget {
  final LeaveController viewModel;

  const LeaveFormView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputFillColor =
        isDark
            ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
            : const Color(0xFFF3F4F6);
    final availableSchedules = viewModel.availableSchedules;
    final selectedSchedule = viewModel.selectedSchedule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buổi học cần xin nghỉ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? inputFillColor : Colors.transparent,
            border: Border.all(
              color: isDark ? theme.dividerColor : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              dropdownColor: theme.cardColor,
              hint: Text(
                'Chọn buổi học',
                style: TextStyle(fontSize: 14, color: theme.hintColor),
              ),
              value: viewModel.selectedScheduleId,
              items:
                  availableSchedules.map((schedule) {
                    return DropdownMenuItem<int>(
                      value: schedule.scheduleId,
                      child: Text(
                        '${schedule.courseName} (${viewModel.formatLeaveDate(schedule.date)})',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged:
                  availableSchedules.isEmpty ? null : viewModel.selectSchedule,
            ),
          ),
        ),
        if (availableSchedules.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Không còn buổi học nào có thể nộp đơn (có thể bạn đã nộp hết các buổi).',
            style: TextStyle(fontSize: 11, color: theme.hintColor),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          'Ngày nghỉ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                isDark
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.4)
                    : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: Color(0xFF1C51E6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedSchedule == null
                      ? 'Chọn buổi học để hiển thị ngày'
                      : viewModel.formatLeaveDate(selectedSchedule.date),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (selectedSchedule != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? theme.colorScheme.surfaceVariant.withOpacity(0.2)
                      : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: Color(0xFF1C51E6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${selectedSchedule.roomName} • '
                    '${viewModel.formatScheduleTime(selectedSchedule.startTime)} - '
                    '${viewModel.formatScheduleTime(selectedSchedule.endTime)}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          'Lý do nghỉ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: viewModel.reasonController,
          maxLines: 4,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Nhập lý do xin nghỉ học (tối thiểu 20 ký tự)',
            hintStyle: TextStyle(
              fontSize: 14,
              color: theme.hintColor.withOpacity(0.7),
            ),
            filled: true,
            fillColor:
                isDark
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.4)
                    : const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF1C51E6),
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lưu ý: cần ghi rõ lý do để đơn được xử lý nhanh hơn.',
          style: TextStyle(fontSize: 11, color: theme.hintColor),
        ),
        const SizedBox(height: 16),
        Text(
          'Minh chứng (nếu cần)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDark
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.2)
                    : const Color(0xFFF8FAFC),
            border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.attachmentName ?? 'Chưa tải minh chứng',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          viewModel.isUploadingAttachment
                              ? null
                              : viewModel.pickAttachment,
                      child:
                          viewModel.isUploadingAttachment
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Tải minh chứng'),
                    ),
                  ),
                  if (viewModel.attachmentUrl != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: viewModel.clearAttachment,
                        child: const Text('Xóa'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.orange.withOpacity(0.1)
                    : const Color(0xFFFFFBEB),
            border: Border.all(
              color:
                  isDark
                      ? Colors.orange.withOpacity(0.3)
                      : const Color(0xFFFDE68A),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Quyền nộp đơn và yêu cầu minh chứng được backend kiểm tra. '
            'Danh sách buổi học bên trên đã được backend lọc sẵn.',
            style: TextStyle(
              fontSize: 12,
              color:
                  isDark
                      ? Colors.orangeAccent.shade100
                      : const Color(0xFF92400E),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  viewModel.reasonController.clear();
                  viewModel.selectSchedule(null);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: theme.dividerColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    viewModel.isSubmitting ? null : viewModel.submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C51E6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    viewModel.isSubmitting
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Gửi đơn',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

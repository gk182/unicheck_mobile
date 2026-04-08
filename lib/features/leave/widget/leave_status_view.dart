import 'package:flutter/material.dart';
import 'package:unicheck_mobile/features/leave/view_models/leave_controller.dart';

class LeaveStatusView extends StatelessWidget {
  final LeaveController viewModel;

  const LeaveStatusView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (viewModel.requests.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, color: theme.hintColor, size: 34),
            const SizedBox(height: 10),
            Text(
              'Ban chua nop don nao.',
              style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: viewModel.requests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final req = viewModel.requests[index];
        final color = viewModel.statusColor(req.status);
        final statusText = viewModel.formatStatus(req.status);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? theme.dividerColor.withOpacity(0.1) : Colors.grey.shade100,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      req.courseName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(viewModel.statusIcon(req.status), color: color, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                theme,
                Icons.calendar_today_rounded,
                'Ngay nghi',
                viewModel.formatLeaveDate(req.date),
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                theme,
                Icons.meeting_room_outlined,
                'Phong',
                req.roomName,
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                theme,
                Icons.access_time_rounded,
                'Khung gio',
                viewModel.formatTimeRange(req.startTime, req.endTime),
              ),
              const SizedBox(height: 6),
              _buildInfoRow(
                theme,
                Icons.schedule_rounded,
                'Gui luc',
                viewModel.formatCreatedAt(req.createdAt),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.06)),
              const SizedBox(height: 12),
              Text(
                'Ly do:',
                style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                req.reason,
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.8)),
              ),
              if ((req.reviewNote ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phan hoi giang vien',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        req.reviewNote!,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: theme.colorScheme.onSurface.withOpacity(0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (req.reviewedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Duyet luc: ${viewModel.formatReviewedAt(req.reviewedAt)}',
                  style: TextStyle(fontSize: 11, color: theme.hintColor),
                ),
              ],
              if ((req.attachmentUrl ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => viewModel.openAttachment(req.attachmentUrl!),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Mo minh chung'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.hintColor),
        const SizedBox(width: 6),
        Text('$label: ', style: TextStyle(fontSize: 13, color: theme.hintColor)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

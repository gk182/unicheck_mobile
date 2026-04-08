import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicheck_mobile/features/history/models/history_model.dart';
import 'package:unicheck_mobile/features/history/view_models/history_controller.dart';

class HistoryCalendarView extends StatelessWidget {
  final HistoryController viewModel;

  const HistoryCalendarView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thang ${viewModel.focusedDay.month}/${viewModel.focusedDay.year}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          TableCalendar<AttendanceStatus>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: viewModel.focusedDay,
            selectedDayPredicate: (day) => isSameDay(viewModel.selectedDay, day),
            onDaySelected: viewModel.onDaySelected,
            onPageChanged: viewModel.onPageChanged,
            eventLoader: viewModel.getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: theme.hintColor, fontSize: 13, fontWeight: FontWeight.bold),
              weekendStyle: TextStyle(
                  color: theme.colorScheme.error.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
              ),
              todayTextStyle: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
              weekendDecoration: const BoxDecoration(shape: BoxShape.rectangle),
              outsideDecoration: const BoxDecoration(shape: BoxShape.rectangle),
              defaultTextStyle:
                  TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
              weekendTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.8), fontWeight: FontWeight.w500),
              outsideTextStyle: TextStyle(color: theme.hintColor.withOpacity(0.3)),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Positioned(
                  bottom: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(4).map((event) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: attendanceStatusColor(event),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'Chu thich:',
            style: TextStyle(fontSize: 12, color: theme.hintColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendItem(theme, AttendanceStatus.present),
              _buildLegendItem(theme, AttendanceStatus.late),
              _buildLegendItem(theme, AttendanceStatus.absent),
              _buildLegendItem(theme, AttendanceStatus.excused),
            ],
          ),
          const SizedBox(height: 18),
          _buildSelectedDayBlock(context),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, AttendanceStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: attendanceStatusColor(status), shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          attendanceStatusText(status),
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDayBlock(BuildContext context) {
    final theme = Theme.of(context);
    final selectedRecords = viewModel.selectedDayRecords;
    final selectedDay = viewModel.selectedDay;
    final title = selectedDay != null
        ? 'Ngay ${DateFormat('dd/MM/yyyy').format(selectedDay)}'
        : 'Chi tiet ngay';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (selectedRecords.isEmpty)
            Text('Khong co buoi hoc nao.',
                style: TextStyle(color: theme.hintColor, fontSize: 12))
          else
            ...selectedRecords.map((record) {
              final statusColor = attendanceStatusColor(record.status);
              final checkIn = record.checkInTime != null
                  ? DateFormat('HH:mm').format(record.checkInTime!)
                  : '--:--';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${record.courseName} - $checkIn',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.9)),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

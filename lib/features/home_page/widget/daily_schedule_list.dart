import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class DailyScheduleList extends StatelessWidget {
  final List<ScheduleModel> schedule;
  final ScheduleModel? currentClass;

  const DailyScheduleList({
    Key? key, 
    required this.schedule,
    this.currentClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lịch học trong ngày", 
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          )
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: schedule.length,
          itemBuilder: (context, index) {
            final item = schedule[index];
            final isLast = index == schedule.length - 1;
            final isOngoing = currentClass?.scheduleId == item.scheduleId;
            final startTimeStr = '${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}';
            
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isOngoing 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.surfaceVariant.withOpacity(isLight ? 1 : 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: !isOngoing ? Border.all(color: theme.dividerColor.withOpacity(0.1)) : null,
                        ),
                        child: Text(
                          "Ca ${index + 1}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isOngoing 
                                ? theme.colorScheme.onPrimary 
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2, 
                            color: theme.dividerColor.withOpacity(0.5), 
                          )
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface, 
                          borderRadius: BorderRadius.circular(12),
                          border: isOngoing 
                              ? Border.all(color: theme.colorScheme.primary, width: 1.5) 
                              : Border.all(color: theme.dividerColor.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isLight ? 0.03 : 0.2),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.courseName, 
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 15,
                                      color: theme.colorScheme.onSurface,
                                    )
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "$startTimeStr • ${item.roomName}", 
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6), 
                                      fontSize: 13
                                    )
                                  ),
                                ],
                              ),
                            ),
                            if (isOngoing)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1), 
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Text(
                                  "Đang học", 
                                  style: TextStyle(
                                    color: theme.colorScheme.primary, 
                                    fontSize: 10, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
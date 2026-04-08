import 'package:flutter/material.dart';
import '../models/history_model.dart';

class SubjectStatsView extends StatelessWidget {
  final List<SubjectStat> stats;

  const SubjectStatsView({Key? key, required this.stats}) : super(key: key);

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
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text('Thong ke theo mon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          if (stats.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Khong co du lieu thong ke trong thang nay.',
                style: TextStyle(color: theme.hintColor),
              ),
            )
          else
            ...stats.map((stat) {
              final Color progressColor =
                  stat.percentage < 0.7 ? const Color(0xFFEF4444) : theme.colorScheme.primary;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            stat.subject,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${(stat.percentage * 100).toInt()}%',
                            style: TextStyle(color: progressColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: stat.percentage,
                              backgroundColor: isDark
                                  ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
                                  : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('${stat.attended}/${stat.total}',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.55),
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Vang: ${stat.absent}',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

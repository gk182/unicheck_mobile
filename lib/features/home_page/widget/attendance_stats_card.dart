import 'package:flutter/material.dart';
import '../../history/models/attendance_stats_model.dart';

class AttendanceStatsCard extends StatelessWidget {
  final AttendanceStatsModel? stats;

  const AttendanceStatsCard({Key? key, required this.stats}) : super(key: key);

  Widget _buildLegendItem(BuildContext context, Color color, String label, int value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 10),
          const SizedBox(width: 8),
          Text(
            label, 
            style: TextStyle(
              fontSize: 13, 
              color: theme.colorScheme.onSurface.withOpacity(0.8)
            )
          ),
          const Spacer(),
          Text(
            value.toString(), 
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.bold, 
              color: color
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    double pct = 0;
    int present = stats?.present ?? 0;
    int absent = stats?.absent ?? 0;
    int lates = stats?.late ?? 0;
    int excused = stats?.excused ?? 0;
    
    int total = present + absent + lates + excused;
    if (total > 0) {
      pct = (present / total) * 100;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLight ? 0.05 : 0.2), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Theo dõi chuyên cần", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: theme.colorScheme.onSurface 
                    )
                  ),
                ],
              ),
              Text(
                "${pct.toInt()}%", 
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: total > 0 ? (present / total) : 0,
                      strokeWidth: 10,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                      color: theme.colorScheme.primary,
                    ),
                    Center(
                      child: Text(
                        "${pct.toInt()}%", 
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: theme.colorScheme.primary 
                        )
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(context, Colors.green, "Có mặt", present),
                    _buildLegendItem(context, Colors.redAccent, "Vắng", absent), 
                    _buildLegendItem(context, Colors.orange, "Đi muộn", lates),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:unicheck_mobile/features/history/models/attendance_stats_model.dart';

class SummaryCards extends StatelessWidget {
  final AttendanceStatsModel? stats;

  const SummaryCards({Key? key, required this.stats}) : super(key: key);

  Widget _buildCard(
      BuildContext context, String value, String label, Color color, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final present = stats?.present ?? 0;
    final absent = stats?.absent ?? 0;
    final late = stats?.late ?? 0;
    final excused = stats?.excused ?? 0;
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          width: cardWidth,
          child: _buildCard(context, '$present', 'Co mat', const Color(0xFF10B981),
              Icons.check_circle_outline),
        ),
        SizedBox(
          width: cardWidth,
          child:
              _buildCard(context, '$absent', 'Vang', const Color(0xFFEF4444), Icons.cancel_outlined),
        ),
        SizedBox(
          width: cardWidth,
          child:
              _buildCard(context, '$late', 'Di muon', const Color(0xFFF59E0B), Icons.schedule),
        ),
        SizedBox(
          width: cardWidth,
          child: _buildCard(context, '$excused', 'Co phep', const Color(0xFF6366F1),
              Icons.event_available_outlined),
        ),
      ],
    );
  }
}

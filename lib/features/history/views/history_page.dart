import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicheck_mobile/features/history/view_models/history_controller.dart';
import 'package:unicheck_mobile/features/history/widgets/history_calendar_view.dart';
import 'package:unicheck_mobile/features/history/widgets/history_list_view.dart';
import 'package:unicheck_mobile/features/history/widgets/history_toggle.dart';
import 'package:unicheck_mobile/features/history/widgets/subject_stats_view.dart';
import 'package:unicheck_mobile/features/history/widgets/summary_cards.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GetBuilder<HistoryController>(
        init: HistoryController(),
        builder: (controller) {
          if (controller.isLoading && !controller.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SummaryCards(stats: controller.stats),
                          const SizedBox(height: 16),
                          if (controller.errorMessage != null) _buildErrorBanner(context, controller),
                          const SizedBox(height: 12),
                          _buildSearchAndMonth(context, controller),
                          const SizedBox(height: 16),
                          HistoryToggle(
                            isListView: controller.isListView,
                            onToggle: controller.toggleView,
                          ),
                          const SizedBox(height: 20),
                          controller.isListView
                              ? HistoryListView(records: controller.records)
                              : HistoryCalendarView(viewModel: controller),
                          const SizedBox(height: 24),
                          SubjectStatsView(stats: controller.subjectStats),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 60),
      decoration: const BoxDecoration(
        color: Color(0xFF1C51E6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lich su & Thong ke',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Theo doi tinh trang chuyen can',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndMonth(BuildContext context, HistoryController controller) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: theme.hintColor),
                hintText: 'Tim mon hoc, phong, trang thai...',
                hintStyle: TextStyle(color: theme.hintColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () async {
            final selected = await _showMonthYearPicker(
              context: context,
              initial: controller.selectedMonth,
            );
            if (selected != null) {
              controller.changeMonth(selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                Text(controller.selectedMonthLabel,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 20, color: theme.colorScheme.primary),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<DateTime?> _showMonthYearPicker({
    required BuildContext context,
    required DateTime initial,
  }) {
    final now = DateTime.now();
    final minYear = 2020;
    final maxYear = 2035;
    final years = List<int>.generate(maxYear - minYear + 1, (i) => minYear + i);
    final monthLabels = const <String>[
      'Thang 1',
      'Thang 2',
      'Thang 3',
      'Thang 4',
      'Thang 5',
      'Thang 6',
      'Thang 7',
      'Thang 8',
      'Thang 9',
      'Thang 10',
      'Thang 11',
      'Thang 12',
    ];

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        int selectedMonth = initial.month;
        int selectedYear = initial.year.clamp(minYear, maxYear);

        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chon thang / nam',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedMonth,
                          decoration: const InputDecoration(
                            labelText: 'Thang',
                            border: OutlineInputBorder(),
                          ),
                          items: List<DropdownMenuItem<int>>.generate(
                            12,
                            (index) => DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text(monthLabels[index]),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedMonth = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedYear,
                          decoration: const InputDecoration(
                            labelText: 'Nam',
                            border: OutlineInputBorder(),
                          ),
                          items: years
                              .map((year) => DropdownMenuItem<int>(
                                    value: year,
                                    child: Text('$year'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(
                          DateTime(now.year, now.month),
                        ),
                        child: const Text('Thang hien tai'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Huy'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(
                          DateTime(selectedYear, selectedMonth),
                        ),
                        child: const Text('Ap dung'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorBanner(BuildContext context, HistoryController controller) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.errorMessage ?? 'Khong tai duoc du lieu',
              style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: controller.refreshData,
            child: const Text('Thu lai'),
          ),
        ],
      ),
    );
  }
}

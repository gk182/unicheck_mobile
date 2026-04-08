import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicheck_mobile/features/history/models/attendance_history_model.dart';
import 'package:unicheck_mobile/features/history/models/attendance_stats_model.dart';
import 'package:unicheck_mobile/features/history/models/history_model.dart';
import 'package:unicheck_mobile/services/api/attendance_api_service.dart';

class HistoryController extends GetxController {
  final AttendanceApiService _attendanceApi = Get.find<AttendanceApiService>();

  bool isListView = true;
  bool isLoading = true;
  bool isRefreshing = false;
  String? errorMessage;
  String searchQuery = '';

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final List<AttendanceHistoryModel> _allRecords = [];
  List<AttendanceRecord> _monthRecords = [];
  AttendanceStatsModel? stats;

  List<AttendanceRecord> records = [];
  List<SubjectStat> subjectStats = [];
  final Map<DateTime, List<AttendanceStatus>> _events = {};

  String get selectedMonthLabel => DateFormat('MM/yyyy').format(selectedMonth);

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData({bool isManualRefresh = false}) async {
    if (isManualRefresh) {
      isRefreshing = true;
      errorMessage = null;
    } else {
      isLoading = true;
      errorMessage = null;
    }
    update();

    try {
      final futures = await Future.wait([
        _attendanceApi.getHistory(),
        _attendanceApi.getStatistics(),
      ]);

      final history = futures[0] as List<AttendanceHistoryModel>;
      final statistics = futures[1] as AttendanceStatsModel;

      _allRecords
        ..clear()
        ..addAll(history)
        ..sort((a, b) {
          final aTime = a.checkInTime ?? a.date;
          final bTime = b.checkInTime ?? b.date;
          return bTime.compareTo(aTime);
        });

      stats = statistics;
      _rebuildDerivedData();
    } catch (e) {
      errorMessage = e.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
    } finally {
      isLoading = false;
      isRefreshing = false;
      update();
    }
  }

  Future<void> refreshData() => fetchData(isManualRefresh: true);

  void toggleView(bool isList) {
    if (isListView == isList) return;
    isListView = isList;
    update();
  }

  void updateSearchQuery(String value) {
    searchQuery = value.trim();
    _rebuildDerivedData();
    update();
  }

  void changeMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month);

    focusedDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    if (selectedDay == null ||
        selectedDay!.year != selectedMonth.year ||
        selectedDay!.month != selectedMonth.month) {
      selectedDay = focusedDay;
    }

    _rebuildDerivedData();
    update();
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    if (isSameDay(selectedDay, selected) && isSameDay(focusedDay, focused)) return;
    selectedDay = selected;
    focusedDay = focused;
    final newMonth = DateTime(focused.year, focused.month);
    if (newMonth.year != selectedMonth.year || newMonth.month != selectedMonth.month) {
      selectedMonth = newMonth;
      _rebuildDerivedData();
    }
    update();
  }

  void onPageChanged(DateTime focused) {
    focusedDay = focused;
    final newMonth = DateTime(focused.year, focused.month);
    if (newMonth.year != selectedMonth.year || newMonth.month != selectedMonth.month) {
      selectedMonth = newMonth;
      if (selectedDay == null ||
          selectedDay!.year != selectedMonth.year ||
          selectedDay!.month != selectedMonth.month) {
        selectedDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
      }
      _rebuildDerivedData();
    }
    update();
  }

  List<AttendanceStatus> getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _events[normalized] ?? [];
  }

  List<AttendanceRecord> get selectedDayRecords {
    if (selectedDay == null) return const [];
    return _monthRecords
        .where((r) =>
            r.date.year == selectedDay!.year &&
            r.date.month == selectedDay!.month &&
            r.date.day == selectedDay!.day)
        .toList();
  }

  bool get hasData => _allRecords.isNotEmpty;

  void _rebuildDerivedData() {
    final lowerQuery = searchQuery.toLowerCase();

    final filteredByMonth = _allRecords.where((item) {
      return item.date.year == selectedMonth.year && item.date.month == selectedMonth.month;
    }).toList();

    _monthRecords = filteredByMonth
        .map((item) => AttendanceRecord(
              attendanceId: item.attendanceId,
              courseName: item.courseName,
              roomName: item.roomName,
              date: item.date,
              checkInTime: item.checkInTime?.toLocal(),
              status: parseAttendanceStatus(item.status),
              note: item.note,
            ))
        .toList()
      ..sort((a, b) {
        final aTime = a.checkInTime ?? a.date;
        final bTime = b.checkInTime ?? b.date;
        return bTime.compareTo(aTime);
      });

    records = _monthRecords.where((item) {
      if (lowerQuery.isEmpty) return true;
      final haystack = [
        item.courseName,
        item.roomName,
        item.status.name,
        item.note ?? '',
      ].join(' ').toLowerCase();
      return haystack.contains(lowerQuery);
    }).toList()
      ..sort((a, b) {
        final aTime = a.checkInTime ?? a.date;
        final bTime = b.checkInTime ?? b.date;
        return bTime.compareTo(aTime);
      });

    _events.clear();
    for (final record in _monthRecords) {
      final day = DateTime(record.date.year, record.date.month, record.date.day);
      _events.putIfAbsent(day, () => <AttendanceStatus>[]).add(record.status);
    }

    final grouped = <String, List<AttendanceRecord>>{};
    for (final record in _monthRecords) {
      grouped.putIfAbsent(record.courseName, () => []).add(record);
    }

    subjectStats = grouped.entries.map((entry) {
      final total = entry.value.length;
      final attended = entry.value.where((e) {
        return e.status == AttendanceStatus.present ||
            e.status == AttendanceStatus.late ||
            e.status == AttendanceStatus.excused;
      }).length;
      final absent = entry.value.where((e) => e.status == AttendanceStatus.absent).length;
      return SubjectStat(
        subject: entry.key,
        attended: attended,
        total: total,
        absent: absent,
      );
    }).toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }
}

import 'package:intl/intl.dart';

extension StringDateExtension on String? {
  DateTime? convertToDateTime({String? dateFormat}) {
    if (this == null || this!.isEmpty) return null;
    return DateFormat('dd/MM/yyyy').parse(this!);
  }
}

extension DateExtension on DateTime {
  String convertToString() => DateFormat('dd/MM/yyyy').format(this);
}

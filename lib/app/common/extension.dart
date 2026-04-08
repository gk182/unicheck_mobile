extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String capitalize() {
    if (isNullOrEmpty) return '';
    return "${this![0].toLowerCase()}${this!.substring(1)}";
  }
}

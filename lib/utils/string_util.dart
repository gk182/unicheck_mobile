import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String removeDiacritics(String str) {
  const vietnamese =
      'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ'
      'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
  const nonVietnamese =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
      'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIoooooooooooooooooouuuuuuuuuuuyyyyyd';

  for (int i = 0; i < vietnamese.length; i++) {
    str = str.replaceAll(vietnamese[i], nonVietnamese[i]);
  }
  return str;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

String formatDateTime(String? dateTimeStr) {
  if (dateTimeStr == null) return 'Không rõ';

  try {
    // Parse the original datetime string
    DateTime dateTime = DateTime.parse(dateTimeStr);

    // Format to desired output: hh:mm dd/MM/yyyy
    return DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
  } catch (e) {
    return 'Không rõ';
  }
}

void setupTimeago() {
  timeago.setLocaleMessages(
      'vi', timeago.ViMessages()); // Đăng ký locale tiếng Việt
}

String getTimeAgo(DateTime createdAt) {
  return timeago.format(createdAt, locale: 'vi');
}


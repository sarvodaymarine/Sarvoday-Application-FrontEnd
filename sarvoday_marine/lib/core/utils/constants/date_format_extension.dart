import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  static onlyDateFormat(DateTime date) {
    DateFormat('d MMMM, yyyy').format(date);
  }

  static onlyDateTimeFormat(DateTime date) {
    DateFormat('dd-MM-yyyy').format(date);
  }
}

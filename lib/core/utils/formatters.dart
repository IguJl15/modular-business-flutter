import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

abstract class Formatters {
  static final completeDateTimeFormatter = DateFormat("dd/MM/yyyy 'às' HH:mm");
  static final dateFormatter = DateFormat('dd/MM/yyyy');
  static final timeFormatter = DateFormat('HH:mm:ss');

  static NumberFormat Function({
    int? decimalDigits,
    String? locale,
    String? name,
  }) currencyFormatter = NumberFormat.simpleCurrency;

  static String formatDate(DateTime dateTime) {
    if (dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0) {
      return dateFormatter.format(dateTime);
    } else if (dateTime.eqvYearMonthDay(DateTime.fromMicrosecondsSinceEpoch(0))) {
      return timeFormatter.format(dateTime);
    } else {
      return completeDateTimeFormatter.format(dateTime);
    }
  }
}

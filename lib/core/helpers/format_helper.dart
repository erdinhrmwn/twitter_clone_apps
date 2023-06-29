import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: avoid_classes_with_only_static_members
class FormatHelper {
  static String format(double value, String name, {int decimalDigits = 0}) {
    final format = NumberFormat.currency(name: name, decimalDigits: decimalDigits);
    final currency = format.format(value.abs());
    final firstNumber = currency.indexOf(RegExp('[0-9]'));

    return currency.replaceFirst(currency[firstNumber], ' ${value < 0 ? '-' : ''}${currency[firstNumber]}');
  }

  static String compactFormat(double value, {int decimalDigits = 0}) {
    final format = NumberFormat.compactCurrency(decimalDigits: decimalDigits);
    final currency = format.format(value.abs());
    final firstNumber = currency.indexOf(RegExp('[0-9]'));

    return currency.replaceFirst(currency[firstNumber], ' ${value < 0 ? '-' : ''}${currency[firstNumber]}');
  }

  static String formatDateTime(DateTime? dateTime, {String pattern = "dd MMMM yyyy"}) {
    if (dateTime == null) {
      return "-";
    }

    final dateFormatter = DateFormat(pattern);
    return dateFormatter.format(dateTime);
  }

  static String formatDiffForHumans(DateTime? dateTime) {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('id', timeago.IdMessages());

    String locale = 'en_short';
    // if (Get.locale?.languageCode == 'id') {
    //   locale = 'id_short';
    // }

    return timeago.format(dateTime ?? DateTime.now(), locale: locale);
  }
}

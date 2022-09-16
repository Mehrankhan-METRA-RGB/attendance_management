import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateNotifier extends ChangeNotifier{
  static DateFormat myFormat = DateFormat('yyyy-MM-dd');
  ValueNotifier selectedDate = ValueNotifier(
      DateTime.parse('${myFormat.format(DateTime.now())} 00:00:00'));
  ValueNotifier maxDate = ValueNotifier(
      DateTime.parse('${myFormat.format(DateTime.now())} 00:00:00'));
  ValueNotifier minDate = ValueNotifier(
      DateTime.parse('${myFormat.format(DateTime.now())} 00:00:00'));

  change(DateTime dateTime) {
    selectedDate.value =
        DateTime.parse('${myFormat.format(dateTime)} 00:00:00');
    notifyListeners();
  }

  changeMaxDate(DateTime dateTime) {
    maxDate.value = DateTime.parse('${myFormat.format(dateTime)} 00:00:00');
    notifyListeners();

  }

  changeMinDate(DateTime dateTime) {
    minDate.value = DateTime.parse('${myFormat.format(dateTime)} 00:00:00');
    notifyListeners();

  }
}

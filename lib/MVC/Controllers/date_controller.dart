import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
class DateNotifier{
  static DateFormat myFormat = DateFormat('yyyy-MM-dd');
  ValueNotifier selectedDate=ValueNotifier(DateTime.parse('${myFormat.format(DateTime.now())} 00:00:00'));

  change(DateTime dateTime){
    selectedDate.value= DateTime.parse('${myFormat.format(dateTime)} 00:00:00');
  }
}
import 'package:attendance_managemnt_system/MVC/Controllers/date_controller.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/pdf_controller.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/pdf/class_report.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../Models/teacher_model.dart';

class MultiDatePicker extends StatelessWidget {
  const MultiDatePicker(
      {Key? key, required this.teacherPrefs, required this.classPrefs})
      : super(key: key);
  // final Teacher teacherPrefs;
  final Class classPrefs;
  final Teacher teacherPrefs;
  static DateNotifier date = DateNotifier();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          width: double.infinity,
          color: Colors.teal,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Start Date',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: date.minDate,
            builder: (BuildContext context, currentDate, Widget? child) {
              return ScrollDatePicker(
                selectedDate: currentDate,
                minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                maximumDate: DateTime.now(),
                locale: const Locale('en'),
                onDateTimeChanged: (DateTime value) {
                  date.changeMinDate(value);
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          color: Colors.teal,
          child: Text(
            'End Date',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: date.maxDate,
            builder: (BuildContext context, currentDate, Widget? child) {
              return ScrollDatePicker(
                selectedDate: currentDate,
                minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                maximumDate: DateTime.now().add(const Duration(days: 1)),
                locale: const Locale('en'),
                onDateTimeChanged: (DateTime value) {
                  date.changeMaxDate(value);
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          color: Colors.grey.shade50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.teal),
                  )),
              TextButton(
                  onPressed: () async {
                    // s(BuildContext context){
                    //   App.instance.snackBar(context,text: 'PDF Generated in Documents Folder',bgColor: Colors.green);
                    //
                    // }
                    Navigator.pop(context);
                    await PdfController.instance
                        .generateReport(
                            teacher: teacherPrefs,
                            classPref: classPrefs,
                            maxDate: date.maxDate.value.toString(),
                            minDate: date.minDate.value.toString(),
                            context: context)
                        .then((data) async => await ClassReport.instance.widget(
                              classPrefs: classPrefs,
                              teacherPrefs: teacherPrefs,
                              data: data,
                              minDate: date.minDate.value.toString(),
                              maxDate: date.maxDate.value.toString(),
                            ))
                        .whenComplete(() {});
                  },
                  child: const Text(
                    'Generate',
                    style: TextStyle(color: Colors.teal),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

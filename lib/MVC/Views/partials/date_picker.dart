import 'package:attendance_managemnt_system/MVC/Controllers/date_controller.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../Models/teacher_model.dart';
import '../widgets/student/students_list.dart';

class AttendanceDate extends StatelessWidget {
  const AttendanceDate({Key? key,required this.classPrefs}) : super(key: key);
  // final Teacher teacherPrefs;
  final Class classPrefs;
  static final DateNotifier date = DateNotifier();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10,),
      Expanded(child:  SizedBox(
        height: 250,
        child: ValueListenableBuilder(
          valueListenable: date.selectedDate,
          builder: (BuildContext context, currentDate, Widget? child) {
            return ScrollDatePicker(
              selectedDate: currentDate,
                minimumDate:DateTime.now().subtract(const Duration(days:365)),
              maximumDate:DateTime.now(),
              locale: const Locale('en'),
              onDateTimeChanged: (DateTime value) {
                date.change(value);
              },
            );
          },
        ),
      ),),
      const SizedBox(height: 10,),
      SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  StudentsList(classPrefs: classPrefs,date: date.selectedDate.value.toString())));
                },
                child: const Text(
                  'Go',
                  style: TextStyle(color: Colors.teal),
                )),
          ],
        ),
      ),
    ],);
  }
}

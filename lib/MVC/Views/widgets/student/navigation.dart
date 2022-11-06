import 'dart:developer';

import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/pdf/class_report.dart';
import 'package:flutter/material.dart';

import '../../../Models/teacher_model.dart';
import 'multiDatePicker.dart';

class NavInStudent extends StatelessWidget {
  const NavInStudent({this.teacherPrefs, this.classPrefs, Key? key})
      : super(key: key);
  final Class? classPrefs;
  final Teacher? teacherPrefs;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      color: Colors.teal,
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Colors.blueGrey,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // const CircleAvatar(
                //   backgroundColor: Colors.teal,
                // ),
                Text(
                  'Attendance Application',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white54),
                )
              ],
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            title: const Text(
              'Generate Report',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.white,
            ),
            onTap: () {
              App.instance.dialog(context,
                  child: SizedBox(
                    height: 400,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: MultiDatePicker(
                      teacherPrefs: teacherPrefs!,
                      classPrefs: classPrefs!,
                    ),
                  ));
              // ClassReport.instance.widget(classPrefs:classPrefs!, teacherPrefs: teacherPrefs!);
            },
          ),
          // ListTile(
          //   style: ListTileStyle.drawer,
          //   title: const Text(
          //     'Test',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   leading: const Icon(
          //     Icons.picture_as_pdf_outlined,
          //     color: Colors.white,
          //   ),
          //   onTap: () {
          //     String a='2002-09-19 00:00:00.000';
          //     log('${DateTime.parse(a).isBefore(DateTime.now())}');
          //   },
          // ),
        ],
      ),
    );
  }
}

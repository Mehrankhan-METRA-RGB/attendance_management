import 'dart:convert';
import 'dart:io';

import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../Constants/enums.dart';
import '../Models/Collections.dart';
import '../Models/teacher_model.dart';

class PdfController {
  PdfController._private();
  static final PdfController instance = PdfController._private();
  Future<List<ReportModel>> generateReport(
      {required Teacher teacher,
      required Class classPref,
      String? maxDate,
      String? minDate,
      required BuildContext context}) async {
    List<Student> stdList = [];
    List<ReportModel> reportList = [];

    return FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacher.id)
        .collection(Collection.classCol)
        .doc(classPref.id)
        .collection(Collection.students)
        .get()
        .then((students) async {
      List<Student> stds = students.docs
          .map((e) => Student.fromJson(jsonEncode(e.data())))
          .toList();

      for (Student std in stds) {
        await FirebaseFirestore.instance
            .collection(Collection.teacher)
            .doc(teacher.id)
            .collection(Collection.classCol)
            .doc(classPref.id)
            .collection(Collection.students)
            .doc(std.id)
            .collection(Collection.attendance)
            .get()
            .then((atd) {
          Iterable<Attendance> attendances = atd.docs
              .map((e) => Attendance.fromJson(jsonEncode(e.data())))
              .where((at) =>
                  DateTime.parse(at.date!).isAfter(DateTime.parse(minDate!)) &&
                  DateTime.parse(at.date!).isBefore(DateTime.parse(maxDate!)));
          // log('STUDENT::::::::::${std.id}-${std.name}');
          // for(Attendance ad in attendances){
          //   log('date: ${ad.date!}');
          //   log('minDate : $minDate');
          //   bool j=DateTime.parse(ad.date!).isBefore(DateTime.parse(minDate!));
          //   log('$j');
          // }

          int total = attendances.length;
          int presents =
              attendances.where((e) => e.status == Status.present.name).length;
          int leaves =
              attendances.where((e) => e.status == Status.leave.name).length;
          int absents =
              attendances.where((e) => e.status == Status.absent.name).length;

          // for (DateTime dat = DateTime.parse(minDate!);
          //     dat.isBefore(DateTime.parse(maxDate!));
          //     dat = dat.add(const Duration(seconds: 24 * 60 * 60))) {
          //   log(dat.toString());
          // }

          ///presents percentage
          double percentage = (presents * 100) / total;
          // log('$percentage');
          ReportModel report = ReportModel(
              id: std.rollNo,
              name: std.name,
              percentage: percentage,
              attendance: attendances.toList());
          print(attendances.map((e) => e.date).toList());
          // Student newStd = std.copyWith(
          //     leaves: leaves,
          //     presents: presents,
          //     absents: absents,
          //     percentage: percentage);
          reportList.add(report);
          // stdList.add(newStd);
          // print(newStd.percentage);
        });
      }
      print(reportList
          .map((e) => e.attendance!.map((e) => e.date).toList())
          .toList());
      return reportList;
    });
  }

  Future savePDF(Uint8List bytes, name) async {
    try {
      final directory = await getExternalStorageDirectory();
      final filePath =
          '${directory?.parent.parent.parent.parent.path}/Documents/AttendanceReports';
      final fileDirectory = await Directory(filePath).create();

      File file = File(
          "${fileDirectory.path}/${name}_${DateTime.now().microsecond}.pdf");
      file.writeAsBytesSync(bytes);
    } catch (e) {
      if (kDebugMode) {
        print('Error:$e');
      }
    }
  }
}

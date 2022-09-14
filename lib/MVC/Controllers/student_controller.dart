import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendance_managemnt_system/Constants/packages/choice/choice_selector.dart';
import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../Constants/values.dart';

class StudentController {
  StudentController._private();
  static final instance = StudentController._private();

  Future<String> uploadPhoto(teacherId, classId,
      {required String? path, required extension}) async {
    StudentNotifier imgProgress = StudentNotifier();
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();
    String url = '';
    File file;
    if (path != null) {
      file = File(path);

// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .child(
              "students/teacher-$teacherId/class-$classId/${generateRandomString(10)}.$extension")
          .putFile(file.absolute);

// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            // imgProgress.imageProgress(progress);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
      url = await storageRef.getDownloadURL();
    }

    return url;
  }

  add(BuildContext context,
      {required teacherId,
      required path,
      required extension,
      required classId,
      required Student data}) async {
    CollectionReference users = FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students);

    StudentNotifier imgProgress = StudentNotifier();
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();
    String url = '';
    File file;
    if (path != null) {
      file = File(path);

// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .child(
              "students/teacher-$teacherId/class-$classId/${generateRandomString(10)}.$extension")
          .putFile(file.absolute);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            // imgProgress.imageProgress(progress);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            print("Upload was Error");
            break;
          case TaskState.success:
            print("Upload was success");
            // ...
            break;
        }
      });
      await uploadTask.whenComplete(() async {
        url = await uploadTask.snapshot.ref.getDownloadURL();
      });
    }

    users.add(data.copyWith(img: url).toMap()).then((value) {
      users.doc(value.id).update({'id': value.id});
      users
          .doc(value.id)
          .collection(Collection.attendance)
          .add(Attendance(date: ' ', status: ' ').toMap());

      App.instance
          .snackBar(context, text: 'student Added!! ', bgColor: Colors.green);
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error ', bgColor: Colors.red);
      // return null;
    });
  }

  Future<String?> status({
    required teacherId,
    required studentId,
    required classId,
    required currentDate,
  }) async {
    return await FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId)
        .collection(Collection.attendance)
        .doc(currentDate)
        .get()
        .then((data) => Attendance.fromMap(data.data()!).status);
  }

  addAttendance(
      {required teacherId,
      required studentId,
      required classId,
      bool isExist = false,
      required Attendance data}) {
    final DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore
        .instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId);

    ref.update({
      'attendance': FieldValue.arrayUnion([data.toMap()]),
    });
  }

  updateAttendance(
      {required teacherId,
      required studentId,
      required classId,
      required date,
      // required Attendance oldData,
      required Attendance newData}) {
    final CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore
        .instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId)
        .collection(Collection.attendance);

    ref.doc(date).set(newData.toMap());
  }

  Future<String?> getStatus({
    required teacherId,
    required studentId,
    required classId,
    required date,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
        .instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId)
        .collection(Collection.attendance)
        .doc(date)
        .get();
    Attendance attendance = Attendance(date: 'date', status: 'status');
    if (ref.exists) {
      attendance = Attendance.fromMap(ref.data()!);
    }
    return attendance.status;
  }

 List<String>? theCounts(teacherId, date, classId) {
    StudentNotifier studentNotifier = StudentNotifier();
    studentNotifier.clear();
    List<String>? dataList =[];
    final ref = FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students);

    ref.get().then((stds) {
      for (var e in stds.docs) {
        Student std = Student.fromJson(jsonEncode(e.data()));
        ref
            .doc(std.id)
            .collection(Collection.attendance)
            .doc(date)
            .get()
            .then((data) {
          Attendance atd = Attendance.fromJson(jsonEncode(data.data()));
          print('Sub-----theCount:${atd.status}');
          dataList.add(atd.status!);
        });
      }

    });

    return dataList;
  }
}

class StudentNotifier extends ChangeNotifier {
  ValueNotifier<List> present = ValueNotifier<List>([]);
  ValueNotifier<List> leave = ValueNotifier<List>([]);
  ValueNotifier<List> absent = ValueNotifier<List>([]);
  ValueNotifier<Map<String, int>> statusCounter =
      ValueNotifier<Map<String, int>>({'present': 0, 'leave': 0, 'absent': 0});

  clear() {
    present.value = [];
    absent.value = [];
    leave.value = [];
    notifyListeners();
  }

  void setStatusCounter(list) {
    // print(list);
    for (var val in list) {
      switch (val) {
        case 'present':
          present.value.add(val);
          break;
        case 'leave':
          leave.value.add(val);
          break;
        case 'absent':
          absent.value.add(val);
          break;
      }
    }

    statusCounter.value = {
      'present': present.value.length,
      'leave': leave.value.length,
      'absent': absent.value.length
    };
    notifyListeners();
    // print( 'present');
    // print( present.value.length);
    // print( 'leave');
    //
    // print(     leave.value.length);
    // print( 'absent');
    //
    // print(    absent.value.length);
  }
}

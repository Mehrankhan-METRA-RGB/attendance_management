import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            imgProgress.updateUploadProgress(100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes));
            break;
          case TaskState.paused:
            log("Upload is paused.");
            break;
          case TaskState.canceled:
            log("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            log("Uploaded Successfully");

            break;
        }
      });
      url = await storageRef.getDownloadURL();
    }

    return url;
  }

  Future<void> add(BuildContext context,
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
    await users.where('rollNo', isEqualTo: data.rollNo).get().then((res) async {
      if (res.docs.isNotEmpty) {
        App.instance.snackBar(
          context,
          text: 'This RollNo is already registered',
          bgColor: Colors.orange,
        );
      } else {
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
                imgProgress.updateUploadProgress(progress);
                log("Upload is $progress% complete.");
                break;
              case TaskState.paused:
                log("Upload is paused.");
                break;
              case TaskState.canceled:
                log("Upload was canceled");
                break;
              case TaskState.error:
                log("Upload was Error");
                break;
              case TaskState.success:
                log("Upload was success");
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
              //add a temp doc
              //because collection creation need at least one doc while creating
              .add(Attendance(date: '${DateTime.now()}', status: ' ').toMap())
              //delete doc again
              .then((ref) => users
                  .doc(value.id)
                  .collection(Collection.attendance)
                  .doc(ref.id)
                  .delete());

          App.instance.snackBar(context,
              text: 'student Added!! ', bgColor: Colors.green);
          Navigator.pop(context);

          return value;
        }).catchError((error) {
          App.instance.snackBar(context, text: error, bgColor: Colors.red);
          // return null;
        });
      }
    });
  }

  ///Delete Students
  void delete({
    required teacherId,
    required studentId,
    required classId,
  }) async {
    FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId)
        .delete()
        .then((value) => log('Deleted'));
  }

  ///Update Students
  void update(BuildContext context,
      {required teacherId,
      required studentId,
      required classId,
      required path,
      required extension,
      required Student data}) async {
    StudentNotifier imgProgress = StudentNotifier();
    final reference = FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId);
    final storageRef = FirebaseStorage.instance.ref();
    String? url = '';
    File file;
    if (path != '') {
      file = File(path);

      // delete old File
      if (data.img != null) {
        FirebaseStorage.instance.refFromURL(data.img!).delete();
      }

      final uploadTask = storageRef
          .child(
              "students/teacher-$teacherId/class-$classId/${generateRandomString(10)}.$extension")
          .putFile(file.absolute);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            imgProgress.updateUploadProgress(progress);
            log("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            log("Upload is paused.");
            break;
          case TaskState.canceled:
            log("Upload was canceled");
            break;
          case TaskState.error:
            log("Upload was Error");
            break;
          case TaskState.success:
            log("Upload was success");
            // ...
            break;
        }
      });
      await uploadTask.whenComplete(() async {
        url = await uploadTask.snapshot.ref.getDownloadURL();
        log('url:$url');
      });

      await reference.update(data.copyWith(img: url).toMap()).then((value) {
        App.instance.snackBar(context, text: 'Updated', bgColor: Colors.green);
        Navigator.pop(context);
      });
    } else {
      await reference.update(data.toMap()).then((value) {
        App.instance.snackBar(context, text: 'Updated', bgColor: Colors.green);
        Navigator.pop(context);
      });
    }
  }

  // Future<String?> status({
  //   required teacherId,
  //   required studentId,
  //   required classId,
  //   required currentDate,
  // }) async {
  //   return await FirebaseFirestore.instance
  //       .collection(Collection.teacher)
  //       .doc(teacherId)
  //       .collection(Collection.classCol)
  //       .doc(classId)
  //       .collection(Collection.students)
  //       .doc(studentId)
  //       .collection(Collection.attendance)
  //       .doc(currentDate)
  //       .get()
  //       .then((data) => Attendance.fromMap(data.data()!).status);
  // }

  void updateAttendance(
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

  ///get selected date STATUS of student i.e: [present,absent,leave]
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
    List<String>? dataList = [];
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
  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0.00);

  ValueNotifier<Map<String, int>> statusCounter =
      ValueNotifier<Map<String, int>>({'present': 0, 'leave': 0, 'absent': 0});

  void updateUploadProgress(double val) {
    uploadProgress.value = val;
    notifyListeners();
  }

  void clear() {
    present.value = [];
    absent.value = [];
    leave.value = [];
    notifyListeners();
  }

  void setStatusCounter(list) {
    // log(list);
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
  }
}

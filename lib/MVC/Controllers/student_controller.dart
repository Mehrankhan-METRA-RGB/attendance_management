import 'dart:io';
import 'dart:math';

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
            imgProgress.imageProgress(progress);
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
            imgProgress.imageProgress(progress);
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
      App.instance
          .snackBar(context, text: 'student Added!! ', bgColor: Colors.green);
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error ', bgColor: Colors.red);
      // return null;
    });
  }

  checkStatus({
    required teacherId,
    required studentId,
    required classId,
  }) {
    FirebaseFirestore.instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .get()
        .then((value) {
      print(value.docs.where((element) => element['id'] == studentId));
    }).catchError((onError) {
      print(onError);
    });
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
        required Attendance oldData,
        required Attendance newData}) {
    final DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore
        .instance
        .collection(Collection.teacher)
        .doc(teacherId)
        .collection(Collection.classCol)
        .doc(classId)
        .collection(Collection.students)
        .doc(studentId);

    ref.update({
      'attendance': FieldValue.arrayRemove([oldData.toMap()]),
    });
    ref.update({
      'attendance': FieldValue.arrayUnion([newData.toMap()]),
    });
  }


}

class StudentNotifier {
  static BoxDecoration defaultDecoration() => BoxDecoration(
      color: const Color(0xffffffff),
      boxShadow: const [
        BoxShadow(
            offset: Offset(0.5, 0.5),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            color: Color(0x353d3d3d))
      ],
      borderRadius: BorderRadius.circular(5));
  ValueNotifier colorNotifierPresent = ValueNotifier(defaultDecoration());
  ValueNotifier colorNotifierLeave = ValueNotifier(defaultDecoration());
  ValueNotifier colorNotifierAbsent = ValueNotifier(defaultDecoration());
  ValueNotifier progressNotifier = ValueNotifier(0.00);

  void presentColorChangeTo(BoxDecoration decoration) {
    colorNotifierPresent.value = decoration;
    colorNotifierLeave.value = defaultDecoration();
    colorNotifierAbsent.value = defaultDecoration();
  }

  void imageProgress(progress) {
    progressNotifier.value = progress;
  }

  void leaveColorChangeTo(BoxDecoration decoration) {
    colorNotifierLeave.value = decoration;
    colorNotifierPresent.value = defaultDecoration();
    colorNotifierAbsent.value = defaultDecoration();
  }

  void absentColorChangeTo(BoxDecoration decoration) {
    colorNotifierLeave.value = defaultDecoration();
    colorNotifierPresent.value = defaultDecoration();
    colorNotifierAbsent.value = decoration;
  }
}

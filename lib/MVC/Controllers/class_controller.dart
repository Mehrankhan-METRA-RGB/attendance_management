import 'dart:convert';

import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClassController {
  ClassController._private();

  static final instance = ClassController._private();
  ///Update
  Future<void> update(BuildContext context,
      {required String collection,
      required String document,
      required Map<String, Object?> data}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    await users.doc(document).update(data).then((value) {
      App.instance.snackBar(context, text: 'Done!! ');
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user: $error");
      }
      App.instance.snackBar(context, text: 'Error!! ');

      // App.instance.snackBar(context, text: "Failed to update user: $error",bgColor: Colors.redAccent);
    });
  }

  ///ADD
  Future<DocumentReference> add(BuildContext context,
      {required teacherId, required Class data}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(Collection.teacher);

    return users
        .doc(teacherId)
        .collection(Collection.classCol)
        .add(data.toMap())
        .then((value) {
      users.doc(teacherId)
          .collection(Collection.classCol).doc(value.id).update({'id': value.id});
      App.instance.snackBar(context, text: 'Done!! ');
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error ', bgColor: Colors.red);
      return error;
    });
  }



  Future<List<Teacher>> fetch({collection}) async {
    return FirebaseFirestore.instance.collection(collection).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((e) => Teacher.fromJson(jsonEncode(e.data())))
            .toList());
  }




  Future<void> delete(BuildContext context, {collection, docs}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    return users
        .doc(docs)
        .delete()
        .then((value) => App.instance.snackBar(context,
            text: 'Deleted successfully', bgColor: Colors.blue))
        .catchError((error) => App.instance.snackBar(context,
            text: "Failed to delete : $error", bgColor: Colors.red));
  }
}

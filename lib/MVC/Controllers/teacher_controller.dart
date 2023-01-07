import 'dart:convert';

import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/widgets/classes/classes_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/Widgets/teacher/login.dart';

class TeacherController {
  TeacherController._private();

  static final instance = TeacherController._private();

  setTeacherLocal(Teacher teacher) async {
    Map<String, dynamic> _teacher = teacher.toMap();
    final prefs = await SharedPreferences.getInstance();
    for (var key in _teacher.keys) {
      await prefs.setString(key, _teacher[key]);
    }
  }

  Future<Teacher> getTeacherLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return Teacher(
      id: prefs.getString('id'),
      name: prefs.getString('name'),
      email: prefs.getString('email'),
      // classes:
      //     prefs.getStringList('classes')?.map((e) => Class(name: e)).toList(),
      password: prefs.getString('Password'),
    );
  }

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

  Future<DocumentReference> add(BuildContext context, {required Teacher data}) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(Collection.teacher);

    return users.add(data.toMap()).then((value) {
      users.doc(value.id).update({'id': value.id});
      App.instance.snackBar(context, text: 'Done!! ');
      return value;
    }).catchError((error) {
      App.instance.snackBar(context, text: 'Error ', bgColor: Colors.red);
      return error;
    });
  }

  Future<void> googleSigIn(BuildContext context) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    CollectionReference fireBaseRef =
        FirebaseFirestore.instance.collection(Collection.teacher);

    await FirebaseFirestore.instance
        .collection(Collection.teacher)
        .where(
          'email',
          isEqualTo: googleUser!.email,
        )
        .where('id', isEqualTo: googleUser.id)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        Teacher a = querySnapshot.docs
            .map((e) => Teacher.fromJson(jsonEncode(e.data())))
            .toList()
            .first;
        setTeacherLocal(a);
        App.instance.snackBar(context,
            text: 'Signed In with google!!', bgColor: Colors.green);
      } else {
        await fireBaseRef
            .doc(googleUser.id)
            .set(Teacher(
                    id: googleUser.id,
                    name: googleUser.displayName,
                    email: googleUser.email,
                    password: googleUser.id)
                .toMap())
            .then((value) async {
          await FirebaseFirestore.instance
              .collection(Collection.teacher)
              .where(
                'email',
                isEqualTo: googleUser.email,
              )
              .where('id', isEqualTo: googleUser.id)
              .get()
              .then((QuerySnapshot snap) {
            Teacher a = snap.docs
                .map((e) => Teacher.fromJson(jsonEncode(e.data())))
                .toList()
                .first;
            setTeacherLocal(a);
          });
          App.instance.snackBar(context,
              text: 'Signed In with google!!', bgColor: Colors.green);
        }).catchError((error) {
          App.instance
              .snackBar(context, text: 'Error:$error ', bgColor: Colors.red);
        });
      }
    }).whenComplete(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ClassesList()));
    });

    // Call the googleUser's CollectionReference to add a new googleUser
  }

  Future<Teacher> login(BuildContext context, {email, password}) async {
    return FirebaseFirestore.instance
        .collection(Collection.teacher)
        .where('email', isEqualTo: email)
        .where('Password', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var a = querySnapshot.docs
            .map((e) => Teacher.fromJson(jsonEncode(e.data())))
            .toList()
            .first;

        App.instance.snackBar(context, text: 'Done!!', bgColor: Colors.green);
        setTeacherLocal(a);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ClassesList()));

        return a;
      } else {
        App.instance.snackBar(context,
            text: 'Wrong Credentials!!', bgColor: Colors.redAccent);

        return Teacher();
      }
    });
  }

  logout(BuildContext context) async {
    Teacher? teacher =
        Teacher(name: 'name', email: 'email', password: 'password', id: 'id');
    Map<String, dynamic> _teacher = teacher.toMap();
    final prefs = await SharedPreferences.getInstance();
    for (var key in _teacher.keys) {
      await prefs.setString(key, '');
      if (await GoogleSignIn().isSignedIn()) {
        GoogleSignIn().signOut();
      }
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
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

import 'dart:convert';

import 'package:attendance_managemnt_system/MVC/Controllers/teacher_controller.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/forms/classes/register_class.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/date_picker.dart';
import 'package:attendance_managemnt_system/MVC/Views/students_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Constants/widgets/widgets.dart';

class ClassesList extends StatefulWidget {
  const ClassesList({Key? key}) : super(key: key);

  @override
  _ClassesListState createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  Teacher? prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    await TeacherController.instance.getTeacherLocal().then((value) {
      setState(() {
        prefs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterClass(teacherPrefs: prefs!)));
            },
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              TeacherController.instance.logout(context);
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding:
          //   const EdgeInsets.only(top: 1.0, bottom: 2, left: 5, right: 5),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search ...',
          //       suffixIcon: IconButton(
          //           onPressed: () {},
          //           icon: const Icon(
          //             Icons.search,
          //             color: Colors.green,
          //           )),
          //       border: const OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(Collection.teacher)
                      .doc(prefs?.id)
                      .collection(Collection.classCol)
                      .orderBy('name')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Class>? _classes = snapshot.data?.docs
                        .map((e) => Class.fromJson(jsonEncode(e.data())))
                        .toList();

                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: _classes!.isNotEmpty
                            ? Column(
                                children: [
                                  for (Class _cls in _classes)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2),
                                      child: Card(
                                          color: Colors.teal.withOpacity(0.8),
                                          child: ListTile(
                                            style: ListTileStyle.list,
                                            title: Text(
                                              _cls.name!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                              _cls.department!,
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontSize: 11),
                                            ),
                                            onTap: () {

                                              App.instance.dialog(context, child: SizedBox(height:340,width:300,child: AttendanceDate(classPrefs: _cls,)));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             StudentList(
                                              //                 classPrefs:
                                              //                     _cls)));
                                            },
                                          )),
                                    )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Students Yet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(color: Colors.blueGrey),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterClass(
                                                      teacherPrefs: prefs!)));
                                    },
                                    child: const Text('Add Class'),
                                  )
                                ],
                              ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'loading...',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.blueGrey),
                        ),
                      );
                    }
                  })),
        ],
      ),
    );
  }
}

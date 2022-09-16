import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile(
      {this.studentPrefs, this.classPrefs, this.teacherPrefs, Key? key})
      : super(key: key);
  final Teacher? teacherPrefs;
  final Class? classPrefs;
  final Student? studentPrefs;

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> stream = FirebaseFirestore
        .instance
        .collection(Collection.teacher)
        .doc(teacherPrefs?.id)
        .collection(Collection.classCol)
        .doc(classPrefs?.id)
        .collection(Collection.students)
        .doc(studentPrefs?.id)
        .collection(Collection.attendance);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: studentPrefs?.img != null
                  ? Image.network(
                      studentPrefs!.img!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/icons/profile.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              studentPrefs?.name ?? ' ',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              studentPrefs?.rollNo ?? ' ',
              style: const TextStyle(fontSize: 20, color: Color(0xff7a7a7a)),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: ListTile(
                leading: const Icon(Icons.class_outlined),
                title: Text(classPrefs?.name ?? ' '),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: ListTile(
                leading: const Icon(Icons.category_outlined),
                title: Text(classPrefs?.department ?? ' '),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(Collection.teacher)
                        .doc(teacherPrefs?.id)
                        .collection(Collection.classCol)
                        .doc(classPrefs?.id)
                        .collection(Collection.students)
                        .doc(studentPrefs?.id)
                        .collection(Collection.attendance)
                        .where('status', isEqualTo: 'present')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                                    width: 0.5, color: Color(0xb6918f8f)))),
                        child: ListTile(
                          leading: const Icon(
                            Icons.circle,
                            color: Colors.green,
                          ),
                          title: snapshot.hasData
                              ? Text('${snapshot.data!.docs.length}')
                              : const SizedBox(width: 30,height: 10, child: LinearProgressIndicator()),
                        ),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: stream
                        .where('status', isEqualTo: 'leave')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                                    width: 0.5, color: Color(0xb6918f8f)))),
                        child: ListTile(
                          leading: const Icon(
                            Icons.circle,
                            color: Colors.orange,
                          ),
                          title: snapshot.hasData
                              ? Text('${snapshot.data!.docs.length}')
                              : const SizedBox(width: 30,height: 10,child: LinearProgressIndicator()),
                        ),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        stream.where('status', isEqualTo: 'absent').snapshots(),
                    builder: (context, snapshot) {
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                                    width: 0.5, color: Color(0xb6918f8f)))),
                        child: ListTile(
                          leading: const Icon(
                            Icons.circle,
                            color: Colors.red,
                          ),
                          title: snapshot.hasData
                              ? Text('${snapshot.data!.docs.length}')
                              : const SizedBox(width: 30,height: 10,child: LinearProgressIndicator()),
                        ),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: stream.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int total = snapshot.data!.docs.length - 1;
                        int presents = snapshot.data!.docs
                            .where((e) => e['status'] == 'present')
                            .length;
                        double percentage = (presents * 100) / total;
                        return Container(
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      width: 0.5, color: Color(0xb6918f8f)))),
                          child: ListTile(
                              leading: const Icon(Icons.percent),
                              title: Text('$percentage %')),
                        );
                      } else {
                        return const Text('Counting');
                      }
                    }),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
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
              child: Image.asset(
                'assets/icons/profile.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Neumann Ali Khan',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '9023749',
              style: TextStyle(fontSize: 20, color: Color(0xff7a7a7a)),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(Icons.class_outlined),
                title: Text('Software Engineering'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(Icons.category_outlined),
                title: Text('Department Of Computer Science'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
                title: Text('26'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.orange,
                ),
                title: Text('3'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.red,
                ),
                title: Text('11'),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(width: 0.5, color: Color(0xb6918f8f)))),
              child: const ListTile(
                leading: Icon(Icons.percent),
                title: Text('78'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

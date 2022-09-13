import 'dart:convert';
import 'package:attendance_managemnt_system/Constants/packages/choice/choice_selector.dart';
import 'package:attendance_managemnt_system/Constants/widgets/widgets.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/date_controller.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/student_controller.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/teacher_controller.dart';
import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/forms/student/register_student.dart';
import 'package:attendance_managemnt_system/MVC/Views/forms/student/student_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/teacher_model.dart';
import 'partials/students_tile.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({required this.classPrefs, Key? key}) : super(key: key);
  final Class classPrefs;
  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  TextEditingController searchController = TextEditingController();
  DateNotifier attendanceDate = DateNotifier();
  StudentNotifier studentNotifier = StudentNotifier();

  Teacher? teacherPrefs;
  List<Student>? students;
  List<Student>? tempStudents;
  Color? tileColor = Colors.white;
  int presentCount = 0;
  int leaveCount = 0;
  int absentCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              snap: false,
              expandedHeight: 180.0,
              toolbarHeight: 60,
              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.center,
                    color: Colors.teal,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 2),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white,
                      ),
                      height: 58,
                      child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          style: const TextStyle(color: Colors.teal),
                          cursorColor: Colors.teal,
                          decoration: _searchDecoration()),
                    ),
                  ),
                  expandedTitleScale: 1,
                  titlePadding: const EdgeInsets.all(0),
                  // centerTitle: true,
                  title: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.teal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Text('${widget.classPrefs.name}'),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterStudent(
                                            teacherPrefs: teacherPrefs!,
                                            classPrefs: widget.classPrefs,
                                          )));
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(Collection.teacher)
                    .doc(teacherPrefs?.id)
                    .collection(Collection.classCol)
                    .doc(widget.classPrefs.id)
                    .collection(Collection.students)
                    .orderBy(
                      'rollNo',
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  students = snapshot.data?.docs
                      .map((e) => Student.fromJson(jsonEncode(e.data())))
                      .toList();
                  List<Student>? stds;
                  if (searchController.text.isNotEmpty) {
                    stds = tempStudents;
                  } else {
                    stds = students;
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      snapshot.hasData
                          ? SingleChildScrollView(
                              primary: false,
                              child: stds!.isNotEmpty
                                  ? Column(
                                      children: [
                                        for (Student std in stds)
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      Collection.teacher)
                                                  .doc(teacherPrefs?.id)
                                                  .collection(
                                                      Collection.classCol)
                                                  .doc(widget.classPrefs.id)
                                                  .collection(
                                                      Collection.students)
                                                  .doc(std.id)
                                                  .collection(
                                                      Collection.attendance)
                                                  .where('date',
                                                      isEqualTo: attendanceDate
                                                          .selectedDate.value
                                                          .toString())
                                                  .snapshots(),
                                              builder: (context, snap) {
                                                Attendance? attendances;
                                                if (snap.hasData) {
                                                  attendances = snap
                                                          .data!.docs.isNotEmpty
                                                      ? snap.data?.docs
                                                          .map((e) => Attendance
                                                              .fromJson(
                                                                  jsonEncode(e
                                                                      .data()!)))
                                                          .first
                                                      : Attendance(
                                                          date: ' ',
                                                          status:
                                                              'NotAttended');

                                                  return AppTile(
                                                    img: std.img ?? '',
                                                    color: statusColor(
                                                        attendances!.status!),
                                                    title: std.name,
                                                    subTitle: std.rollNo,
                                                    onAbsent: () => setStatus(
                                                      std.id,
                                                      'absent',
                                                    ),
                                                    onLeave: () => setStatus(
                                                      std.id,
                                                      'leave',
                                                    ),
                                                    onPresent: () => setStatus(
                                                      std.id,
                                                      'present',
                                                    ),
                                                    onLongPress: () {
                                                      App.instance.dialog(
                                                          context,
                                                          child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              height: 300,
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    'Are you Sure to do This?'),
                                                              )));
                                                    },
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const StudentProfile()));
                                                    },
                                                  );
                                                } else {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 15),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.white54,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset: Offset(
                                                                  0.5, 0.5),
                                                              blurRadius: 2,
                                                              spreadRadius: 1,
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .outer)
                                                        ]),
                                                    child: const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                }
                                              })
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        'No Students Found',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(color: Colors.blueGrey),
                                      ),
                                    ),
                            )
                          : Center(
                              child: Text(
                                'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.blueGrey),
                              ),
                            ),
                    ]),
                  );
                }),
          ],
        ),
        bottomNavigationBar: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(Collection.teacher)
                .doc(teacherPrefs?.id)
                .collection(Collection.classCol)
                .doc(widget.classPrefs.id)
                .collection(Collection.students)
                .snapshots(),
            builder: (context, snap) {
              int present = 0;
              int leave = 0;
              int absent = 0;
              if (snap.hasData) {
                for (var e in snap.data!.docs) {
                  Student std = Student.fromJson(jsonEncode(e.data()));

                  FirebaseFirestore.instance
                      .collection(Collection.teacher)
                      .doc(teacherPrefs?.id)
                      .collection(Collection.classCol)
                      .doc(widget.classPrefs.id)
                      .collection(Collection.students)
                      .doc(std.id)
                      .collection(Collection.attendance)
                      .doc(attendanceDate.selectedDate.value.toString())
                      .get()
                      .then((data) {


                    Attendance atd =
                        Attendance.fromJson(jsonEncode(data.data()));
                    print(atd.status);
                    switch (atd.status) {
                      case 'present':
                        present++;
                        break;
                      case 'leave':
                        leave++;
                        break;
                      case 'absent':
                        absent++;
                        break;
                    }
                  });
                }
              }
              return BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: NavItem(
                      color: Colors.green,
                      value: '$present',
                    ),
                    label: 'Present',
                    tooltip: ' Present',
                  ),
                  BottomNavigationBarItem(
                    icon: NavItem(
                      color: Colors.orange,
                      value: '$leave',
                    ),
                    label: 'Leave',
                    tooltip: ' Leave',
                  ),
                  BottomNavigationBarItem(
                    icon: NavItem(
                      color: Colors.red,
                      value: '$absent',
                    ),
                    label: 'Absent',
                    tooltip: ' Absents',
                  ),
                ],
              );
            }));
  }

  void getData() async {
    await TeacherController.instance.getTeacherLocal().then((value) {
      setState(() {
        teacherPrefs = value;
      });
    });
  }

  void onSearchChanged(text) {
    if (students!.isNotEmpty) {
      setState(() {
        tempStudents = students
            ?.where((element) => element.rollNo!.startsWith(text))
            .toList();
      });
    }
  }

  void setStatus(studentId, status) {
    StudentController.instance.updateAttendance(
        teacherId: teacherPrefs!.id,
        classId: widget.classPrefs.id,
        studentId: studentId,
        newData: Attendance(
            date: attendanceDate.selectedDate.value.toString(), status: status),
        date: attendanceDate.selectedDate.value.toString());

    if (tempStudents != []) {
      tempStudents = students
          ?.where(
              (element) => element.rollNo!.startsWith(searchController.text))
          .toList();
    }
  }

  statusCount(status) {
    List<Student> localStudent = students ?? [];
    Iterable getData(value) {
      return localStudent.map((e) => e).where((ed) {
        bool arrayCheck = ed.attendance != null ? true : false;
        if (arrayCheck) {
          return ed.attendance!
              .where((element) => element.status!.startsWith(value))
              .isNotEmpty;
        } else {
          return false;
        }
      });
    }

    switch (status) {
      case 'leave':
        print(getData(status).length);
        return getData('leave').length;
      case 'absent':
        print(getData(status).length);

        return getData('absent').length;
      case 'present':
        print(getData(status).length);

        return getData('present').length;
      default:
        return 0;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.orange;
      default:
        return Colors.white;
    }
  }

  // statusColor(Student std) async {
  //   String status = 'Colors.white';
  //   await StudentController.instance.getStatus(
  //       teacherId: teacherPrefs?.id,
  //       studentId: std.id,
  //       classId: widget.classPrefs.id,
  //       date: attendanceDate.selectedDate.value.toString());
  //   return status;
  // }

  InputDecoration _searchDecoration() => InputDecoration(
        hintText: 'RollNo search ...',
        counterStyle: const TextStyle(color: Colors.teal),
        hintStyle: const TextStyle(color: Colors.teal),
        suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.teal,
            )),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(width: 1, color: Color(0xfce8e8e8))),
      );
}

class NavItem extends StatelessWidget {
  const NavItem({required this.color, required this.value, Key? key})
      : super(key: key);
  final Color color;
  final String value;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        color: color,
        child: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

import 'dart:convert';
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
  Teacher? teacherPrefs;
  List<Student>? students;
  List<Student>? tempStudents;
  Color? tileColor = Colors.white;
  int presentCount=0;
  int leaveCount=0;
  int absentCount=0;
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
      // appBar: AppBar(
      //   elevation: 0,
      // ),
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
                                        AppTile(
                                          img: std.img ?? '',
                                          color: statusColor(std),
                                          title: std.name,
                                          subTitle: std.rollNo,
                                          onAbsent: () =>
                                              setStatus(std.id, 'absent', std),
                                          onLeave: () =>
                                              setStatus(std.id, 'leave', std),
                                          onPresent: () =>
                                              setStatus(std.id, 'present', std),
                                          onLongPress: () {
                                            StudentController.instance
                                                .addAttendance(
                                                    classId:
                                                        widget.classPrefs.id,
                                                    studentId: std.id,
                                                    teacherId: teacherPrefs!.id,
                                                    data: Attendance(
                                                        date: 'date',
                                                        status: ' '));
                                            App.instance.dialog(context,
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height: 300,
                                                    child: const Center(
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
                                        )
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
      bottomNavigationBar: BottomNavigationBar(
        items:  [
          BottomNavigationBarItem(
            icon: NavItem(
              color: Colors.green,
              value: '$presentCount',
            ),
            label: 'Present',
            tooltip: ' Present',
          ),
          BottomNavigationBarItem(
            icon: NavItem(
              color: Colors.orange,
              value: '$leaveCount',
            ),
            label: 'Leave',
            tooltip: ' Leave',
          ),
          BottomNavigationBarItem(
            icon: NavItem(
              color: Colors.red,
              value: '$absentCount',
            ),
            label: 'Absent',
            tooltip: ' Absents',
          ),
        ],
      ),
    );
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

  void setStatus(studentId, status, Student std) {
    List attendance = std.attendance ?? [];

    if (attendance.isNotEmpty) {
      ///Update
      bool isCurrentDateAvailable = attendance.any((element) =>
          element.date.contains(attendanceDate.selectedDate.value.toString()));

      ///Attendance Available
      if (isCurrentDateAvailable) {
        Attendance oldData = attendance
            .where((element) => element.date
            .contains(attendanceDate.selectedDate.value.toString()))
            .first;
        StudentController.instance.updateAttendance(
            teacherId: teacherPrefs!.id,
            classId: widget.classPrefs.id,
            studentId: studentId,
            oldData: oldData,
            newData: Attendance(
                date: attendanceDate.selectedDate.value.toString(),
                status: status));
      }

      ///Attendance not Available
      else {
        StudentController.instance.addAttendance(
            teacherId: teacherPrefs!.id,
            classId: widget.classPrefs.id,
            studentId: studentId,
            data: Attendance(
                date: attendanceDate.selectedDate.value.toString(),
                status: status));
      }
    } else {
      ///when attendance List is empty
      StudentController.instance.addAttendance(
          teacherId: teacherPrefs!.id,
          classId: widget.classPrefs.id,
          studentId: studentId,
          data: Attendance(
              date: attendanceDate.selectedDate.value.toString(),
              status: status));
    }

    if(tempStudents!=[]){
      tempStudents = students
          ?.where((element) => element.rollNo!.startsWith(searchController.text))
          .toList();
    }
statusCount('leave');
statusCount('present');
statusCount('absent');
  }

  Color statusColor(Student std) {
    List attendance = std.attendance ?? [];
    if (attendance.isNotEmpty) {
      bool isCurrentDateAvailable = std.attendance?.any((element) => element
              .date!
              .contains(attendanceDate.selectedDate.value.toString())) ??
          false;

      if (isCurrentDateAvailable) {
        Attendance? a = std.attendance!
            .where((e) => attendanceDate.selectedDate.value
                .toString()
                .startsWith(e.date.toString()))
            .first;
        switch (a.status) {
          case 'present':
            return Colors.green;
          case 'leave':
            return Colors.orange;
          case 'absent':
            return Colors.red;
          default:
            return Colors.white;
        }
      }
    }

    return Colors.white;
  }

  statusCount(status){

    List<Student> localStudent=students??[];
    Iterable getData(value){
    return  localStudent.map((e) => e).where((ed){
        bool arrayCheck=ed.attendance!=null?true:false;
        if(arrayCheck){
          return ed.attendance!.where((element) => element.status!.startsWith(value)).isNotEmpty;

        }else{
          return false;
        }     } );
    }

    switch(status){
      case 'leave':
        print(getData(status).length);
      return  getData('leave').length;
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

// import 'dart:convert';
// import 'package:attendance_managemnt_system/MVC/Controllers/teacher_controller.dart';
// import 'package:attendance_managemnt_system/MVC/Models/Collections.dart';
// import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
// import 'package:attendance_managemnt_system/MVC/Views/forms/student/student_profile.dart';
// import 'package:attendance_managemnt_system/MVC/Views/partials/students_tile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../../Constants/widgets/widgets.dart';
// import '../Models/student_model.dart';
// import 'forms/student/register_student.dart';
//
// class StudentList extends StatefulWidget {
//   const StudentList({required this.classPrefs, Key? key}) : super(key: key);
//   final Class classPrefs;
//   @override
//   _StudentListState createState() => _StudentListState();
// }
//
// class _StudentListState extends State<StudentList> {
//   TextEditingController searchController=TextEditingController();
//   Teacher? teacherPrefs;
//   List<Student>? students;
//   List<Student>? tempStudents;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     getData();
//   }
//
//   getData() async {
//     await TeacherController.instance.getTeacherLocal().then((value) {
//       setState(() {
//         teacherPrefs = value;
//       });
//     });
//   }
//  void onSearchChanged(text){
//     if(students!.isNotEmpty){
//       setState((){
//         tempStudents=students?.where((element) => element.rollNo!.startsWith(text)).toList();
//         print(tempStudents);
//
//       });
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.classPrefs.name}'),
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => RegisterStudent(
//                             teacherPrefs: teacherPrefs!,
//                             classPrefs: widget.classPrefs,
//                           )));
//             },
//             icon: const Icon(Icons.add),
//             color: Colors.white,
//           )
//         ],
//         bottom: AppBar(primary:false,automaticallyImplyLeading: false,),
//
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 1.0, bottom: 2, left: 5, right: 5),
//             child: TextField(controller: searchController,
//               onChanged: onSearchChanged,
//               decoration: InputDecoration(
//                 hintText: 'RollNo search ...',
//
//                 suffixIcon: IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.search,
//                       color: Colors.green,
//                     )),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection(Collection.teacher)
//                       .doc(teacherPrefs?.id)
//                       .collection(Collection.classCol)
//                       .doc(widget.classPrefs.id)
//                       .collection(Collection.students)
//                       .orderBy(
//                         'rollNo',
//                       )
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     students = snapshot.data?.docs
//                         .map((e) => Student.fromJson(jsonEncode(e.data())))
//                         .toList();
//                     List<Student>? stds;
//                     if(searchController.text.isNotEmpty){
//                       stds=tempStudents;
//                     }else{
//                       stds=students;
//                     }
//
//
//                     if (snapshot.hasData) {
//                       return SingleChildScrollView(
//                         child: stds!.isNotEmpty
//                             ? Column(
//                                 children: [
//                                   for (Student _std in stds)
//                                     AppTile(
//                                       img: _std.img ?? '',
//                                       title: _std.name,
//                                       subTitle: _std.rollNo,
//                                       onLongPress: () {
//                                         App.instance.dialog(context,
//                                             child: SizedBox(
//                                                 width: MediaQuery.of(context)
//                                                         .size
//                                                         .width *
//                                                     0.9,
//                                                 height: 300,
//                                                 child: const Center(
//                                                   child: Text(
//                                                       'Are you Sure to do This?'),
//                                                 )));
//                                       },
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const StudentProfile()));
//                                       },
//                                     )
//                                 ],
//                               )
//                             : Center(
//                                 child: Text(
//                                   'No Students Found',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headline4
//                                       ?.copyWith(color: Colors.blueGrey),
//                                 ),
//                               ),
//                       );
//                     } else {
//                       return Center(
//                         child: Text(
//                           'Loading...',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium
//                               ?.copyWith(color: Colors.blueGrey),
//                         ),
//                       );
//                     }
//                   })),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: NavItem(
//               color: Colors.green,
//               value: '56',
//             ),
//             label: 'Present',
//             tooltip: ' Present',
//           ),
//           BottomNavigationBarItem(
//             icon: NavItem(
//               color: Colors.orange,
//               value: '12',
//             ),
//             label: 'Leave',
//             tooltip: ' Leave',
//           ),
//           BottomNavigationBarItem(
//             icon: NavItem(
//               color: Colors.red,
//               value: '9',
//             ),
//             label: 'Absent',
//             tooltip: ' Absents',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NavItem extends StatelessWidget {
//   const NavItem({required this.color, required this.value, Key? key})
//       : super(key: key);
//   final Color color;
//   final String value;
//   @override
//   Widget build(BuildContext context) {
//     return ClipOval(
//       child: Container(
//         width: 35,
//         height: 35,
//         alignment: Alignment.center,
//         color: color,
//         child: Text(
//           value,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

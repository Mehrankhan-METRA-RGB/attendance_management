import 'dart:io';

import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/forms/teacher/login.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/buttons.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/class_controller.dart';
import '../../../Controllers/student_controller.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent(
      {required this.teacherPrefs, required this.classPrefs, Key? key})
      : super(key: key);

  final Teacher teacherPrefs;
  final Class classPrefs;
  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final TextEditingController name = TextEditingController();
  final TextEditingController rollNo = TextEditingController();
  final registrationFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String extension = '';
  String currentImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        elevation: 0,
      ),
      body: Form(
        key: registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ClipOval(
              child: currentImage != ''
                  ? Image.file(
                      File(currentImage),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : Image.asset(
                      'assets/icons/profile.png',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
            ),
            ElevatedButton(
                onPressed: () async {
                  pickFile().then((value) {
                    setState(() {
                      currentImage = value!.files.first.path!;
                      extension = value.files.first.extension!;
                    });
                  });
                },
                child: const Text('Pick Image')),
            AppTextField(
              hint: 'Name',
              controller: name,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'RollNo',
              controller: rollNo,
              onChange: (a) {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: AppButton(
                child: const Text('add'),
                onPressed: () => _submit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FilePickerResult?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // File file;
    // if (result != null) {
    //   file = File(result.files.single.path!);
    // }
    return result;
  }

  _submit(BuildContext context) async {
    if (registrationFormKey.currentState!.validate()) {
      StudentController.instance.add(context,
          path: currentImage,
          extension: extension,
          data: Student(
            name: name.text,
            rollNo: rollNo.text,
            attendance: [],
            studentClass: widget.classPrefs.id,
            teacherId: widget.teacherPrefs.id,
          ),
          teacherId: widget.teacherPrefs.id,
          classId: widget.classPrefs.id);
    }
  }
}

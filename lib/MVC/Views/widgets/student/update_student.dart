import 'dart:developer';
import 'dart:io';

import 'package:attendance_managemnt_system/MVC/Models/student_model.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/buttons.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../Constants/widgets/widgets.dart';
import '../../../Controllers/class_controller.dart';
import '../../../Controllers/student_controller.dart';

class UpdateStudent extends StatefulWidget {
  const UpdateStudent(
      {required this.teacherPrefs,
      required this.studentPrefs,
      required this.classPrefs,
      Key? key})
      : super(key: key);
  final Student studentPrefs;
  final Teacher teacherPrefs;
  final Class classPrefs;
  @override
  _UpdateStudentState createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final TextEditingController name = TextEditingController();
  final TextEditingController rollNo = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.studentPrefs.name!;
    rollNo.text = widget.studentPrefs.rollNo!;
  }

  StudentNotifier stdNotify = StudentNotifier();
  String extension = '';
  String currentImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: StudentNotifier().uploadProgress,
                builder: (context, progress, widget) =>
                    LinearProgressIndicator(value:progress, color: Colors.redAccent,)),
            const SizedBox(height: 20,),
            ClipOval(
              child: currentImage != ''
                  ? Image.file(
                      File(currentImage),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : Image.network(
                      widget.studentPrefs.img!,
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
                child: const Text('Update'),
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
    if (formKey.currentState!.validate()) {
      log(currentImage);
      log(widget.studentPrefs.img!);
      StudentController.instance.update(context,
        path: currentImage,
        extension: extension,
        teacherId: widget.teacherPrefs.id,
        classId: widget.classPrefs.id,
        studentId: widget.studentPrefs.id,
        data: widget.studentPrefs.copyWith(
          name: name.text,
          rollNo: rollNo.text,
        ),
      );

    }
  }
}

import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/buttons.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/class_controller.dart';
import '../../Widgets/teacher/login.dart';

class RegisterClass extends StatefulWidget {
  const RegisterClass({required this.teacherPrefs, Key? key}) : super(key: key);

  final Teacher teacherPrefs;
  @override
  // ignore: library_private_types_in_public_api
  _RegisterClassState createState() => _RegisterClassState();
}

class _RegisterClassState extends State<RegisterClass> {
  final TextEditingController name = TextEditingController();
  final TextEditingController department = TextEditingController();
  final registrationFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Teacher'),
        elevation: 0,
      ),
      body: Form(
        key: registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              hint: 'Name',
              controller: name,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Department',
              controller: department,
              onChange: (a) {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: AppButton(
                child: const Text('Register'),
                onPressed: () {
                  if (registrationFormKey.currentState!.validate()) {
                    ClassController.instance
                        .add(context,
                            data: Class(
                              name: name.text,
                              department: department.text

                            ),
                            teacherId: widget.teacherPrefs.id)
                        .then((value) {
                      if (value.id.isNotEmpty) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
//
// var marker =(LatLng latLong)=> const Marker(
//   markerId: MarkerId('Company1'),
//   position:latLong ,
//   infoWindow: InfoWindow(
//     title: 'Van Tracker',
//     snippet: 'googleplex',
//   ),
// );
}

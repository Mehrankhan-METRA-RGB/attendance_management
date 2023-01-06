import 'package:attendance_managemnt_system/MVC/Controllers/teacher_controller.dart';
import 'package:attendance_managemnt_system/MVC/Models/teacher_model.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/buttons.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';

import '../../Widgets/teacher/login.dart';

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({Key? key}) : super(key: key);

  @override
  _RegisterTeacherState createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
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
              hint: 'Email',
              controller: email,
              onChange: (a) {},
            ),
            AppTextField(
              hint: 'Password',
              isPassword: true,
              controller: password,
              onChange: (a) {},
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: AppButton(
                child: const Text('Register'),
                onPressed: () {
                  if (registrationFormKey.currentState!.validate()) {
                    TeacherController.instance
                        .add(context,
                            data: Teacher(
                              name: name.text,
                              email: email.text,
                              password: password.text,
                            ))
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
            InkWell(
              onTap: () async {
                await TeacherController.instance.googleSigIn(context);
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          spreadRadius: 5,
                          blurRadius: 6)
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(
                        'assets/icons/google.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('SignIn with Google'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//

}

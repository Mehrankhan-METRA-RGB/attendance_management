import 'package:attendance_managemnt_system/MVC/Controllers/teacher_controller.dart';
import 'package:attendance_managemnt_system/MVC/Views/forms/teacher/register_teacher.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/buttons.dart';
import 'package:attendance_managemnt_system/MVC/Views/partials/text_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  final registrationFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  getData()async{
    await    TeacherController.instance.getTeacherLocal().then((prefs) {
      if(prefs.email!=null&&prefs.password!=null){
        email.text=prefs.email!;
        password.text=prefs.password!;
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: Form(
        key: registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                child: const Text('Login'),
                onPressed: () {
                  if (registrationFormKey.currentState!.validate()) {
                    TeacherController.instance
                        .login(context, email: email.text, password: password.text);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: TextButton(
                child: const Text(
                  'Register Now',
                  style: TextStyle(fontSize: 14, color: Colors.teal),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterTeacher()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
//

}

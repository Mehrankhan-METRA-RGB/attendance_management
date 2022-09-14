import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'MVC/Views/Widgets/teacher/login.dart';




void main() async{
  // test();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:
      // const LoginWithPhone()
      const Login(),
    );
  }
}

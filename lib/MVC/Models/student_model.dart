
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Student {
  Student({
    @required this.id,
    @required this.name,
    @required this.rollNo,
    @required this.img,
    @required this.studentClass,
    @required this.department,
    @required this.teacherId,
    @required this.attendance,
  });

  final String? id;
  final String? name;
  final String? rollNo;
  final String? img;
  final String? studentClass;
  final String? department;
  final String? teacherId;
  final List<Attendance>? attendance;

  Student copyWith({
    String? id,
    String? name,
    String? rollNo,
    String? img,
    String? studentClass,
    String? department,
    String? teacherId,
    List<Attendance>? attendance,
  }) =>
      Student(
        id: id ?? this.id,
        name: name ?? this.name,
        rollNo: rollNo ?? this.rollNo,
        img: img ?? this.img,
        studentClass: studentClass ?? this.studentClass,
        department: department ?? this.department,
        teacherId: teacherId ?? this.teacherId,
        attendance: attendance ?? this.attendance,
      );

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Student.fromMap(Map<String, dynamic> json) => Student(
    id: json["id"],
    name: json["name"],
    rollNo: json["rollNo"],
    img: json["img"],
    studentClass: json["class"],
    department: json["department"],
    teacherId: json["teacherId"],
    attendance: List<Attendance>.from(json["attendance"].map((x) => Attendance.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "rollNo": rollNo,
    "img": img,
    "class": studentClass,
    "department": department,
    "teacherId": teacherId,
    "attendance": List<dynamic>.from(attendance!.map((x) => x.toMap())),
  };
}

class Attendance {
  Attendance({
    @required this.date,
    @required this.status,
  });

  final String? date;
  final String? status;

  Attendance copyWith({
    String? date,
    String? status,
  }) =>
      Attendance(
        date: date ?? this.date,
        status: status ?? this.status,
      );

  factory Attendance.fromJson(String str) => Attendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
    date: json["date"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "date": date,
    "status": status,
  };
}

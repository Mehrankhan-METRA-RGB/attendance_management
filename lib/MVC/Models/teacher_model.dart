
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Teacher {
  Teacher({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.password,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? password;

  Teacher copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) =>
      Teacher(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory Teacher.fromJson(String str) => Teacher.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Teacher.fromMap(Map<String, dynamic> json) => Teacher(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["Password"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "Password": password,
  };
}

class Class {
  Class({
    @required this.name,
    @required this.department,
    @required this.id,
  });

  final String? name;
  final String? department;
  final String? id;

  Class copyWith({
    String? name,
    String? department,
    String? id,
  }) =>
      Class(
        name: name ?? this.name,
        department: department ?? this.department,
        id: id ?? this.id,
      );

  factory Class.fromJson(String str) => Class.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    name: json["name"],
    department: json["department"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "department": department,
    "id": id,
  };
}

// ignore_for_file: prefer_collection_literals
import 'dart:convert';

import 'package:flutter/cupertino.dart';


List<Map<String, dynamic>> mapData = [];
List<Map<String, dynamic>> duplicates = [
  {"id": 0, "name": " Name_0"},
  {"id": 0, "name": " Name_1"},
  {"id": 0, "name": " Name_3"},
  {"id": 0, "name": " Name_0"},
  {"id": 1, "name": " Name_1"},
  {"id": 1, "name": " Name_1"},
  {"id": 2, "name": " Name_2"},
  {"id": 2, "name": " Name_2"},
  {"id": 3, "name": " Name_3"},
  {"id": 3, "name": " Name_2"},
  {"id": 3, "name": " Name_3"},
  {"id": 4, "name": " Name_4"},
  {"id": 4, "name": " Name_4"},
  {"id": 5, "name": " Name_5"},
  {"id": 5, "name": " Name_5"},
  {"id": 6, "name": " Name_6"},
  {"id": 6, "name": " Name_5"},
  {"id": 6, "name": " Name_6"},
  {"id": 7, "name": " Name_7"},
  {"id": 7, "name": " Name_4"},
  {"id": 7, "name": " Name_7"},
  {"id": 8, "name": " Name_8"},
  {"id": 8, "name": " Name_8"},
  {"id": 9, "name": " Name_9"},
  {"id": 9, "name": " Name_8"},
  {"id": 9, "name": " Name_9"},
  {"id": 10, "name": " Name_10"},
  {"id": 10, "name": " Name_10"},
  {"id": 11, "name": " Name_11"},
  {"id": 11, "name": " Name_11"},
  {"id": 12, "name": " Name_12"},
  {"id": 12, "name": " Name_11"},
  {"id": 12, "name": " Name_12"},
  {"id": 13, "name": " Name_13"},
  {"id": 13, "name": " Name_13"},
  {"id": 14, "name": " Name_14"},
  {"id": 14, "name": " Name_11"},
  {"id": 14, "name": " Name_14"},
  {"id": 15, "name": " Name_15"},
  {"id": 15, "name": " Name_14"},
  {"id": 15, "name": " Name_15"},
  {"id": 16, "name": " Name_16"},
  {"id": 16, "name": " Name_16"},
  {"id": 17, "name": " Name_17"},
  {"id": 17, "name": " Name_17"},
  {"id": 18, "name": " Name_18"},
  {"id": 18, "name": " Name_17"},
  {"id": 18, "name": " Name_18"},
  {"id": 19, "name": " Name_19"},
  {"id": 19, "name": " Name_19"},
  {"id": 20, "name": " Name_20"},
  {"id": 20, "name": " Name_20"},
  {"id": 21, "name": " Name_21"},
  {"id": 21, "name": " Name_20"},
  {"id": 21, "name": " Name_18"},
  {"id": 21, "name": " Name_21"},
  {"id": 22, "name": " Name_22"},
  {"id": 22, "name": " Name_22"},
  {"id": 23, "name": " Name_23"},
  {"id": 23, "name": " Name_23"},
  {"id": 24, "name": " Name_24"},
  {"id": 24, "name": " Name_23"},
  {"id": 24, "name": " Name_24"},
  {"id": 25, "name": " Name_25"},
  {"id": 25, "name": " Name_25"},
  {"id": 26, "name": " Name_26"},
  {"id": 26, "name": " Name_26"},
  {"id": 27, "name": " Name_27"},
  {"id": 27, "name": " Name_26"},
  {"id": 27, "name": " Name_27"},
  {"id": 28, "name": " Name_28"},
  {"id": 28, "name": " Name_25"},
  {"id": 28, "name": " Name_28"},
  {"id": 29, "name": " Name_29"},
  {"id": 29, "name": " Name_29"},
  {"id": 30, "name": " Name_30"},
  {"id": 30, "name": " Name_29"},
  {"id": 30, "name": " Name_30"},
  {"id": 31, "name": " Name_31"},
  {"id": 31, "name": " Name_31"},
  {"id": 32, "name": " Name_32"},
  {"id": 32, "name": " Name_32"},
  {"id": 33, "name": " Name_33"},
  {"id": 33, "name": " Name_32"},
  {"id": 33, "name": " Name_33"},
  {"id": 34, "name": " Name_34"},
  {"id": 34, "name": " Name_34"},
  {"id": 35, "name": " Name_35"},
  {"id": 35, "name": " Name_32"},
  {"id": 35, "name": " Name_35"},
  {"id": 36, "name": " Name_36"},
  {"id": 36, "name": " Name_35"},
  {"id": 36, "name": " Name_36"},
  {"id": 37, "name": " Name_37"},
  {"id": 37, "name": " Name_37"},
  {"id": 38, "name": " Name_38"},
  {"id": 38, "name": " Name_38"},
  {"id": 39, "name": " Name_39"},
  {"id": 39, "name": " Name_38"},
  {"id": 39, "name": " Name_39"},
  {"id": 40, "name": " Name_40"},
  {"id": 40, "name": " Name_40"},
  {"id": 41, "name": " Name_41"},
  {"id": 41, "name": " Name_41"},
  {"id": 42, "name": " Name_42"},
  {"id": 42, "name": " Name_41"},
  {"id": 42, "name": " Name_39"},
  {"id": 42, "name": " Name_42"},
  {"id": 43, "name": " Name_43"},
  {"id": 43, "name": " Name_43"},
  {"id": 44, "name": " Name_44"},
  {"id": 44, "name": " Name_44"},
  {"id": 45, "name": " Name_45"},
  {"id": 45, "name": " Name_44"},
  {"id": 45, "name": " Name_45"},
  {"id": 46, "name": " Name_46"},
  {"id": 46, "name": " Name_46"},
  {"id": 47, "name": " Name_47"},
  {"id": 47, "name": " Name_47"},
  {"id": 48, "name": " Name_48"},
  {"id": 48, "name": " Name_47"},
  {"id": 48, "name": " Name_48"},
  {"id": 49, "name": " Name_49"},
  {"id": 49, "name": " Name_46"},
  {"id": 49, "name": " Name_49"},
  {"id": 50, "name": " Name_50"},
  {"id": 50, "name": " Name_50"},
  {"id": 51, "name": " Name_51"},
  {"id": 51, "name": " Name_50"},
  {"id": 51, "name": " Name_51"},
  {"id": 52, "name": " Name_52"},
  {"id": 52, "name": " Name_52"},
  {"id": 53, "name": " Name_53"},
  {"id": 53, "name": " Name_53"},
  {"id": 54, "name": " Name_54"},
  {"id": 54, "name": " Name_53"},
  {"id": 54, "name": " Name_54"},
  {"id": 55, "name": " Name_55"},
  {"id": 55, "name": " Name_55"},
  {"id": 56, "name": " Name_56"},
  {"id": 56, "name": " Name_53"},
  {"id": 56, "name": " Name_56"},
  {"id": 57, "name": " Name_57"},
  {"id": 57, "name": " Name_56"},
  {"id": 57, "name": " Name_57"},
  {"id": 58, "name": " Name_58"},
  {"id": 58, "name": " Name_58"},
  {"id": 59, "name": " Name_59"},
  {"id": 59, "name": " Name_59"},
  {"id": 60, "name": " Name_60"},
  {"id": 60, "name": " Name_59"},
  {"id": 60, "name": " Name_60"},
  {"id": 61, "name": " Name_61"},
  {"id": 61, "name": " Name_61"},
  {"id": 62, "name": " Name_62"},
  {"id": 62, "name": " Name_62"},
  {"id": 63, "name": " Name_63"},
  {"id": 63, "name": " Name_62"},
  {"id": 63, "name": " Name_60"},
  {"id": 63, "name": " Name_63"},
  {"id": 64, "name": " Name_64"},
  {"id": 64, "name": " Name_64"},
  {"id": 65, "name": " Name_65"},
  {"id": 65, "name": " Name_65"},
  {"id": 66, "name": " Name_66"},
  {"id": 66, "name": " Name_65"},
  {"id": 66, "name": " Name_66"},
  {"id": 67, "name": " Name_67"},
  {"id": 67, "name": " Name_67"},
  {"id": 68, "name": " Name_68"},
  {"id": 68, "name": " Name_68"},
  {"id": 69, "name": " Name_69"},
  {"id": 69, "name": " Name_68"},
  {"id": 69, "name": " Name_69"},
  {"id": 70, "name": " Name_70"},
  {"id": 70, "name": " Name_67"},
  {"id": 70, "name": " Name_70"},
  {"id": 71, "name": " Name_71"},
  {"id": 71, "name": " Name_71"},
  {"id": 72, "name": " Name_72"},
  {"id": 72, "name": " Name_71"},
  {"id": 72, "name": " Name_72"},
  {"id": 73, "name": " Name_73"},
  {"id": 73, "name": " Name_73"},
  {"id": 74, "name": " Name_74"},
  {"id": 74, "name": " Name_74"},
  {"id": 75, "name": " Name_75"},
  {"id": 75, "name": " Name_74"},
  {"id": 75, "name": " Name_75"},
  {"id": 76, "name": " Name_76"},
  {"id": 76, "name": " Name_76"},
  {"id": 77, "name": " Name_77"},
  {"id": 77, "name": " Name_74"},
  {"id": 77, "name": " Name_77"},
  {"id": 78, "name": " Name_78"},
  {"id": 78, "name": " Name_77"},
  {"id": 78, "name": " Name_78"},
  {"id": 79, "name": " Name_79"},
  {"id": 79, "name": " Name_79"},
  {"id": 80, "name": " Name_80"},
  {"id": 80, "name": " Name_80"},
  {"id": 81, "name": " Name_81"},
  {"id": 81, "name": " Name_80"},
  {"id": 81, "name": " Name_81"},
  {"id": 82, "name": " Name_82"},
  {"id": 82, "name": " Name_82"},
  {"id": 83, "name": " Name_83"},
  {"id": 83, "name": " Name_83"},
  {"id": 84, "name": " Name_84"},
  {"id": 84, "name": " Name_83"},
  {"id": 84, "name": " Name_81"},
  {"id": 84, "name": " Name_84"},
  {"id": 85, "name": " Name_85"},
  {"id": 85, "name": " Name_85"},
  {"id": 86, "name": " Name_86"},
  {"id": 86, "name": " Name_86"},
  {"id": 87, "name": " Name_87"},
  {"id": 87, "name": " Name_86"},
  {"id": 87, "name": " Name_87"},
  {"id": 88, "name": " Name_88"},
  {"id": 88, "name": " Name_88"},
  {"id": 89, "name": " Name_89"},
  {"id": 89, "name": " Name_89"},
  {"id": 90, "name": " Name_90"},
  {"id": 90, "name": " Name_89"},
  {"id": 90, "name": " Name_90"},
  {"id": 91, "name": " Name_91"},
  {"id": 91, "name": " Name_88"},
  {"id": 91, "name": " Name_91"},
  {"id": 92, "name": " Name_92"},
  {"id": 92, "name": " Name_92"},
  {"id": 93, "name": " Name_93"},
  {"id": 93, "name": " Name_92"},
  {"id": 93, "name": " Name_93"},
  {"id": 94, "name": " Name_94"},
  {"id": 94, "name": " Name_94"},
  {"id": 95, "name": " Name_95"},
  {"id": 95, "name": " Name_95"},
  {"id": 96, "name": " Name_96"},
  {"id": 96, "name": " Name_95"},
  {"id": 96, "name": " Name_96"},
  {"id": 97, "name": " Name_97"},
  {"id": 97, "name": " Name_97"},
  {"id": 98, "name": " Name_98"},
  {"id": 98, "name": " Name_95"},
  {"id": 98, "name": " Name_98"},
  {"id": 99, "name": " Name_99"},
  {"id": 99, "name": " Name_98"},
  {"id": 99, "name": " Name_99"},
  {"id": 100, "name": " Name_100"},
  {"id": 100, "name": " Name_100"}
];

test() {
// duplicates.unique();
  print(duplicates.unique((x)=>x['name']));
}



class Teacher {
  Teacher({
    @required this.id,
    @required this.name,
  });

  final String? id;
  final String? name;

  Teacher copyWith({
    String? id,
    String? name,
  }) =>
      Teacher(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Teacher.fromJson(String str) => Teacher.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Teacher.fromMap(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}


extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
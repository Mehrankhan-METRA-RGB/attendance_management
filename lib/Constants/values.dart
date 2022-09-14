import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


// Define a reusable function
String generateRandomString(int length) {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}

List<String> extractEmailsFromString(String string) {
  final emailPattern = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
      caseSensitive: false, multiLine: true);
  final matches = emailPattern.allMatches(string);
  final List<String> emails = [];
  if (matches.isNotEmpty) {
    for (final Match match in matches) {
      emails.add(string.substring(match.start, match.end));
    }
  }

  return emails;
}



class Default{
 // static List<ReferenceM/odel> referencesList = [];
 // static  List<String> rolesList = [];
 // static List<CourseModel>/ coursesList = [];
 // static List<OfficeModel> officeList = [];

 ///Current Dashboard credentials
 static String currentOffice='defaultOffice';
 static  String currentAdminRole='defaultRole';
 // static AdminModel currentAdminValues=AdminModel(id:'eiourtyre',name: 'defaultAdmin', userName: 'defaultUsername', phone: '0000000', role: 'defaultRole', office: 'defaultOffice', pass: '0;;8u08');

 ///initial Date: from when we are showing the dashboard data
 static String startDate=DateTime.now().subtract(const Duration(days: 365)).toString();
 ///end Date: Until when we are showing the dashboard data
 static String endDate=DateTime.now().toString();

  ///Server Storage Directories

 static String passportDirectory='passportPhotos';
 static String cnicDirectory='cnicPhotos';
}



class ByteData{

  static Uint8List? logo;
  static Uint8List? banner;

}



String getRandomString(int length) {
  const characters =
      '1234567890abcdefghijklmnopqrstuvwxyz1234567890';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
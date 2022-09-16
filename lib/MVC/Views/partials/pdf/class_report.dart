import 'package:attendance_managemnt_system/Constants/packages/choice/choice_selector.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/date_controller.dart';
import 'package:attendance_managemnt_system/MVC/Controllers/pdf_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../Models/student_model.dart';
import '../../../Models/teacher_model.dart';
import 'package:flutter/material.dart' as mt;

class ClassReport {
  ClassReport._private();
  static final ClassReport instance = ClassReport._private();

  widget({
    required Class classPrefs,
    required Teacher teacherPrefs,
    required List<Student> data,
  }) async {
    final pdf = Document(
      author: teacherPrefs.name,
    );

    pdf.addPage(MultiPage(
        orientation: PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        theme: ThemeData.withFont(
            base: await PdfGoogleFonts.varelaRoundRegular(),
            bold: await PdfGoogleFonts.varelaRoundRegular(),
            icons: await PdfGoogleFonts.materialIcons(),
            fontFallback: [
              await PdfGoogleFonts.varelaRoundRegular(),
              await PdfGoogleFonts.materialIcons(),
              await PdfGoogleFonts.varelaRoundRegular(),
            ]),
        margin: const EdgeInsets.all(8),
        build: (Context context) {
          return [
            Container(
                height: 200,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PdfColors.blueGrey50,
                  border: Border.all(width: 0.4, color: PdfColors.black),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Class', style: Theme.of(context).header2),
                      Text(classPrefs.name!, style: Theme.of(context).header5),
                      SizedBox(height: 30),
                      Text('Department', style: Theme.of(context).header2),
                      Text(classPrefs.department!,
                          style: Theme.of(context).header5),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('From: ${DateNotifier().minDate.value}',
                                style: Theme.of(context).tableCell),
                            Text('To: ${DateNotifier().maxDate.value}',
                                style: Theme.of(context).tableCell),
                          ]),
                      SizedBox(height: 20),
                      Text('Generated Date', style: Theme.of(context).header2),
                      Text('${DateTime.now().toLocal()}',
                          style: Theme.of(context).tableCell),
                    ])),
            Container(
                height: 40,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: PdfColors.blueGrey50,
                  border: Border.all(width: 0.4, color: PdfColors.black),
                ),
                child: Row(children: [
                  Expanded(
                      child: Text('No', style: Theme.of(context).tableHeader)),
                  Expanded(
                      child:
                          Text('Name', style: Theme.of(context).tableHeader)),
                  Expanded(
                      child:
                          Text('RollNo', style: Theme.of(context).tableHeader)),
                  Expanded(
                      child: Text('Attendance',
                          style: Theme.of(context).tableHeader)),
                  Expanded(child: Container()),
                ])),
            SizedBox(height: 4),
            for (var i = 0; i < data.length; i++)
              Container(
                  height: 35,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: PdfColors.blueGrey50,
                    border: Border.all(width: 0.4, color: PdfColors.black),
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Text('${i + 1}',
                            style: Theme.of(context).tableCell)),
                    Expanded(
                        child: Text(data[i].name!,
                            style: Theme.of(context).tableCell)),
                    Expanded(
                        child: Text(data[i].rollNo!,
                            style: Theme.of(context).tableCell)),
                    Expanded(
                        child: Text('${data[i].percentage.ceilToDouble()}',
                            style: Theme.of(context).tableCell)),
                    Expanded(
                        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color:data[i].percentage > 79
                  ? PdfColors.green
                  : data[i].percentage > 69
                  ? PdfColors.orange
                  : PdfColors.red,borderRadius: BorderRadius.circular(3) ),


            )
          ])),
                  ])),
          ]; // Center
        }));
    await PdfController.instance
        .savePDF(await pdf.save(), classPrefs.name); // Page
  }
}

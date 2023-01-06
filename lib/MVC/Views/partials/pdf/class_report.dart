import 'package:attendance_managemnt_system/MVC/Controllers/pdf_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../../Models/student_model.dart';
import '../../../Models/teacher_model.dart';

class ClassReport {
  ClassReport._private();
  static final ClassReport instance = ClassReport._private();

  widget(
      {required Class classPrefs,
      required Teacher teacherPrefs,
      required List<ReportModel> data,
      required String minDate,
      required String maxDate}) async {
    // data.sort((a, b) => a.id!.compareTo(b.id!));
    final pdf = Document(
      author: teacherPrefs.name,
    );

    pdf.addPage(MultiPage(
        orientation: PageOrientation.portrait,
        pageFormat: PdfPageFormat.a3,
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
                            Text(
                                'From: ${minDate.replaceAll('00:00:00.000', '')}',
                                style: Theme.of(context).tableCell),
                            Text(
                                'To: ${maxDate.replaceAll('00:00:00.000', '')}',
                                style: Theme.of(context).tableCell),
                          ]),
                      SizedBox(height: 20),
                      Text('Generated Date', style: Theme.of(context).header2),
                      Text('${DateTime.now().toLocal()}',
                          style: Theme.of(context).tableCell),
                    ])),
            Container(
                height: 35,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: PdfColors.blueGrey50,
                  border: Border.all(width: 0.4, color: PdfColors.black),
                ),
                child: Row(children: [
                  SizedBox(
                      width: 20,
                      child: Text('RollNo',
                          style: Theme.of(context)
                              .tableHeader
                              .copyWith(fontSize: 6))),
                  SizedBox(
                      width: 20,
                      child: Text('Name',
                          maxLines: 2,
                          style: Theme.of(context)
                              .tableHeader
                              .copyWith(fontSize: 6))),
                  for (DateTime dat = DateTime.parse(minDate);
                      dat.isBefore(DateTime.parse(maxDate));
                      dat = dat.add(const Duration(seconds: 24 * 60 * 60)))
                    Expanded(
                        child: Text('${dat.day}/${dat.month}',
                            style: Theme.of(context)
                                .tableHeader
                                .copyWith(fontSize: 4))),
                  SizedBox(
                      width: 20,
                      child: Text('%age',
                          style: Theme.of(context)
                              .tableHeader
                              .copyWith(fontSize: 5))),
                ])),
            SizedBox(height: 4),
            for (ReportModel report in data)
              Container(
                  // height: 35,
                  padding: const EdgeInsets.all(0),
                  // decoration: BoxDecoration(
                  //   color: PdfColors.blueGrey50,
                  //   border: Border.all(width: 0.4, color: PdfColors.black),
                  // ),
                  child: Row(children: [
                    Expanded(
                        child: Text(report.id!,
                            style: Theme.of(context)
                                .tableCell
                                .copyWith(fontSize: 5))),
                    SizedBox(
                        width: 20,
                        child: Text(report.name!,
                            style: Theme.of(context)
                                .tableCell
                                .copyWith(fontSize: 5))),
                    for (DateTime dot = DateTime.parse(minDate);
                        dot.isBefore(DateTime.parse(maxDate));
                        dot = dot.add(const Duration(days: 1)))
                      atdFun(context, dot, report),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: PdfColors.black, width: 0.5)),
                          child: Text(report.percentage!.toStringAsFixed(1),
                              style: Theme.of(context)
                                  .tableCell
                                  .copyWith(fontSize: 6))),
                    )
                  ])),
          ]; // Center
        }));
    await PdfController.instance
        .savePDF(await pdf.save(), classPrefs.name); // Page
  }

  atdFun(Context context, DateTime dt, ReportModel report) {
    Attendance? atd;
    for (Attendance at in report.attendance!) {
      if (at.date!.contains('${dt.year}-${dt.month}-${dt.day}')) {
        print(at.toMap());
        atd = at;
      }
    }

    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
                border: Border.all(color: PdfColors.black, width: 0.5)),
            child: Text(
                atd?.status != null ? atd!.status!.split('').first : ' ~ ',
                style: Theme.of(context).tableCell.copyWith(fontSize: 6))));
  }
}

// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import '../../../widgets/widgets.dart';
// // import 'package:oms/constants/widgets/widgets.dart';
// // import 'package:oms/mvc/model/form_model.dart';
//
// class AppTile extends StatelessWidget {
//   AppTile(
//       {required this.data,
//       required this.titles,
//       this.index,
//       this.onEdit,
//       this.onRemove,
//       this.trailing,
//         this.leading,
//       this.isTrailingMenu = true,
//       Key? key})
//       : super(key: key);
//   final int? index;
//   final bool isTrailingMenu;
//   final Widget? trailing;
//   final Widget? leading;
//   final List<Titles> titles;
//   final FormModel data;
//   final void Function()? onEdit;
//   final void Function()? onRemove;
//
//   final Random random = Random();
//
//   double? width;
//   // Key _key=GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     // if (kDebugMode) {
//     //   print(MediaQuery.of(context).size.width);
//     // }
//     return Container(
//       decoration: BoxDecoration(
//           color: index! % 2 == 0
//               ? Colors.black.withOpacity(0.02)
//               : Colors.black54.withOpacity(0.0),
//           border: const Border(
//             top: BorderSide(width: 0.3, color: Colors.black87),
//             bottom: BorderSide(width: 0.3, color: Colors.black87),
//           )),
//       child: ExpansionTile(
//         // key: _key,
//
//         tilePadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//         childrenPadding:
//             const EdgeInsets.only(top: 20, left: 30, bottom: 15, right: 15),
//         leading:leading?? Text(
//           '${data.regDate!.substring(0, 10).replaceAll('-', '/')}\n${data.regDate!.substring(11, data.regDate!.length - 4)}'
//               .toString(),
//           style: _leadingStyle(),
//         ),
//         title: _titleTile(titles: titles, formModel: data),
//         trailing: isTrailingMenu ? _menu() : trailing,
//         children: _contents(data: data, titles: titles)!,
//       ),
//     );
//   }
//
//   TextStyle _leadingStyle({double size = 9, Color color = Colors.black54}) {
//     return TextStyle(
//       fontSize: size,
//       color: color,
//     );
//   }
//
//   _menu() {
//     TextStyle _style() => _leadingStyle(size: 12);
//     return App.instance.menu(
//         items: [
//           PopupMenuItem(
//             child: Text(
//               "Edit",
//               style: _style(),
//             ),
//             onTap: onEdit,
//             value: 1,
//           ),
//           PopupMenuItem(
//             child: Text(
//               "Remove",
//               style: _style(),
//             ),
//             onTap: onRemove,
//             value: 2,
//           ),
//           PopupMenuItem(
//             child: Text(
//               "Details",
//               style: _style(),
//             ),
//             value: 3,
//           ),
//         ],
//         onSelected: (a) {
//           if (kDebugMode) {
//             print(a);
//           }
//         });
//   }
//
//   TextStyle _tileStyle({double size = 13, Color color = Colors.black87}) {
//     return TextStyle(
//       fontSize: size,
//       color: color,
//     );
//   }
//
//   ///function that shows Text values on title bar
//
//   Widget _titleTile(
//       {required FormModel formModel, required List<Titles> titles}) {
//     int totalNumbersToShow;
//     Map<String, dynamic> map = formModel.toMap();
//
//     if (isLargeSize) {
//       totalNumbersToShow = 4;
//     } else if (isMediumSize) {
//       totalNumbersToShow = 3;
//     } else if (isSmallerSize) {
//       totalNumbersToShow = 2;
//     } else {
//       totalNumbersToShow = 1;
//     }
//     return Row(
//       children: [
//         for (var i = 0; i < totalNumbersToShow; i++)
//           Expanded(
//               flex: 22,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                     titles[i] != Titles.received
//                         ? map[titles[i].name].toString()
//                         : map[titles[i].name]
//                             .fold(0, (sum, element) => sum + element)
//                             .toString(),
//                     style: _tileStyle()),
//               ))
//       ],
//     );
//   }
//
//   List<Widget>? _contents({FormModel? data, List<Titles>? titles}) {
//     var start = 0;
//     List<String> locTitles = [];
//
//     // print('localTitles:$locTitles');
//     if (isLargeSize) {
//       start = 4;
//     } else if (isMediumSize) {
//       start = 3;
//     } else if (isSmallerSize) {
//       start = 2;
//     } else {
//       start = 1;
//     }
//     for (var i = start; i < titles!.length; i++) {
//       locTitles.add(titles[i].name);
//     }
//
//     List<Widget>? _val() {
//       Map<String, dynamic>? map = data?.toMap();
//       List<Widget>? widgets = [];
//       for (var key in map!.keys) {
//         // print('key:$key=${locTitles.contains(key)}');
//         // print(key);
//
//         if (locTitles.contains(key)) {
//           widgets.add(_text(
//               value: key == Titles.regDate.name
//                   ?
//
//                   ///show formatted date if regDate title is available
//                   map[key]
//                       .toString()
//                       .substring(0, map[key].toString().length - 4)
//                   : key == Titles.received.name
//                       ?
//
//                       ///will sum  list of received payments
//
//                       map[key]
//                           .fold(0, (sum, element) => sum + element)
//                           .toString()
//                       : map[key].toString(),
//               key: key));
//         }
//       }
//       return widgets;
//     }
//
//     return _val();
//   }
//
//   Widget _text({String? value, required String key}) {
//     String? _textHeading(value) {
//       String? returnValue;
//       List<String> list = [
//         'Number',
//         'Reference',
//         'Course',
//         'FatherName',
//         'Name',
//         'Email',
//         'CNIC',
//         'DOB',
//         'Bid',
//         'Received',
//         'RegDate',
//         'Total'
//       ];
//       for (var element in list) {
//         if (element.toLowerCase().contains(key.toLowerCase())) {
//           returnValue = element;
//           // print('heading:$element');
//
//         }
//       }
//       return returnValue;
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _textHeading(value) ?? 'Heading',
//           style: _tileStyle(size: 12),
//         ),
//         Text(
//           '$value',
//           style:
//               _leadingStyle(size: 10, color: Colors.black87.withOpacity(0.66)),
//         ),
//         const Divider(),
//       ],
//     );
//   }
//
//   bool get isLargeSize => width! > 1176.00 ? true : false;
//   bool get isMediumSize => width! > 850.0 ? true : false;
//   bool get isSmallerSize => width! > 640.0 ? true : false;
// // bool get isSmallestSize => width! > 480.0 ? true : false;
//
// }
//
// enum Titles {
//   name,
//   fatherName,
//   num,
//   reference,
//   course,
//   email,
//   cnic,
//   photoUrl,
//   cnicCopyUrl,
//   dob,
//   total,
//   received,
//   regDate,
//   bid,
// }

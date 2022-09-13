// import 'package:flutter/material.dart';
// import 'package:smart_select/smart_select.dart';
// /// ignore: import_of_legacy_library_into_null_safe
// // import 'package:smart_select/smart_select.dart';
//
// class Choice extends StatelessWidget {
//  const Choice(
//       {required this.values,
//       required this.titles,
//       this.controller,
//       this.heading = 'HEADING',
//       this.paddingVert = 20,
//       this.placeholder = 'SELECT',
//       Key? key})
//       : super(key: key);
//   final List<String>? values;
//   final List<String>? titles;
//   final String? heading;
//   final String? placeholder;
//   final double? paddingVert;
// /// Declare controller globally
//   ///
//   /// EXAMPLE: final ChoiceController _controller = Get.put(ChoiceController());
//  final dynamic controller;
//   @override
//   Widget build(BuildContext context) {
//     if (values!.length != titles!.length) {
//       throw "The length of values and titles must be same";
//     }
//
//     List<S2Choice<String>> options = [
//       for (var i = 0; i < values!.length; i++)
//         S2Choice<String>(value: values![i], title: titles?[i]),
//     ];
//
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: paddingVert!),
//       child: SmartSelect<String>.single(
//           placeholder: placeholder,
//           title: heading,
//           value: controller?.choiceData.value ?? 'not selected',
//           choiceItems: options,
//           onChange: (state) {
//             controller?.val(state.value);
//           },
//           modalValidation: (val) {
//             if (val.isEmpty) {
//               return "Please $heading";
//             } else {
//               return null;
//             }
//           }),
//     );
//   }
//
//   dropDown(
//       {required List<String>? values,
//       required List<String>? titles,
//       String heading = "title",
//       String placeholder = 'select',
//       double? paddingVert = 25,
//       dynamic controller}) {
//     // simple usage
//     if (values!.length != titles!.length) {
//       throw "The length of values and titles must be same";
//     }
//
//     List<S2Choice<String>> options = [
//       for (var i = 0; i < values.length; i++)
//         S2Choice<String>(value: values[i], title: titles[i]),
//     ];
//
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: paddingVert!),
//       child: SmartSelect<String>.single(
//           placeholder: placeholder,
//           title: heading,
//           value: controller?.choiceData.value ?? 'not selected',
//           choiceItems: options,
//           onChange: (state) {
//             controller.val(state.value);
//           },
//           modalValidation: (val) {
//             if (val.isEmpty) {
//               return "Please $heading";
//             } else {
//               return null;
//             }
//           }),
//     );
//   }
// }

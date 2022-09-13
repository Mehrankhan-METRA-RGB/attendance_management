import 'package:flutter/material.dart';

import '../../Controllers/student_controller.dart';

class SelectorButton extends StatelessWidget {
  SelectorButton(
      {required this.color,
      required this.onAbsent,
      required this.onLeave,
      required this.onPresent,
      Key? key})
      : super(key: key);
  final void Function() onPresent;
  final void Function() onLeave;
  final void Function() onAbsent;
  final Color color;
  StudentNotifier studentNotifier = StudentNotifier();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // studentNotifier.presentColorChangeTo(
            //     StudentNotifier.defaultDecoration()
            //         .copyWith(color: Colors.green.shade500));
            onPresent();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            margin: const EdgeInsets.all(1.5),
            alignment: Alignment.center,
            decoration: defaultDecoration()
                .copyWith(color: color == Colors.green ? color : Colors.white.withOpacity(0.5)),
            child:  Text(
              'Present',
              style: TextStyle(color:  color == Colors.green
                  ? Colors.white
                  : const Color(0xa9918f8f), fontSize: 14),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // studentNotifier.leaveColorChangeTo(
            //     StudentNotifier.defaultDecoration()
            //         .copyWith(color: Colors.orange.shade500));

            onLeave();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            margin: const EdgeInsets.all(1.5),
            alignment: Alignment.center,
            decoration: defaultDecoration()
                .copyWith(color: color == Colors.orange ? color : Colors.white.withOpacity(0.5)),
            child:  Text(
              'Leave',
              style: TextStyle(color:  color == Colors.orange
                  ? Colors.white
                  : const Color(0xa9918f8f), fontSize: 14),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // studentNotifier.absentColorChangeTo(
            //     StudentNotifier.defaultDecoration()
            //         .copyWith(color: Colors.red.shade500));

            onAbsent();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            margin: const EdgeInsets.all(1.5),
            alignment: Alignment.center,
            decoration: defaultDecoration()
                .copyWith(color: color == Colors.red ? color : Colors.white.withOpacity(0.5)),
            child: Text(
              'Absent',
              style: TextStyle(
                  color: color == Colors.red
                      ? Colors.white
                      : const Color(0xa9918f8f),
                  fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration defaultDecoration() => BoxDecoration(
      color: const Color(0xffffffff),
      boxShadow: const [
        BoxShadow(
            offset: Offset(0.5, 0.5),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            color: Color(0x353d3d3d))
      ],
      borderRadius: BorderRadius.circular(5));
}

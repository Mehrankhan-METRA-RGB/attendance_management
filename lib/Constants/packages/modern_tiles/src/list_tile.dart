import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  const AppListTile(
      {this.onTap,
      required this.index,
      required this.subTitle,
      required this.title,
       this.trailing,
      Key? key})
      : super(key: key);
  final int index;
  final Widget title;
  final Widget subTitle;
  final Widget? trailing;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: index % 2 == 0
              ? Colors.black.withOpacity(0.02)
              : Colors.black54.withOpacity(0.0),
          border: const Border(
            top: BorderSide(width: 0.3, color: Colors.black87),
            bottom: BorderSide(width: 0.3, color: Colors.black87),
          )),
      child: ListTile(
          leading: Text(
            (index + 1).toString(),
            style: _leadingStyle(),
          ),
          title: title,
          subtitle: subTitle,
          trailing: trailing,
          onTap: onTap),
    );
  }

  TextStyle _leadingStyle({double size = 10, Color color = Colors.black54}) {
    return TextStyle(
      fontSize: size,
      color: color,
    );
  }
}

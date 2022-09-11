import 'package:attendance_managemnt_system/MVC/Views/partials/selector_button.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile(
      {this.title,
      required this.img,
      this.subTitle,
        this.color,
    required  this.onAbsent,
    required  this.onLeave,
     required this.onPresent,
      this.onTap,
      this.onLongPress,
      Key? key})
      : super(key: key);
  final void Function() onPresent;
  final void Function() onLeave;
  final void Function() onAbsent;
  final String? title;
  final String img;
  final String? subTitle;
  final Color? color;
  final void Function()? onTap;
  final void Function()? onLongPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        decoration:  BoxDecoration(
            color: (color??Colors.white).withOpacity(0.4),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 2,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.outer)
            ]),
        child: Row(
          children: [
            ClipOval(
              child: img.isNotEmpty
                  ? Image.network(
                      img,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    )
                  : const Image(
                      image: AssetImage('assets/icons/profile.png'),
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
            ),
            Expanded(
              child: ListTile(
                title: Text(subTitle ?? 'Mehran Khan'),
                subtitle: Text(title ?? '999999'),
                contentPadding: const EdgeInsets.only(
                    top: 2, bottom: 2, left: 20, right: 5),
              ),
            ),
            SizedBox(
                width: 90,
                height: 90,
                child: SelectorButton(
                  color:color??Colors.white,
                  onPresent: onPresent,
                  onLeave: onLeave,
                  onAbsent: onAbsent,
                ))
          ],
        ),
      ),
    );
  }
}

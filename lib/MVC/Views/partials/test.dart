import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          color: Color(0xffeaeaea)),
      child: Row(
        children: [
          _botton(isBadgeEnable: true, onPressed: () {}),
          _botton(icon: Icons.search, onPressed: () {}),
          _botton(icon: Icons.camera, onPressed: () {}),
          _botton(onPressed: () {}),
          _avatar()
        ],
      ),
    );
  }

  _avatar({ImageProvider? img, bool isBadgeEnable = true}) => Expanded(
      child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(foregroundImage: img),
              isBadgeEnable ? _badge() : Container()
            ],
          )));
  _botton(
      {required void Function() onPressed,
      double size = 40,
      IconData icon = Icons.home_outlined,
      bool isBadgeEnable = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: size,
                color: const Color(0xFF34241A),
              ),
            ),
            isBadgeEnable ? _badge() : Container()
          ],
        ),
      ),
    );
  }

  _badge({color, data}) => SizedBox(
      width: 10,
      height: 10,
      child: CircleAvatar(
        backgroundColor: color ?? Colors.red,
        child: Text(
          data ?? ' ',
          style: const TextStyle(color: Colors.white),
        ),
      ));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {this.color,
      required this.child,
      this.onPressed,
      this.hPadding = 20,
      this.vPadding = 2,
      Key? key})
      : super(key: key);
  final Widget child;
  final double hPadding;

  final double vPadding;
  final void Function()? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: CupertinoButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        onPressed: onPressed,
        color: color ?? Theme.of(context).buttonTheme.colorScheme!.primary,
      ),
    );
  }
}

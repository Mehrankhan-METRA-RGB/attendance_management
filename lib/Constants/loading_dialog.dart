import 'package:flutter/material.dart';
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: const BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 100,height: 100,
        child:Image.asset('assets/icon/loading.gif'),

      );
  }
}
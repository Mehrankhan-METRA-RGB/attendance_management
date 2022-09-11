import 'package:flutter/material.dart';

class FailureDialog extends StatelessWidget {
  const FailureDialog({this.data, Key? key}) : super(key: key);
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 100,
        height: 100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Failed..',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(
                height: 20,
              ),
              const Icon(
                Icons.warning_outlined,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                data.toString(),
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

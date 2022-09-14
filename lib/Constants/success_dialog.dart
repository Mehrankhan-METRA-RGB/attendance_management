import 'package:flutter/material.dart';
class SuccessfulDialog extends StatelessWidget {
  const SuccessfulDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: ()=>Navigator.pop(context),
      child: Container(
        decoration: const BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 100,height: 100,child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
        Text('Done Successfully',style: TextStyle(fontSize: 18,color: Colors.white70),),
        SizedBox(height: 20,),
        Icon(Icons.done_outline_rounded,color: Colors.white,size: 40,)
      ],), ),
    );
  }
}

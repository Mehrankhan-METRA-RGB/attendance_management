import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
   const AppTextField({this.controller,
    this.inputType,
    this.onChange,
     this.autoFillData=const [AutofillHints.username],
    this.expand=false,
    this.hint,
     this.margins=const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
     this.borders=Borders.outLine,
    this.isPassword=false,
    Key? key})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hint;
  final bool expand;
  final List<String>? autoFillData;
  final bool isPassword;
  final Borders? borders;
  final void Function(String)? onChange;
final EdgeInsetsGeometry? margins;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool? isPasswordVisible;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPasswordVisible = widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: widget.margins!,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200.0,
        ),
        child: TextFormField(
          obscureText: isPasswordVisible!,
          autofillHints: widget.autoFillData,
          maxLines: widget.expand ? null : 1,
          controller: widget.controller,
          // autovalidateMode: ,
          // expands:expands,
          // cursorHeight: 100,
          textAlignVertical: TextAlignVertical.top,
          keyboardType: widget.inputType,
          decoration: _inputDecoration(context),
          toolbarOptions:const ToolbarOptions(paste: true, cut: true, selectAll: true, copy: true),
          onFieldSubmitted: (value) {
            //Validator
          },

          validator: (value) {
            if (value!.isEmpty ||
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~@']+")
                    .hasMatch(value)) {
              return 'Enter a Field data';
            }
            return null;
          },

          onChanged: widget.onChange,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
suffixIcon:widget.isPassword? IconButton(
    onPressed: () {

setState(() {
  isPasswordVisible = !isPasswordVisible!;
});

    },

    icon: isPasswordVisible!  ?const Icon(Icons.visibility_off) :const Icon(Icons.visibility)
):null,
      border: _border(widget.borders),

      hintText: "Enter ${widget.hint}",
      labelText: widget.hint,
    );
  }

  _border(border){
  // var _br=Borders.outLine;
  switch(border){
    case Borders.outLine:
      return OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme
                .of(context)
                .textTheme
                .bodyMedium!
                .color!
        ),

        borderRadius: BorderRadius.circular(4.0),
      );
    case Borders.underLine:
      return UnderlineInputBorder(borderSide: BorderSide(
          color: Theme
              .of(context)
              .textTheme
              .bodyMedium!
              .color!
      ),);
  }
  }
}
enum Borders{
  outLine,
  underLine
}
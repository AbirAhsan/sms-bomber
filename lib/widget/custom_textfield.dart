import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.suffixIcon,
    this.inputFormatters,
    this.enabled = true, this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TextFormField(
        enabled: enabled,
        initialValue:initialValue ,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            gapPadding: 5.0,
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFormField extends StatefulWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
    
  });

  @override
  State<CustomFormField> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        onSaved: widget.onSaved,
        obscureText: widget.obscureText,
        validator: (value) {
          if (value != null && widget.validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Por favor, ingresa un(a) ${widget.hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

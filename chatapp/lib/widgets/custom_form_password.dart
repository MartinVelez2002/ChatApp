import 'package:flutter/material.dart';

class CustomFormFieldPassword extends StatefulWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final Function(String?) onSaved;

  const CustomFormFieldPassword({
    Key? key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    this.obscureText = true,
    required this.onSaved,
  }) : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormFieldPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              // Aquí puedes agregar validaciones adicionales si es necesario
              return null;
            },
            onChanged: widget.onSaved,
          ),
        ],
      ),
    );
  }
}

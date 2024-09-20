import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const TextFieldWidget({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.tertiary),
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
          ),
        ));
  }
}

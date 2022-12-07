import 'package:flutter/material.dart';

class CurrencyTextField extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function() onTap;

  const CurrencyTextField({
    super.key,
    required this.label,
    required this.prefix,
    required this.controller,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        label: Text(
          label,
          style: const TextStyle(color: Colors.amber),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.amber),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.amber),
        ),
        prefixText: prefix,
      ),
      keyboardType: TextInputType.number,
      cursorColor: Colors.amber,
    );
  }
}

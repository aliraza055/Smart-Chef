import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String hintText;
  final T? value;
  final String errorText;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.errorText,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      validator: (v) => v == null ? errorText : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(hintText),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString(), style: const TextStyle(fontSize: 16)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

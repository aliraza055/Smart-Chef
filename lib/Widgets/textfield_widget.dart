import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  Icon prefix;
  String hintText;
  TextfieldWidget({super.key, required this.prefix, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hint: Text(hintText), prefix: prefix),
    );
  }
}

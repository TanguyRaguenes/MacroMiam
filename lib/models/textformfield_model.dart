import 'package:flutter/material.dart';

class TextFormFieldModel {
  final String label;
  final String hintText;
  final TextInputType type;
  final FormFieldSetter<String>? onSaved;

  TextFormFieldModel({
    required this.label,
    required this.hintText,
    required this.type,
    required this.onSaved,
  });
}

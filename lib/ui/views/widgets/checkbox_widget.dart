import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String label;

  const CheckboxWidget({super.key, required this.label});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    String label = widget.label;
    Color getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Theme.of(context).colorScheme.inversePrimary;
      }
      return Theme.of(context).colorScheme.primary;
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: WidgetStateProperty.resolveWith(getColor),
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value!;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}

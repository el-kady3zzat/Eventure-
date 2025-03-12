import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericStepperField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final String? Function(String?)? validator;

  const NumericStepperField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.validator,
  });

  @override
  _NumericStepperFieldState createState() => _NumericStepperFieldState();
}

class _NumericStepperFieldState extends State<NumericStepperField> {
  void _increment() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = (currentValue + 1).toString();
  }

  void _decrement() {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    if (currentValue > 0) {
      widget.controller.text = (currentValue - 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: white,
      style: TextStyle(color: white),
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: lightWhite),
        filled: true,
        fillColor: kMainLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: grey, width: 0.2),
        ),
        prefixIcon:
            widget.icon != null ? Icon(widget.icon, color: lightWhite) : null,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_drop_up, color: lightWhite),
              onPressed: _increment,
            ),
            IconButton(
              icon: Icon(Icons.arrow_drop_down, color: lightWhite),
              onPressed: _decrement,
            ),
          ],
        ),
        errorStyle: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

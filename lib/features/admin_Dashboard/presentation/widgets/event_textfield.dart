import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEventTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool onlyDigits;

  const CustomEventTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.icon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onlyDigits = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      obscureText: obscureText,
      cursorColor: white,
      style: TextStyle(color: white),
      validator: validator,
      inputFormatters:
          onlyDigits ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: lightWhite),
        filled: true,
        fillColor: kMainLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: grey, width: 0.2),
        ),
        prefixIcon: icon != null ? Icon(icon, color: lightWhite) : null,
        suffixIcon: suffixIcon,
        errorStyle: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

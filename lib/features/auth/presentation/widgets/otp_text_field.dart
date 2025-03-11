// lib/features/auth/presentation/widgets/otp_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPTextField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const OTPTextField({
    Key? key,
    this.length = 6,
    required this.onCompleted,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(
      widget.length,
          (index) => TextEditingController(),
    );

    // Listen to the main controller changes
    widget.controller.addListener(_updateFields);
  }

  void _updateFields() {
    final text = widget.controller.text;
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].text = i < text.length ? text[i] : '';
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    // Combine all values
    String combinedValue = _controllers.map((c) => c.text).join();
    widget.onChanged(combinedValue);

    // Check if all fields are filled
    if (combinedValue.length == widget.length) {
      widget.onCompleted(combinedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
            (index) => SizedBox(
          width: 50.w,
          height: 60.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.w,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isEmpty && index > 0) {
                // Move to previous field on backspace
                _focusNodes[index - 1].requestFocus();
              }
              _onChanged(index, value);
            },
          ),
        ),
      ),
    );
  }
}
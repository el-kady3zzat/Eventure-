import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_text_field_bloc/auth_text_field_bloc.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_text_field_bloc/auth_text_field_event.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_text_field_bloc/auth_text_field_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
class AuthTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final int maxLength;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String fieldType;
  final TextEditingController? passwordController;
  final Function(String)? onChanged;
  final Widget? suffixIcon;


  const AuthTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.fieldType,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.passwordController,
    this.maxLength = 100,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  State<AuthTextField> createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  late AuthTextFieldBloc _bloc;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _bloc = AuthTextFieldBloc();

    if (widget.fieldType == 'confirmPassword' && widget.passwordController != null) {
      widget.passwordController!.addListener(_onPasswordChange);
      widget.controller.addListener(_onConfirmPasswordChange);
    }

    if (widget.fieldType == 'phone' && widget.controller.text.isEmpty) {
      widget.controller.text = '+2';
    }
  }

  @override
  void dispose() {
    if (widget.fieldType == 'confirmPassword' && widget.passwordController != null) {
      widget.passwordController!.removeListener(_onPasswordChange);
      widget.controller.removeListener(_onConfirmPasswordChange);
    }
    _bloc.close();
    super.dispose();
  }

  void _onPasswordChange() {
    if (widget.fieldType == 'confirmPassword') {
      _bloc.add(UpdatePasswordEvent(widget.passwordController!.text));
      _bloc.add(TextChangedEvent(
        text: widget.controller.text,
        fieldType: widget.fieldType,
      ));
    }
  }

  void _onConfirmPasswordChange() {
    if (widget.fieldType == 'confirmPassword') {
      _bloc.add(TextChangedEvent(
        text: widget.controller.text,
        fieldType: widget.fieldType,
      ));
    }
  }

  String _formatPhoneNumber(String value) {
    if (value.isEmpty) return '+2';

    if (!value.startsWith('+2')) {
      value = '+2${value.replaceAll('+2', '')}';
    }

    value = value.replaceAll(' ', '');

    if (value.length > 2) {
      value = value.substring(0, 2) + ' ' + value.substring(2);
    }
    if (value.length > 6) {
      value = value.substring(0, 6) + ' ' + value.substring(6);
    }
    if (value.length > 10) {
      value = value.substring(0, 10) + ' ' + value.substring(10);
    }

    return value;
  }

  bool isFieldValid() {
    if (widget.fieldType == 'confirmPassword') {
      return isValid && widget.controller.text == widget.passwordController?.text;
    }
    return isValid;
  }

  Widget _buildRequirementItem(String requirement, bool isMet) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.size(p: 1, l: 1),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              key: ValueKey<bool>(isMet),
              color: isMet ? kButton : Colors.white60,
              size: SizeConfig.size(p: 14, l: 14),
            ),
          ),
          SizedBox(width: SizeConfig.size(p: 8, l: 6)),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isMet ? kButton : Colors.white60,
                fontSize: SizeConfig.size(p: 10, l: 10),
              ),
              child: Text(requirement), // requirement is already a translation key
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultSize = SizeConfig.defaultSize!;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<AuthTextFieldBloc, AuthTextFState>(
        listenWhen: (previous, current) => previous.isValid != current.isValid,
        listener: (context, state) {
          setState(() {
            isValid = state.isValid;
          });
        },
        buildWhen: (previous, current) {
          return previous.obscureText != current.obscureText ||
              previous.showError != current.showError ||
              previous.errorMessage != current.errorMessage ||
              previous.passwordRequirements != current.passwordRequirements ||
              (previous.passwordRequirements != null &&
                  current.passwordRequirements != null &&
                  !mapEquals(previous.passwordRequirements, current.passwordRequirements));
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: kButton,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword && state.obscureText,
                maxLength: widget.fieldType == 'phone' ? 16 : null,
                textAlign: widget.fieldType == 'phone' ? TextAlign.left : TextAlign.start,
                textDirection: widget.fieldType == 'phone' ? ui.TextDirection.ltr : null,
                inputFormatters: widget.fieldType == 'phone'
                    ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]'))]
                    : null,
                onChanged: (value) {
                  if (widget.fieldType == 'phone') {
                    value = value.replaceAll('+2', '').replaceAll(' ', '');
                    if (value.length > 11) {
                      value = value.substring(0, 11);
                    }
                    if (value.isNotEmpty) {
                      value = '+2$value';
                    }
                    final formattedValue = _formatPhoneNumber(value);
                    widget.controller.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(offset: formattedValue.length),
                    );
                  }

                  _bloc.add(TextChangedEvent(
                    text: widget.controller.text,
                    fieldType: widget.fieldType,
                  ));

                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.controller.text);
                  }
                },
                onTap: () {
                  if (widget.fieldType == 'phone') {
                    if (widget.controller.text.isEmpty) {
                      widget.controller.text = '+2';
                      widget.controller.selection = TextSelection.collapsed(offset: 2);
                    }
                  }
                },
                decoration: InputDecoration(
                  alignLabelWithHint: widget.fieldType == 'phone',
                  hintTextDirection: widget.fieldType == 'phone' ? ui.TextDirection.ltr : null,
                  labelText: widget.labelText.tr(),
                  labelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: SizeConfig.size(p: defaultSize * 1.2, l: defaultSize* 1.5),
                  ),
                  hintText: widget.fieldType == 'phone'
                      ? '+2 XXX XXX XXXX'
                      : widget.hintText.tr(),
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: SizeConfig.size(p: defaultSize * 1.2, l: defaultSize* 1.2),
                  ),
                  errorText: state.showError && state.errorMessage != null
                      ? state.errorMessage!.tr()
                      : null,
                  errorStyle: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: SizeConfig.size(p: defaultSize * 1.1, l: defaultSize * 1.2),
                  ),
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: kPreIcon,
                    size: SizeConfig.size(p: defaultSize * 2, l: defaultSize * 2.5),
                  ),
                  suffixIcon: widget.suffixIcon ?? (widget.isPassword
                      ? IconButton(
                    icon: Icon(
                      state.obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: kButton,
                      size: SizeConfig.size(p: defaultSize * 2, l: defaultSize * 2.2),
                    ),
                    onPressed: () {
                      _bloc.add(const TogglePasswordVisibilityEvent());
                    },
                  )
                      : null),
                  filled: false,
                  fillColor: kMainLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.size(p: defaultSize * 1.2, l: defaultSize),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.size(p: defaultSize * 1.2, l: defaultSize),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.size(p: defaultSize * 1.2, l: defaultSize),
                    ),
                    borderSide: BorderSide(
                      color: kButton,
                      width: SizeConfig.size(p: 1, l: 0.8),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.size(p: defaultSize * 1.2, l: defaultSize),
                    ),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                      width: SizeConfig.size(p: 1, l: 0.8),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.size(p: defaultSize * 1.2, l: defaultSize),
                    ),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                      width: SizeConfig.size(p: 1, l: 0.8),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.size(p: defaultSize * 1.5, l: defaultSize * 1.2),
                    vertical: SizeConfig.size(p: defaultSize , l: defaultSize),
                  ),
                  counterText: '',
                ),

                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.size(p: defaultSize * 1.5, l: defaultSize * 1.5),
                ),
              ),
              if (widget.fieldType == 'password' &&
                  state.passwordRequirements != null &&
                  widget.controller.text.isNotEmpty &&
                  !state.passwordRequirements!.values.every((met) => met))
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.size(p: defaultSize, l: defaultSize * 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var entry in state.passwordRequirements!.entries)
                          _buildRequirementItem(
                            entry.key,
                            entry.value,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
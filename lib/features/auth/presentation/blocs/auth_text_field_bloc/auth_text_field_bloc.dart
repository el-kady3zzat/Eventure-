import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_text_field_event.dart';
import 'auth_text_field_states.dart';

class AuthTextFieldBloc extends Bloc<AuthTextFieldEvent, AuthTextFState> {
  String _password = '';
  String _confirmPassword = '';
  final Map<String, bool> _passwordRequirements = {
    'auth.validation.password.requirements.length'.tr(): false,
    'auth.validation.password.requirements.uppercase'.tr(): false,
    'auth.validation.password.requirements.lowercase'.tr(): false,
    'auth.validation.password.requirements.number'.tr(): false,
    'auth.validation.password.requirements.special'.tr(): false,
  };

  AuthTextFieldBloc() : super(const AuthTextFieldInitial()) {
    on<TextChangedEvent>(_handleTextChanged);
    on<TogglePasswordVisibilityEvent>(_handleToggleVisibility);
    on<UpdatePasswordEvent>(_handleUpdatePassword);
  }

  void _handleTextChanged(
      TextChangedEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    String? errorMessage;
    bool showError = false;
    bool isValid = true;

    if (event.text.isEmpty && event.fieldType != 'phone') {
      errorMessage = 'auth.validation.required'.tr();
      showError = true;
      isValid = false;
    } else {
      switch (event.fieldType) {
        case 'password':
          _password = event.text;
          if (event.text.isEmpty) {
            _resetPasswordRequirements();
            isValid = false;
            showError = false;
            emit(AuthTextFieldValidation(
              isValid: isValid,
              obscureText: state.obscureText,
              errorMessage: errorMessage,
              showError: showError,
              passwordRequirements: null,
            ));
          } else {
            _updatePasswordRequirements(event.text);
            isValid = _isValidPassword(event.text);
            showError = false;

            final allRequirementsMet = _passwordRequirements.values.every((met) => met);

            emit(AuthTextFieldValidation(
              isValid: isValid,
              obscureText: state.obscureText,
              errorMessage: errorMessage,
              showError: showError,
              passwordRequirements: allRequirementsMet ? null : Map<String, bool>.from(_passwordRequirements),
            ));
          }
          return;

        case 'confirmPassword':
          _confirmPassword = event.text;
          if (event.text.isNotEmpty) {
            isValid = _isValidConfirmPassword(event.text);
            if (!isValid) {
              errorMessage = _getConfirmPasswordError(event.text);
              showError = true;
            }
          } else {
            isValid = false;
            showError = false;
          }
          break;

        case 'name':
          if (!_isValidName(event.text)) {
            errorMessage = _getNameError(event.text);
            showError = true;
            isValid = false;
          }
          break;

        case 'email':
          if (!_isValidEmail(event.text)) {
            errorMessage = _getEmailError(event.text);
            showError = true;
            isValid = false;
          }
          break;

        case 'phone':
          if (event.text.isNotEmpty) {
            final cleanPhone = event.text.replaceAll(' ', '');
            if (!_isValidPhone(cleanPhone)) {
              errorMessage = _getPhoneError(cleanPhone);
              showError = true;
              isValid = false;
            } else {
              if (cleanPhone.startsWith('+')) {
                isValid = cleanPhone.length >= 12 && cleanPhone.length <= 13;
              } else {
                isValid = cleanPhone.length == 11;
              }
              showError = !isValid;
              errorMessage = showError ? _getPhoneError(cleanPhone) : null;
            }
          } else {
            isValid = true;
            showError = false;
            errorMessage = null;
          }
          break;
      }
    }

    emit(AuthTextFieldValidation(
      isValid: isValid,
      obscureText: state.obscureText,
      errorMessage: errorMessage,
      showError: showError,
      passwordRequirements: event.fieldType == 'password' ? Map<String, bool>.from(_passwordRequirements) : null,
    ));
  }

  void _handleToggleVisibility(
      TogglePasswordVisibilityEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    emit(AuthTextFieldValidation(
      isValid: state.isValid,
      obscureText: !state.obscureText,
      showError: state.showError,
      errorMessage: state.errorMessage,
      passwordRequirements: state.passwordRequirements != null
          ? Map<String, bool>.from(state.passwordRequirements!)
          : null,
    ));
  }

  void _handleUpdatePassword(
      UpdatePasswordEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    _password = event.password;
    if (_confirmPassword.isNotEmpty) {
      final isValid = _isValidConfirmPassword(_confirmPassword);
      emit(AuthTextFieldValidation(
        isValid: isValid,
        obscureText: state.obscureText,
        errorMessage: isValid ? null : _getConfirmPasswordError(_confirmPassword),
        showError: !isValid,
        passwordRequirements: state.passwordRequirements != null
            ? Map<String, bool>.from(state.passwordRequirements!)
            : null,
      ));
    }
  }

  void _updatePasswordRequirements(String value) {
    final newRequirements = <String, bool>{
      'auth.validation.password.requirements.length'.tr(): value.length >= 8,
      'auth.validation.password.requirements.uppercase'.tr(): value.contains(RegExp(r'[A-Z]')),
      'auth.validation.password.requirements.lowercase'.tr(): value.contains(RegExp(r'[a-z]')),
      'auth.validation.password.requirements.number'.tr(): value.contains(RegExp(r'[0-9]')),
      'auth.validation.password.requirements.special'.tr(): value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };

    _passwordRequirements.clear();
    _passwordRequirements.addAll(newRequirements);
  }

  void _resetPasswordRequirements() {
    _passwordRequirements.updateAll((key, value) => false);
  }

  bool _isValidName(String value) {
    return value.isNotEmpty &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) &&
        value.length >= 3 &&
        value[0].toUpperCase() == value[0];
  }

  String? _getNameError(String value) {
    if (value.isEmpty) return 'auth.validation.name.required'.tr();
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'auth.validation.name.letters_only'.tr();
    }
    if (value.length < 3) return 'auth.validation.name.min_length'.tr();
    if (value[0].toUpperCase() != value[0]) {
      return 'auth.validation.name.capitalize'.tr();
    }
    return null;
  }

  bool _isValidEmail(String value) {
    return value.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
  }

  String? _getEmailError(String value) {
    if (value.isEmpty) return 'auth.validation.email.required'.tr();
    return 'auth.validation.email.invalid'.tr();
  }

  bool _isValidPhone(String value) {
    if (value.isEmpty) return false;
    value = value.replaceAll(' ', '');
    if (!value.startsWith('+2')) return false;
    if (value.length != 13) return false;
    return RegExp(r'^\+2[0-9]{11}$').hasMatch(value);
  }

  String? _getPhoneError(String value) {
    if (value.isEmpty) return null;
    value = value.replaceAll(' ', '');
    if (!value.startsWith('+2')) {
      return 'auth.validation.phone.prefix'.tr();
    }
    if (!RegExp(r'^\+2[0-9]+$').hasMatch(value)) {
      return 'auth.validation.phone.digits_only'.tr();
    }
    String digitsAfterPrefix = value.substring(2);
    if (digitsAfterPrefix.length < 11) {
      return 'auth.validation.phone.exact_length'.tr();
    }
    if (digitsAfterPrefix.length > 11) {
      return 'auth.validation.phone.max_length'.tr();
    }
    return null;
  }

  bool _isValidPassword(String value) {
    if (value.isEmpty) return false;
    return _passwordRequirements.values.every((met) => met);
  }

  bool _isValidConfirmPassword(String value) {
    return value == _password;
  }

  String? _getConfirmPasswordError(String value) {
    return 'auth.validation.password.not_match'.tr();
  }
}
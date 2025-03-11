// lib/bloc/auth_text_field_bloc/auth_text_field_states.dart

import 'package:equatable/equatable.dart';

abstract class AuthTextFState extends Equatable {
  final bool isValid;
  final bool obscureText;
  final String? errorMessage;
  final bool showError;
  final Map<String, bool>? passwordRequirements;

  const AuthTextFState({
    this.isValid = false,
    this.obscureText = true,
    this.errorMessage,
    this.showError = false,
    this.passwordRequirements,
  });

  @override
  List<Object?> get props => [
    isValid,
    obscureText,
    errorMessage,
    showError,
    passwordRequirements,
  ];
}

class AuthTextFieldInitial extends AuthTextFState {
  const AuthTextFieldInitial() : super();
}

class AuthTextFieldValidation extends AuthTextFState {
  const AuthTextFieldValidation({
    required super.isValid,
    required super.obscureText,
    super.errorMessage,
    required super.showError,
    super.passwordRequirements,
  });

  AuthTextFieldValidation copyWith({
    bool? isValid,
    bool? obscureText,
    String? errorMessage,
    bool? showError,
    Map<String, bool>? passwordRequirements,
  }) {
    return AuthTextFieldValidation(
      isValid: isValid ?? this.isValid,
      obscureText: obscureText ?? this.obscureText,
      errorMessage: errorMessage,
      showError: showError ?? this.showError,
      passwordRequirements: passwordRequirements ?? this.passwordRequirements,
    );
  }
}

class AuthSuccess extends AuthTextFState {
  final String message;
  final bool shouldNavigate; // Add this flag

  const AuthSuccess({
    required this.message,
    this.shouldNavigate = true, // Default to true for backward compatibility
  }) : super(isValid: true);

  @override
  List<Object?> get props => [...super.props, message, shouldNavigate];
}

class AuthError extends AuthTextFState {
  final String message;

  const AuthError({
    required this.message,
  }) : super(isValid: false, showError: true);

  @override
  List<Object?> get props => [...super.props, message];
}
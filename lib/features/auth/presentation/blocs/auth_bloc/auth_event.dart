// lib/application/auth/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword, phone];
}

class SignOutRequested extends AuthEvent {}

class BiometricAuthRequested extends AuthEvent {}

class ValidateFieldsRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const ValidateFieldsRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password, confirmPassword];
}

// New events
class GoogleSignInRequested extends AuthEvent {}

class PhoneNumberSubmitted extends AuthEvent {
  final String phoneNumber;

  const PhoneNumberSubmitted({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class OTPSubmitted extends AuthEvent {
  final String otp;

  const OTPSubmitted({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}
class ValidateSignUpFields extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;

  ValidateSignUpFields({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
  });
}
class ValidateLoginFields extends AuthEvent {
  final String email;
  final String password;

  ValidateLoginFields({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}


class ResendCodeRequested extends AuthEvent {
  final String phoneNumber;

  const ResendCodeRequested({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
class CheckUserDataAvailability extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;

  CheckUserDataAvailability({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
  });
}


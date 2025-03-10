// lib/bloc/auth_text_field_bloc/auth_text_field_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthTextFieldEvent extends Equatable {
  const AuthTextFieldEvent();

  @override
  List<Object?> get props => [];
}

class TextChangedEvent extends AuthTextFieldEvent {
  final String text;
  final String fieldType;

  const TextChangedEvent({
    required this.text,
    required this.fieldType,
  });

  @override
  List<Object> get props => [text, fieldType];
}

class TogglePasswordVisibilityEvent extends AuthTextFieldEvent {
  const TogglePasswordVisibilityEvent();
}

class UpdatePasswordEvent extends AuthTextFieldEvent {
  final String password;

  const UpdatePasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}
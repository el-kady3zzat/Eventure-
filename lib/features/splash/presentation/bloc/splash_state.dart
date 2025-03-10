// lib/application/splash/splash_state.dart

import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoggedInState extends SplashState {}

class SplashLoggedOutState extends SplashState {}

class SplashNavigationState extends SplashState {
  final bool isLoggedIn;

  const SplashNavigationState(this.isLoggedIn);

  @override
  List<Object?> get props => [isLoggedIn];
}

class SplashErrorState extends SplashState {
  final String error;

  const SplashErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
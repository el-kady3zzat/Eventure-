// lib/application/splash/splash_event.dart

import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class CheckLoginStatusEvent extends SplashEvent {}

class NavigateToNextScreenEvent extends SplashEvent {}
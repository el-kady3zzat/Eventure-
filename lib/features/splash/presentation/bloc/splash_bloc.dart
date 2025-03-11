// lib/application/splash/splash_bloc.dart

import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final IAuthService _authService;

  SplashBloc({
    required IAuthService authService,
    required IUserRepository userRepository,
  })  : _authService = authService,
        super(SplashInitialState()) {
    on<CheckLoginStatusEvent>(_handleCheckLoginStatus);
    on<NavigateToNextScreenEvent>(_handleNavigateToNextScreen);
  }

  Future<void> _handleCheckLoginStatus(
    CheckLoginStatusEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());

    try {
      bool isAuthenticated = await _authService.authStateChanges.first;

      if (isAuthenticated) {
        emit(SplashLoggedInState());
      } else {
        emit(SplashLoggedOutState());
      }
    } catch (e) {
      emit(const SplashErrorState(
        error: 'Error checking login status. Please try again.',
      ));
    }
  }

  Future<void> _handleNavigateToNextScreen(
    NavigateToNextScreenEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      bool isAuthenticated = await _authService.authStateChanges.first;

      if (isAuthenticated) {
        emit(const SplashNavigationState(true));
      } else {
        emit(const SplashNavigationState(false));
      }
    } catch (e) {
      emit(const SplashErrorState(
        error: 'Error during navigation. Please try again.',
      ));
    }
  }
}

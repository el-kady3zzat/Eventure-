import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/biometric_service.dart';
import 'package:eventure/features/auth/domain/models/auth_credentials.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_states.dart';
import 'package:eventure/injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService _authService;
  final IBiometricService _biometricService;

  AuthBloc({
    required IAuthService authService,
    required IBiometricService biometricService,
  })  : _authService = authService,
        _biometricService = biometricService,
        super(AuthInitial()) {
    on<SignInRequested>(_handleSignIn);
    on<SignUpRequested>(_handleSignUp);
    on<SignOutRequested>(_handleSignOut);
    on<BiometricAuthRequested>(_handleBiometricAuth);
    on<ValidateFieldsRequested>(_handleValidateFields);
    on<ValidateSignUpFields>(_handleValidateSignUpFields);
    on<ValidateLoginFields>(_handleValidateLoginFields);
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<OTPSubmitted>(_onOTPSubmitted);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<CheckUserDataAvailability>(_handleCheckUserDataAvailability);
  }

  Future<void> _handleCheckUserDataAvailability(
      CheckUserDataAvailability event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'auth.messages.checking_availability'.tr()));

    try {
      final emailResult = await _authService.isEmailRegistered(event.email);
      if (emailResult.isSuccess && emailResult.data!) {
        emit(ValidationError('auth.messages.email_registered'.tr()));
        return;
      }

      // final nameResult = await _authService.isNameTaken(event.name);
      // if (nameResult.isSuccess && nameResult.data!) {
      //   emit(ValidationError('auth.messages.name_taken'.tr()));
      //   return;
      // }

      add(ValidateSignUpFields(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        phone: event.phone,
      ));
    } catch (e) {
      emit(ValidationError(
          'auth.messages.checking_availability_error'.tr(args: [e.toString()])));
    }
  }

  Future<void> _handleSignIn(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'auth.messages.signing_in'.tr()));

    final credentials = AuthCredentials(
      email: event.email,
      password: event.password,
    );

    final result = await _authService.signIn(credentials);

    if (result.isSuccess) {
      emit(AuthSuccess(
        user: result.data!,
        message: 'auth.messages.welcome_back'.tr(namedArgs: {'name': result.data!.name}),
      ));
    } else {
      emit(AuthError(result.error!.tr()));
    }
  }

  Future<void> _handleSignUp(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (event.password != event.confirmPassword) {
      emit(AuthError('auth.messages.passwords_not_match'.tr()));
      return;
    }

    emit(AuthLoading(message: 'auth.messages.creating_account'.tr()));

    final signUpData = SignUpData.builder()
        .setName(event.name)
        .setEmail(event.email)
        .setPassword(event.password)
        .setPhone(event.phone ?? '+2')
        .build();

    final result = await _authService.signUp(signUpData);

    if (result.isSuccess) {
      emit(AuthSuccess(
        user: result.data!,
        message: 'auth.messages.welcome_google'.tr(namedArgs: {'name': result.data!.name}),
      ));

      final String? fcmToken = await getIt<FirebaseMessaging>().getToken();
      if (fcmToken != null) {
        // Save FCM token in Firestore
        await getIt<FirebaseFirestore>()
            .collection('users')
            .doc(result.data!.id)
            .update({'fcmToken': fcmToken});
      }
      // Save Notification Settings in Firestore
      await getIt<FirebaseFirestore>()
          .collection('notification_settings')
          .doc(result.data!.id)
          .set({
        'booked_events_channel': true,
        'favorite_events_channel': true,
        'general_channel': true,
      });
    } else {
      emit(AuthError(result.error!.tr()));
    }
  }

  Future<void> _handleSignOut(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'auth.messages.signing_out'.tr()));

    final result = await _authService.signOut();

    if (result.isSuccess) {
      emit(SignOutSuccess());
    } else {
      emit(AuthError(result.error!.tr()));
    }
  }

  Future<void> _handleBiometricAuth(
      BiometricAuthRequested event,
      Emitter<AuthState> emit,
      ) async {
    final isAvailable = await _biometricService.isAvailable();
    if (!isAvailable) {
      emit(BiometricAuthError('auth.messages.biometric_not_available'.tr()));
      return;
    }

    final isAuthenticated = await _biometricService.authenticate();
    if (isAuthenticated) {
      emit(BiometricAuthSuccess());
    } else {
      emit(BiometricAuthError('auth.messages.biometric_failed'.tr()));
    }
  }

  void _handleValidateFields(
      ValidateFieldsRequested event,
      Emitter<AuthState> emit,
      ) {
    final List<String> emptyFields = [];

    if (event.name.trim().isEmpty) emptyFields.add('auth.fields.full_name'.tr());
    if (event.email.trim().isEmpty) emptyFields.add('auth.fields.email'.tr());
    if (event.password.isEmpty) emptyFields.add('auth.fields.password'.tr());
    if (event.confirmPassword.isEmpty)
      emptyFields.add('auth.fields.confirm_password'.tr());

    if (emptyFields.isNotEmpty) {
      emit(ValidationError(_getEmptyFieldsMessage(emptyFields)));
    } else {
      emit(ValidationSuccess());
    }
  }

  bool _isValidName(String value) {
    return value.isNotEmpty &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) &&
        value.length >= 3 &&
        value[0].toUpperCase() == value[0];
  }

  bool _isValidEmail(String value) {
    return value.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
  }

  bool _isValidPassword(String value) {
    if (value.isEmpty) return false;

    bool hasMinLength = value.length >= 8;
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasNumber = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar;
  }

  bool _isValidPhone(String value) {
    value = value.replaceAll(' ', '');
    if (!value.startsWith('+2')) return false;
    String digitsAfterPrefix = value.substring(2);
    if (digitsAfterPrefix.isEmpty) return true;
    if (digitsAfterPrefix.length != 11) return false;
    return RegExp(r'^\d{11}$').hasMatch(digitsAfterPrefix);
  }

  void _handleValidateSignUpFields(
      ValidateSignUpFields event,
      Emitter<AuthState> emit,
      ) {
    if (event.name.trim().isEmpty ||
        event.email.trim().isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      emit(ValidationError('auth.messages.fill_required'.tr()));
      return;
    }

    if (!_isValidName(event.name.trim())) {
      emit(ValidationError('auth.messages.invalid_name'.tr()));
      return;
    }

    if (!_isValidEmail(event.email.trim())) {
      emit(ValidationError('auth.messages.invalid_email'.tr()));
      return;
    }

    if (!_isValidPassword(event.password)) {
      emit(ValidationError('auth.messages.invalid_password'.tr()));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(ValidationError('auth.messages.passwords_not_match'.tr()));
      return;
    }

    final phone = event.phone.trim();
    if (phone.isNotEmpty && !_isValidPhone(phone)) {
      emit(ValidationError('auth.messages.invalid_phone'.tr()));
      return;
    }

    emit(ValidationSuccess());
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    if (emptyFields.length == 1) {
      return 'auth.validation.empty_field'.tr(args: [emptyFields[0]]);
    }

    String fields = emptyFields.asMap().entries.map((entry) {
      int i = entry.key;
      String field = entry.value;
      if (i == emptyFields.length - 1) {
        return 'auth.validation.and'.tr(args: [field]);
      } else if (i == emptyFields.length - 2) {
        return '$field ';
      }
      return '$field, ';
    }).join();

    return 'auth.validation.empty_fields'.tr(args: [fields]);
  }

  Future<void> _onPhoneNumberSubmitted(
      PhoneNumberSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading(message: 'auth.messages.checking_phone'.tr()));

      if (event.phoneNumber.trim().isEmpty ||
          event.phoneNumber.trim() == '+2') {
        emit(AuthError('auth.messages.enter_valid_phone'.tr()));
        return;
      }

      final phoneResult =
      await _authService.isPhoneRegistered(event.phoneNumber);
      if (phoneResult.isSuccess && phoneResult.data!) {
        emit(AuthError('auth.messages.phone_registered'.tr()));
        return;
      }

      emit(AuthLoading(message: 'auth.messages.sending_code'.tr()));
      final result = await _authService.verifyPhoneNumber(event.phoneNumber);

      if (result.isSuccess) {
        emit(PhoneNumberVerificationSent(
          'auth.messages.code_sent'.tr(),
          phoneNumber: event.phoneNumber,
        ));
      } else {
        if (result.error?.contains('BILLING_NOT_ENABLED') ?? false) {
          emit(AuthError('auth.messages.test_phone_error'.tr()));
        } else {
          emit(AuthError(result.error?.tr() ??
              'auth.messages.verification_failed'.tr()));
        }
      }
    } catch (e) {
      emit(AuthError(
          'auth.messages.verification_failed_with'.tr(args: [e.toString()])));
    }
  }

  Future<void> _onOTPSubmitted(
      OTPSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading(message: 'auth.messages.verifying_code'.tr()));
      final result = await _authService.verifyOTP(event.otp);

      if (result.isSuccess && result.data != null) {
        emit(OTPVerificationSuccess(
          user: result.data!,
          message: 'auth.messages.phone_verified'.tr(),
        ));
      } else {
        emit(OTPVerificationError(
            result.error?.tr() ?? 'auth.messages.invalid_code'.tr()));
      }
    } catch (e) {
      emit(OTPVerificationError(
          'auth.messages.verification_error'.tr(args: [e.toString()])));
    }
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading(message: 'auth.messages.google_signin'.tr()));
      final result = await _authService.signInWithGoogle();

      if (result.isSuccess && result.data != null) {
        emit(GoogleSignInSuccess(
          user: result.data!,
          message: 'auth.messages.welcome_google'.tr(namedArgs: {'name': result.data!.name}),
        ));
      } else {
        emit(GoogleSignInError(
            result.error?.tr() ?? 'auth.messages.google_signin_failed'.tr()));
      }
    } catch (e) {
      emit(GoogleSignInError(
          'auth.messages.google_signin_error'.tr(args: [e.toString()])));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading(message: 'auth.messages.reset_password_sending'.tr()));
      final result = await _authService.resetPassword(event.email);

      if (result.isSuccess) {
        emit(ResetPasswordSuccess(
            message: 'auth.messages.reset_password_sent'.tr()));
      } else {
        emit(ResetPasswordError(result.error?.tr() ??
            'auth.messages.reset_password_failed'.tr()));
      }
    } catch (e) {
      emit(ResetPasswordError(
          'auth.messages.reset_password_error'.tr(args: [e.toString()])));
    }
  }

  void _handleValidateLoginFields(
      ValidateLoginFields event,
      Emitter<AuthState> emit,
      ) {
    if (event.email.trim().isEmpty || event.password.isEmpty) {
      emit(ValidationError('auth.messages.fill_all_fields'.tr()));
      return;
    }

    if (!_isValidEmail(event.email.trim())) {
      emit(ValidationError('auth.messages.invalid_email'.tr()));
      return;
    }

    if (!_isValidPassword(event.password)) {
      emit(ValidationError('auth.messages.invalid_password'.tr()));
      return;
    }

    emit(ValidationSuccess());
  }
}
// lib/infrastructure/auth/biometric/local_biometric_service.dart

import 'package:local_auth/local_auth.dart';

import 'package:eventure/features/auth/domain/interfaces/biometric_service.dart';

class LocalBiometricService implements IBiometricService {
  static final LocalBiometricService _instance = LocalBiometricService._internal();

  factory LocalBiometricService() => _instance;

  final LocalAuthentication _localAuth;

  LocalBiometricService._internal() : _localAuth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;

      List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      return availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.face);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your profile',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
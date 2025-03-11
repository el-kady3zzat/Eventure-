import 'package:local_auth/local_auth.dart';


class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    return await _localAuth.authenticate(
      localizedReason: 'Authenticate to proceed',
      options: const AuthenticationOptions(biometricOnly: true),
    );
  }
}
abstract class IBiometricService {
  Future<bool> isAvailable();
  Future<bool> authenticate();
}
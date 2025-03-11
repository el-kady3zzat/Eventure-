abstract class AuthService {
  Future<String> login(String email, String password);
  Future<String> signup(String name, String email, String password);
}

class AuthServiceFactory {
  static AuthService createService(String type) {
    switch (type) {
      case 'firebase':
        return FirebaseAuthService();
      case 'local':
        return LocalAuthService();
      default:
        throw Exception("Unknown auth service type");
    }
  }
}

class FirebaseAuthService implements AuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  @override
  Future<String> login(String email, String password) async {
    // Firebase login logic here
    return "User Logged In!";
  }

  @override
  Future<String> signup(String name, String email, String password) async {
    // Firebase signup logic here
    return "User Signed Up!";
  }
}

class LocalAuthService implements AuthService {
  @override
  Future<String> login(String email, String password) async {
    return "Logged in using Local Auth";
  }

  @override
  Future<String> signup(String name, String email, String password) async {
    return "Signed up using Local Auth";
  }
}

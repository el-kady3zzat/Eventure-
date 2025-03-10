// lib/features/auth/infrastructure/repositories/auth_repository_impl.dart

import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventure/features/auth/domain/models/auth_credentials.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final IAuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Stream<bool> get authStateChanges => _authService.authStateChanges;

  @override
  Future<Result<UserEntity>> login(String email, String password) async {
    final credentials = AuthCredentials(
      email: email,
      password: password,
    );
    return _authService.signIn(credentials);
  }

  @override
  Future<Result<UserEntity>> signup(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final signUpData = SignUpData.builder()
        .setEmail(email)
        .setPassword(password)
        .setName(name)
        .setPhone(phone)
        .build();

    return _authService.signUp(signUpData);
  }

  @override
  Future<Result<void>> signOut() async {
    return _authService.signOut();
  }
}

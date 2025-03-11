// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Result<UserEntity>> execute(String email, String password) async {
    return _authRepository.login(email, password);
  }
}
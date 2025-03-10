import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';


import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _authRepository;
  SignupUseCase(this._authRepository);

  Future<Result<UserEntity>> execute(
      String email, String password, String name, String phone) {
    return _authRepository.signup(email, password, name, phone);
  }
}

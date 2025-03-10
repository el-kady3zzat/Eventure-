


import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<bool> get authStateChanges;

  Future<Result<UserEntity>> login(String email, String password);

  Future<Result<UserEntity>> signup(
      String email,
      String password,
      String name,
      String phone,
      );

  Future<Result<void>> signOut();
}


import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';

import '../models/sign_up_data.dart';

abstract class IUserRepository {
  Future<Result<UserEntity?>> getUserById(String id);
  Future<Result<void>> createUser(SignUpData signUpData, String uid);
  Future<Result<void>> updateUser(UserEntity user);
  //Future<Result<bool>> isNameTaken(String name);
  Future<Result<bool>> isPhoneTaken(String phone);
}
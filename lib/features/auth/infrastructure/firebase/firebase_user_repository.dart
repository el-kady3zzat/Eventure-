import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';
import 'package:eventure/features/auth/infrastructure/dto/user_dto.dart';

class FirebaseUserRepository implements IUserRepository {
  static final FirebaseUserRepository _instance = FirebaseUserRepository._internal();

  factory FirebaseUserRepository() => _instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'users';

  FirebaseUserRepository._internal() : _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<UserEntity?>> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return Result.success(null);

      return Result.success(UserDTO.fromFirestore(doc).toDomain());
    } catch (e) {
      return Result.failure('Failed to get user data');
    }
  }

  @override
  Future<Result<void>> createUser(SignUpData signUpData, String uid) async {
    try {
      final userDto = UserDTO(
        id: uid,
        name: signUpData.name.trim(),
        email: signUpData.email.trim(),
        phone: signUpData.phone?.trim() ?? '',
        image: '',
        location: 'Egypt',
        role: 'client',
        bookedEvents: [],
        favEvents: [],
        savedEvents: [],
      );

      await _firestore
          .collection(_collection)
          .doc(uid)
          .set(userDto.toFirestore());

      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to create user');
    }
  }

  @override
  Future<Result<void>> updateUser(UserEntity user) async {
    try {
      final userDto = UserDTO.fromDomain(user);
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(userDto.toFirestore());

      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to update user');
    }
  }

  // Event-related methods
  Future<Result<void>> addToBookedEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'bookedEvents': FieldValue.arrayUnion([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to add booked event');
    }
  }

  Future<Result<void>> addToFavEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'favEvents': FieldValue.arrayUnion([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to add favorite event');
    }
  }

  Future<Result<void>> addToSavedEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'savedEvents': FieldValue.arrayUnion([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to add saved event');
    }
  }

  Future<Result<void>> removeFromBookedEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'bookedEvents': FieldValue.arrayRemove([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to remove booked event');
    }
  }

  Future<Result<void>> removeFromFavEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'favEvents': FieldValue.arrayRemove([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to remove favorite event');
    }
  }

  Future<Result<void>> removeFromSavedEvents(String userId, String eventId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'savedEvents': FieldValue.arrayRemove([eventId])
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to remove saved event');
    }
  }

  // @override
  // Future<Result<bool>> isNameTaken(String name) async {
  //   try {
  //     final result = await _firestore
  //         .collection(_collection)
  //         .where('name', isEqualTo: name.trim())
  //         .get();
  //     return Result.success(result.docs.isNotEmpty);
  //   } catch (e) {
  //     return Result.failure('Failed to check name availability');
  //   }
  // }

  @override
  Future<Result<bool>> isPhoneTaken(String phone) async {
    try {
      if (phone.isEmpty) return Result.success(false);

      final result = await _firestore
          .collection(_collection)
          .where('phone', isEqualTo: phone.trim())
          .get();
      return Result.success(result.docs.isNotEmpty);
    } catch (e) {
      return Result.failure('Failed to check phone availability');
    }
  }

  // Update user location
  Future<Result<void>> updateUserLocation(String userId, String location) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'location': location
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to update location');
    }
  }

  // Update user role
  Future<Result<void>> updateUserRole(String userId, String role) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'role': role
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to update role');
    }
  }
}
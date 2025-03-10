import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eventure/core/utils/result.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';
import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:eventure/features/auth/domain/models/auth_credentials.dart';
import 'package:eventure/features/auth/domain/models/sign_up_data.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _verificationId;
  int? _resendToken;

  factory FirebaseAuthService({required IUserRepository userRepository}) {
    _instance._userRepository = userRepository;
    return _instance;
  }

  final FirebaseAuth _auth;
  late final IUserRepository _userRepository;

  FirebaseAuthService._internal() : _auth = FirebaseAuth.instance;

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  Future<Result<bool>> isEmailRegistered(String email) async {
    try {
      try {
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: 'dummy_password_${DateTime.now().millisecondsSinceEpoch}',
        );
        // If we reach here (unlikely), the email exists with this exact dummy password
        return Result.success(true);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return Result.success(false); // Email is not registered
        } else if (e.code == 'wrong-password') {
          return Result.success(true); // Email exists but password is wrong (expected)
        }
        return Result.failure('Error checking email availability');
      }
    } catch (e) {
      return Result.failure('Error checking email: ${e.toString()}');
    }
  }


  @override
  Future<Result<bool>> isPhoneRegistered(String phoneNumber) async {
    try {
      if (phoneNumber.trim().isEmpty || phoneNumber.trim() == '+2') {
        return Result.success(false);
      }

      final result = await _userRepository.isPhoneTaken(phoneNumber);

      if (result.isSuccess) {
        return Result.success(result.data ?? false);
      } else {
        return Result.failure(result.error ?? 'Failed to check phone number');
      }
    } catch (e) {
      return Result.failure('Error checking phone number: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserEntity>> signIn(AuthCredentials credentials) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: credentials.email.trim(),
        password: credentials.password,
      );

      if (userCredential.user != null) {
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('Authentication failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return Result.success(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('Failed to send reset password email');
    }
  }

  @override

  Future<Result<UserEntity>> signUp(SignUpData signUpData) async {
    try {
      // Check if name is taken
      // final nameResult = await isNameTaken(signUpData.name);
      // if (nameResult.isSuccess && nameResult.data!) {
      //   return Result.failure('This name is already taken');
      // }

      // Check if email is registered
      final emailResult = await isEmailRegistered(signUpData.email);
      if (emailResult.isSuccess && emailResult.data!) {
        return Result.failure('This email is already registered');
      }

      // Check if phone is taken (if provided)
      if (signUpData.phone != null &&
          signUpData.phone!.isNotEmpty &&
          signUpData.phone != '+2') {
        final phoneResult = await isPhoneRegistered(signUpData.phone!);
        if (phoneResult.isSuccess && phoneResult.data!) {
          return Result.failure('This phone number is already registered');
        }
      }

      // Create Firebase auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: signUpData.email.trim(),
        password: signUpData.password,
      );

      if (userCredential.user != null) {
        await _userRepository.createUser(signUpData, userCredential.user!.uid);
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('User creation failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<void>> verifyPhoneNumber(String phoneNumber) async {
    try {
      final completer = Completer<Result<void>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            completer.complete(Result.success(null));
          } catch (e) {
            completer.complete(Result.failure(e.toString()));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(Result.failure(_mapFirebaseAuthError(e)));
        },
        codeSent: (String verificationId, int? resendToken) {
          this._verificationId = verificationId;
          this._resendToken = resendToken;
          completer.complete(Result.success(null));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this._verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete(Result.failure('Verification timeout'));
          }
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );

      return completer.future;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserEntity>> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return Result.success(
          UserEntity(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? '',
            phone: userCredential.user!.phoneNumber ?? '',
          ),
        );
      } else {
        return Result.failure('Verification failed');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return Result.failure('Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);

        if (userResult.isSuccess) {
          if (userResult.data != null) {
            return Result.success(userResult.data!);
          } else {
            final signUpData = SignUpData.builder()
                .setEmail(userCredential.user!.email!)
                .setName(userCredential.user!.displayName ?? 'User')
                .setPassword('')
                .setPhone(userCredential.user!.phoneNumber ?? '')
                .build();

            await _userRepository.createUser(signUpData, userCredential.user!.uid);

            final newUserResult = await _userRepository.getUserById(userCredential.user!.uid);
            if (newUserResult.isSuccess && newUserResult.data != null) {
              return Result.success(newUserResult.data!);
            }
          }
        }
      }
      return Result.failure('Failed to sign in with Google');
    } catch (e) {
      return Result.failure('Failed to sign in with Google: ${e.toString()}');
    }
  }

  String _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'The password provided is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'invalid-phone-number':
        return 'Invalid phone number';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later';
      case 'session-expired':
        return 'The verification session has expired. Please request a new code';
      case 'credential-already-in-use':
        return 'This phone number is already linked to another account';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }

  void _clearVerificationData() {
    _verificationId = null;
    _resendToken = null;
  }
  // @override
  // Future<Result<bool>> isNameRegistered(String name) async {
  //   try {
  //     final result = await _userRepository.isNameTaken(name.trim());
  //     return result;
  //   } catch (e) {
  //     return Result.failure('Error checking name: ${e.toString()}');
  //   }
  // }
  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _clearVerificationData();
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to sign out');
    }
  }

  @override
  bool isPhoneVerificationInProgress() {
    return _verificationId != null;
  }
}
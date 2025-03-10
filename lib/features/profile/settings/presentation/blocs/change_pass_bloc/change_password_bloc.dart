import 'package:eventure/features/settings/presentation/blocs/change_pass_bloc/change_password_event.dart';
import 'package:eventure/features/settings/presentation/blocs/change_pass_bloc/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onChangePasswordRequested(
      ChangePasswordRequested event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordLoading());

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw FirebaseAuthException(code: "user-not-found");

      // Authenticate the user with the current password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: event.currentPassword,
      );

      // Update password if authentication was successful
      await user.updatePassword(event.newPassword);

      emit(ChangePasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        emit(ChangePasswordFailure("Incorrect current password."));
      } else {
        emit(ChangePasswordFailure("An error occurred. Try again."));
      }
    }
  }
}
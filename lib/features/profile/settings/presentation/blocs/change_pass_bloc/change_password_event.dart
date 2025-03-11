abstract class ChangePasswordEvent {}

class ChangePasswordRequested extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequested({required this.currentPassword, required this.newPassword});
}

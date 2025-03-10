part of 'user_data_cubit.dart';

abstract class UserDataState {}

final class UserDataInitial extends UserDataState {}

final class UserDataLoading extends UserDataState {}

final class UserDataLoaded extends UserDataState {
  final Map<String, dynamic> data;

  UserDataLoaded({required this.data});
}

final class UserDataError extends UserDataState {
  final String msg;

  UserDataError({required this.msg});
}

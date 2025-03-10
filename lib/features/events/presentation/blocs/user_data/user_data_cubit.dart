import 'package:eventure/features/events/domain/usecases/common/get_current_user.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final GetCurrentUser _user = getIt<GetCurrentUser>();

  UserDataCubit() : super(UserDataInitial());

  Future getUserData() async {
    emit(UserDataLoading());
    final data = await _user.call();
    data.fold(
      (failure) => emit(UserDataError(msg: failure.message)),
      (data) => emit(UserDataLoaded(data: data)),
    );
  }
}

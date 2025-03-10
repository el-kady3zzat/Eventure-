import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/usecases/common/get_images_list.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_images_event.dart';
part 'users_images_state.dart';

class UsersImagesBloc extends Bloc<UsersImagesEvent, UsersImagesState> {
  final GetImagesList _images = getIt<GetImagesList>();

  UsersImagesBloc() : super(UsersImagesInitial()) {
    on<LoadUsersImages>((event, emit) async {
      emit(UsersImagesLoading());

      await emit.forEach(
        _images(event.eventId),
        onData: (Either<Failure, List<String>> result) {
          return result.fold(
            (failure) => UsersImagesError(msg: failure.toString()),
            (images) => UsersImagesLoaded(images: images),
          );
        },
        onError: (error, stackTrace) {
          return UsersImagesError(msg: error.toString());
        },
      );
    });
  }
}

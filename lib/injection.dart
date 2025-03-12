import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/auth/domain/interfaces/auth_service.dart';
import 'package:eventure/features/auth/domain/interfaces/biometric_service.dart';
import 'package:eventure/features/auth/domain/interfaces/user_repository.dart';
import 'package:eventure/features/auth/infrastructure/biometric/local_biometric_service.dart';
import 'package:eventure/features/auth/infrastructure/firebase/firebase_auth_service.dart';
import 'package:eventure/features/auth/infrastructure/firebase/firebase_user_repository.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:eventure/features/events/data/datasources/event_datasource.dart';
import 'package:eventure/features/events/data/datasources/local_notification_settings.dart';
import 'package:eventure/features/events/data/repositories/event_repo_impl.dart';
import 'package:eventure/features/events/data/repositories/notifications_repo_impl.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/features/events/domain/repositories/notifications_repo.dart';
import 'package:eventure/features/events/domain/usecases/booking/add_to_book.dart';
import 'package:eventure/features/events/domain/usecases/booking/get_book_ids.dart';
import 'package:eventure/features/events/domain/usecases/booking/remove_book.dart';
import 'package:eventure/features/events/domain/usecases/booking/seats_availability.dart';
import 'package:eventure/features/events/domain/usecases/common/get_calendar_events.dart';
import 'package:eventure/features/events/domain/usecases/common/get_current_user.dart';
import 'package:eventure/features/events/domain/usecases/common/get_events.dart';
import 'package:eventure/features/events/domain/usecases/common/get_images_list.dart';
import 'package:eventure/features/events/domain/usecases/favorite/favorite_add.dart';
import 'package:eventure/features/events/domain/usecases/favorite/favorite_remove.dart';
import 'package:eventure/features/events/domain/usecases/favorite/get_favorite_events.dart';
import 'package:eventure/features/events/domain/usecases/favorite/get_favorite_ids.dart';
import 'package:eventure/features/events/domain/usecases/notifications/get_notification_settings.dart';
import 'package:eventure/features/events/domain/usecases/notifications/get_notifications.dart';
import 'package:eventure/features/events/domain/usecases/notifications/register_fcm_token.dart';
import 'package:eventure/features/events/domain/usecases/notifications/toggle_notification_channel.dart';
import 'package:eventure/features/events/domain/usecases/save_event/add_to_saved_ids.dart';
import 'package:eventure/features/events/domain/usecases/save_event/get_saved_ids.dart';
import 'package:eventure/features/events/domain/usecases/save_event/remove_from_saved_ids.dart';
import 'package:eventure/features/events/presentation/blocs/book_btn/book_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/calendar/calendar_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/calendar_design/calendar_cubit.dart';
import 'package:eventure/features/events/presentation/blocs/event/event_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite_btn/favorite_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/nav_bar/nav_bar_cubit.dart';
import 'package:eventure/features/events/presentation/blocs/notification_settings/notification_settings_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/save_btn/save_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/user_data/user_data_cubit.dart';
import 'package:eventure/features/events/presentation/blocs/users_images/users_images_bloc.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:eventure/notification_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void init() {
  // Register FirebaseAuth instance ////////////////////////////////////////////
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register FirebaseFirestore instance ///////////////////////////////////////
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register FirebaseMessaging instance ///////////////////////////////////////
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  getIt
      .registerSingleton<NotificationHandler>(NotificationHandler())
      .initialize();

  getIt
      .registerSingleton<LocalNotificationSettings>(LocalNotificationSettings())
      .init();

  // Auth Feature //////////////////////////////////////////////////////////////

  //splash
  getIt.registerFactory(() => SplashBloc(
        authService: getIt<IAuthService>(),
        userRepository: getIt<IUserRepository>(),
      ));

  getIt.registerFactory(() => AuthBloc(
        authService: getIt<IAuthService>(),
        biometricService: getIt<IBiometricService>(),
      ));
  getIt.registerSingleton<IUserRepository>(
    FirebaseUserRepository(),
  );

  // Then register the auth service with the repository
  getIt.registerSingleton<IAuthService>(
    FirebaseAuthService(userRepository: getIt<IUserRepository>()),
  );

  // Register biometric service
  getIt.registerSingleton<IBiometricService>(
    LocalBiometricService(),
  );
  //////////////////////////////////////////////////////////////////////////////

//// Events Feature ////////////////////////////////////////////////////////////

  // Data Sources //////////////////////////////////////////////////////////////
  getIt.registerSingleton<EventDatasource>(EventDatasource());

  // Repositories //////////////////////////////////////////////////////////////
  getIt.registerSingleton<EventRepo>(EventRepoImpl());
  getIt.registerSingleton<NotificationRepository>(NotificationRepositoryImpl());

  // Use Cases /////////////////////////////////////////////////////////////////
  getIt.registerSingleton(GetCurrentUser());
  getIt.registerSingleton(GetEvents());
  getIt.registerSingleton(GetBookIds());
  getIt.registerSingleton(SeatsAvailability());
  getIt.registerSingleton(GetImagesList());
  getIt.registerSingleton(AddToBook());
  getIt.registerSingleton(RemoveBook());
  getIt.registerSingleton(GetCalendarEvents());
  getIt.registerSingleton(GetFavoriteIds());
  getIt.registerSingleton(GetFavoriteEvents());
  getIt.registerSingleton(FavoriteAdd());
  getIt.registerSingleton(FavoriteRemove());
  getIt.registerSingleton(GetSavedIds());
  getIt.registerSingleton(AddToSavedIds());
  getIt.registerSingleton(RemoveFromSavedIds());
  getIt.registerLazySingleton(() => RegisterFcmTokenUseCase());
  getIt.registerLazySingleton(() => ToggleNotificationChannelUseCase());
  getIt.registerLazySingleton(() => GetNotificationSettingsUseCase());
  getIt.registerLazySingleton(() => GetNotificationsUseCase());

  // BLoCs /////////////////////////////////////////////////////////////////////
  getIt.registerSingleton<NotificationSettingsBloc>(
    NotificationSettingsBloc()..add(FetchNotificationSettings()),
  );
  getIt.registerFactory(() => UserDataCubit());
  getIt.registerFactory(() => EventBloc());
  getIt.registerFactory(() => BookBtnBloc());
  getIt.registerFactory(() => UsersImagesBloc());
  getIt.registerFactory(() => CalendarCubit());
  getIt.registerFactory(() => CalendarBloc());
  getIt.registerFactory(() => NavBarCubit(0));
  getIt.registerFactory(() => FavoriteBloc());
  getIt.registerFactory(() => FavoriteBtnBloc());
  getIt.registerFactory(() => SaveBtnBloc());
  getIt.registerFactory(() => ScrollBloc());
  getIt.registerFactory(() => NotificationsBloc());
  //////////////////////////////////////////////////////////////////////////////

  // Profile Feature ///////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
  //////////////////////////////////////////////////////////////////////////////
}

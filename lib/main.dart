import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/events/presentation/blocs/book_btn/book_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite_btn/favorite_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/save_btn/save_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:eventure/features/events/presentation/pages/details_page.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/events/presentation/pages/notifications_page.dart';
import 'package:eventure/firebase_options.dart';
import 'package:eventure/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load();

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return ScreenUtilInit(
          minTextAdapt: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: kMainDark,
            ),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
            home: BlocProvider(
              create: (context) =>
              getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
              child: const HomePage(), // Replace with SplashScreen() if needed
            ),
            routes: {
              '/home': (context) => BlocProvider(
                create: (context) =>
                getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
                child: HomePage(),
              ),
              '/details': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<FavoriteBtnBloc>()),
                  BlocProvider(create: (context) => getIt<SaveBtnBloc>()),
                  BlocProvider(create: (context) => getIt<BookBtnBloc>()),
                  BlocProvider(create: (context) => getIt<ScrollBloc>()),
                ],
                child: DetailsPage(),
              ),
              '/notification': (context) => NotificationsPage(),
            },
          ),
        );
      },
    );
  }
}
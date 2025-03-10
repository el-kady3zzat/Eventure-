import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_page_route.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_event.dart';
import 'package:eventure/features/splash/presentation/bloc/splash_state.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:ui' as ui;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashBloc>()..add(CheckLoginStatusEvent()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    SizeConfig.init(context);
    final isRTL = context.locale.languageCode == 'ar';
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        final backgroundColor = isDarkMode ? kMainDark : kButton.withValues(alpha: 0.8);
        final textColor = isDarkMode ? Colors.white : kMainLight;
        final textSwiperColor = isDarkMode ? kMainDark : Colors.white;
        final accentColor = isDarkMode ? kButton : Colors.white ;
        final swiperColor = isDarkMode ? kButton : kMainDark ;
        final swiperInnerColor = isDarkMode ? kMainDark : kButton ;
        final arrowSwiperColor = isDarkMode ? kButton : kMainDark ;

        return Scaffold(
          backgroundColor: backgroundColor,
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: accentColor,
          //   child: Icon(
          //     isDarkMode ? Icons.light_mode : Icons.dark_mode,
          //     color: textColor,
          //   ),
          //   onPressed: () {
          //     context.read<ThemeCubit>().toggleTheme();
          //     UI.infoSnack(
          //       context,
          //       'settings.theme_changed'.tr(),
          //     );
          //   },
          // ),
          body: Stack(
            children: [
              // Background Decorations
              Positioned(
                top: -50,
                right: -30,
                child: _buildDecorativeShape(
                  color: accentColor.withValues(alpha:0.1),
                  size: 150,
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                top: 100,
                left: -20,
                child: _buildDecorativeShape(
                  color: accentColor.withValues(alpha: 0.05),
                  size: 100,
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                bottom: -30,
                right: 50,
                child: Transform.rotate(
                  angle: 0.3,
                  child: _buildDecorativeShape(
                    color: accentColor.withValues(alpha:0.07),
                    size: 120,
                    borderRadius: 20,
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -40,
                child: Transform.rotate(
                  angle: -0.5,
                  child: _buildDecorativeShape(
                    color: accentColor.withValues(alpha:0.04),
                    size: 80,
                    borderRadius: 15,
                  ),
                ),
              ),
              // Main Content
              SafeArea(
                child: BlocConsumer<SplashBloc, SplashState>(
                  listener: (context, state) {
                    if (state is SplashNavigationState) {
                      Navigator.of(context).pushReplacement(
                        CustomPageRoute(
                          child: state.isLoggedIn ? const HomePage() : const LoginScreen(),
                          type: PageTransitionType.slideUp,
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeInOutCubic,
                        ),
                      );
                    }

                    if (state is SplashErrorState) {
                      UI.errorSnack(context, state.error.tr());
                    }
                  },
                  builder: (context, state) {
                    if (state is SplashLoadingState || state is SplashInitialState) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      );
                    }

                    return Directionality(
                      textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                      child: SizeConfig.isPortrait()
                          ? _buildPortraitLayout(context, state, textColor, accentColor,swiperColor,arrowSwiperColor,swiperInnerColor,textSwiperColor)
                          : _buildLandscapeLayout(context, state, textColor, accentColor,swiperColor,arrowSwiperColor,swiperInnerColor,textSwiperColor),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDecorativeShape({
    required Color color,
    required double size,
    double? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius ?? 0)
            : null,
      ),
    );
  }

  Widget _buildPortraitLayout(
      BuildContext context, SplashState state, Color textColor, Color accentColor,
      Color swiperColor,Color arrowSwiperColor,Color textSwiperColor,Color swiperInnerColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize! * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.defaultSize! * 2),
          _buildLogo(accentColor),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimation(),
                SizedBox(height: SizeConfig.defaultSize! * 2),
                _buildWelcomeText(textColor, accentColor),
                SizedBox(height: SizeConfig.defaultSize!),
                _buildDescriptionText(textColor),
              ],
            ),
          ),
          _buildSwipeButton(context, state, textColor, accentColor,swiperColor,arrowSwiperColor,swiperColor,textSwiperColor),
          SizedBox(height: SizeConfig.defaultSize! * 1.5),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
      BuildContext context, SplashState state, Color textColor, Color accentColor,Color swiperColor,
      Color arrowSwiperColor,Color swiperInnerColor,Color textSwiperColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defaultSize! * 2,
        vertical: SizeConfig.defaultSize!,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(accentColor),
                const Spacer(),
                _buildWelcomeText(textColor, accentColor),
                SizedBox(height: SizeConfig.defaultSize!),
                _buildDescriptionText(textColor),
                const Spacer(),
                _buildSwipeButton(context, state, textColor, accentColor,swiperColor,arrowSwiperColor,swiperInnerColor,textSwiperColor),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildAnimation(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(Color accentColor) {
    return Text(
      'splash.app_name'.tr(),
      style: TextStyle(
        fontSize: SizeConfig.size(p: SizeConfig.screenWidth! * 0.1, l: SizeConfig.screenHeight! * 0.1),
        fontWeight: FontWeight.normal,
        color: accentColor,
      ),
    );
  }

  Widget _buildAnimation() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 2),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: SizeConfig.size(
          p: SizeConfig.screenHeight! * 0.4,
          l: SizeConfig.screenHeight! * 0.8,
        ),
        width: SizeConfig.size(
          p: SizeConfig.screenWidth! * 0.8,
          l: SizeConfig.screenWidth! * 0.4,
        ),
        child: SvgPicture.asset(
          'assets/images/Events-amico.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(Color textColor, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'splash.welcome'.tr(),
          style: TextStyle(
            fontSize: SizeConfig.size(
              p: SizeConfig.screenWidth! * 0.07,
              l: SizeConfig.screenHeight! * 0.07,
            ),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          'splash.brand'.tr(),
          style: TextStyle(
            fontSize: SizeConfig.size(
              p: SizeConfig.screenWidth! * 0.08,
              l: SizeConfig.screenHeight! * 0.08,
            ),
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionText(Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.size(
          p: SizeConfig.screenWidth! * 0.1,
          l: SizeConfig.screenWidth! * 0.05,
        ),
      ),
      child: Text(
        'splash.description'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SizeConfig.size(
            p: SizeConfig.screenWidth! * 0.044,
            l: SizeConfig.screenHeight! * 0.044,
          ),
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSwipeButton(
      BuildContext context, SplashState state, Color textColor, Color accentColor,
      Color swiperColor,Color arrowSwiperColor,Color swiperInnerColor,Color textSwiperColor) {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    return SizedBox(
      width: SizeConfig.size(
        p: SizeConfig.screenWidth! * 0.9,
        l: SizeConfig.screenWidth! * 0.4,
      ),
      height: SizeConfig.size(
        p: SizeConfig.screenHeight! * 0.2,
        l: SizeConfig.screenHeight! * 0.15,
      ),
      child: SlideAction(
        key: _key,
        borderRadius: SizeConfig.defaultSize! * 3,
        elevation: 0,
        innerColor: context.watch<ThemeCubit>().state ? kMainDark : kButton,
        outerColor: swiperColor,
        sliderButtonIcon: Icon(
          context.locale.languageCode == 'ar'
              ? Icons.arrow_back
              : Icons.arrow_forward,
          color: arrowSwiperColor,
          size: SizeConfig.defaultSize! * 2,
        ),
        text: (state is SplashLoggedInState
            ? 'splash.continue_home'
            : 'splash.get_started')
            .tr(),
        textStyle: TextStyle(
          color: context.watch<ThemeCubit>().state ? kMainDark : kButton,
          fontSize: SizeConfig.defaultSize! * 2,
          fontWeight: FontWeight.bold,
        ),
        onSubmit: () async {
          await Future.delayed(
            const Duration(milliseconds: 100),
                () {
              if (state is SplashErrorState) {
                context.read<SplashBloc>().add(CheckLoginStatusEvent());
              } else {
                context.read<SplashBloc>().add(NavigateToNextScreenEvent());
              }
              _key.currentState?.reset();
            },
          );
        },
      ),
    );
  }
}
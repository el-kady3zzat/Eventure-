import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/pages/reset_password.dart';
import 'package:eventure/features/auth/presentation/pages/signup_screen.dart';
import 'package:eventure/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_button.dart';
import 'package:eventure/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    SizeConfig.init(context);

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        final backgroundColor = isDarkMode ? kPrimaryDark : Colors.white;
        final backgroundButton = isDarkMode ? kScaffoldLight : kDetails;
        final textColor = isDarkMode ? Colors.white : kSecondaryDark;
        final subTextColor =
            isDarkMode ? Colors.white : kSecondaryDark.withValues(alpha: 0.7);
        final accentColor = isDarkMode ? kButton : kButton;
        final dividerColor = isDarkMode ? kPreIcon : kPrimaryDark;

        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              UI.infoSnack(context, state.message.tr());
            } else if (state is ValidationSuccess) {
              context.read<AuthBloc>().add(
                    SignInRequested(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    ),
                  );
            } else if (state is ValidationError) {
              UI.errorSnack(context, state.message.tr());
            } else if (state is AuthSuccess) {
              UI.successSnack(context, state.message.tr());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            } else if (state is GoogleSignInSuccess) {
              UI.successSnack(context, state.message.tr());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            } else if (state is AuthError ||
                state is GoogleSignInError ||
                state is ResetPasswordError) {
              UI.errorSnack(
                context,
                (state is AuthError
                        ? state.message
                        : state is GoogleSignInError
                            ? state.message
                            : (state as ResetPasswordError).message)
                    .tr(),
              );
            } else if (state is ResetPasswordSuccess) {
              UI.successSnack(context, state.message.tr());
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize! * 2,
                        vertical: SizeConfig.defaultSize! * 0.2,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SizeConfig.isPortrait()
                            ? _buildPortraitLayout(
                                state,
                                textColor,
                                accentColor,
                                subTextColor,
                                dividerColor,
                                backgroundButton)
                            : _buildLandscapeLayout(
                                state,
                                textColor,
                                accentColor,
                                dividerColor,
                                backgroundButton,
                                subTextColor),
                      ),
                    ),
                  ),
                  if (state is AuthLoading)
                    LoadingOverlay(message: state.message.tr()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPortraitLayout(
      AuthState state,
      Color textColor,
      Color accentColor,
      Color subTextColor,
      Color dividerColor,
      Color backgroundButton) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: SizeConfig.screenWidth! * 0.8,
            height: SizeConfig.screenHeight! * 0.30,
            child: SvgPicture.asset(
              'assets/images/Mobile login-amico.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          'auth.login'.tr(),
          style: TextStyle(
            fontSize: SizeConfig.defaultSize! * 2,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          'auth.login_subtitle'.tr(),
          style: TextStyle(
            color: subTextColor,
            fontSize: SizeConfig.defaultSize! * 1.5,
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildLoginForm(textColor, accentColor),
        SizedBox(height: SizeConfig.defaultSize! * 4),
        Transform.scale(
          scale: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundButton, // Lighter background
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                        left: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          SizeConfig.defaultSize! * 0.9, // Reduced padding
                      horizontal: SizeConfig.defaultSize! * 1,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove button padding
                        minimumSize:
                            Size.zero, // Remove minimum size constraint
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Reduce tap target
                      ),
                      child: Text(
                        'auth.forgot_password'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              SizeConfig.defaultSize! * 1.5, // Smaller font
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: SizeConfig.defaultSize! * 16), // Reduced spacing
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundButton, // Lighter background
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                        left: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          SizeConfig.defaultSize! * 0.9, // Reduced padding
                      horizontal: SizeConfig.defaultSize! * 1,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove button padding
                        minimumSize:
                            Size.zero, // Remove minimum size constraint
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Reduce tap target
                      ),
                      child: Text(
                        'auth.sign_up'.tr(),
                        style: TextStyle(
                          color: kButton,
                          fontSize:
                              SizeConfig.defaultSize! * 1.5, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildDivider(dividerColor),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildGoogleSignIn(textColor),
        SizedBox(height: SizeConfig.defaultSize! * 0.5),
      ],
    );
  }

  Widget _buildLandscapeLayout(
      AuthState state,
      Color textColor,
      Color accentColor,
      Color dividerColor,
      Color backgroundButton,
      Color subTextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Image and Google Sign In
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                height: SizeConfig.screenHeight! *
                    0.65, // Reduced height to fit Google part
                child: SvgPicture.asset(
                  'assets/images/Mobile login-amico.svg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize!),
              Transform.scale(
                scale: 0.9,
                child: _buildDivider(dividerColor),
              ),
              SizedBox(height: SizeConfig.defaultSize!),
              Transform.scale(
                scale: 0.9,
                child: _buildGoogleSignIn(textColor),
              ),
            ],
          ),
        ),

        // Right side - Form and Links
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.defaultSize! * 1.8),
              Text(
                'auth.login'.tr(),
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 1.8,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'auth.login_subtitle'.tr(),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: SizeConfig.defaultSize! * 1.5,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize!),
              Transform.scale(
                scale: 0.90,
                child: _buildLoginForm(textColor, accentColor),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 1.7),

              // Forgot Password and Sign Up in a row
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  SizedBox(width: SizeConfig.defaultSize! * 2),
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundButton, // Lighter background
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                        left: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          SizeConfig.defaultSize! * 0.9, // Reduced padding
                      horizontal: SizeConfig.defaultSize! * 1,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove button padding
                        minimumSize:
                            Size.zero, // Remove minimum size constraint
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Reduce tap target
                      ),
                      child: Text(
                        'auth.forgot_password'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              SizeConfig.defaultSize! * 1.5, // Smaller font
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: SizeConfig.defaultSize! * 18), // Reduced spacing
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundButton, // Lighter background
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                        left: Radius.circular(
                            SizeConfig.defaultSize! * 3), // Smaller radius
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          SizeConfig.defaultSize! * 0.9, // Reduced padding
                      horizontal: SizeConfig.defaultSize! * 1,
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove button padding
                        minimumSize:
                            Size.zero, // Remove minimum size constraint
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Reduce tap target
                      ),
                      child: Text(
                        'auth.sign_up'.tr(),
                        style: TextStyle(
                          color: kButton,
                          fontSize:
                              SizeConfig.defaultSize! * 1.5, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(Color textColor, Color accentColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Form Container
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize!),
          padding: EdgeInsets.all(SizeConfig.defaultSize! * 1.5),
          decoration: BoxDecoration(
            color: kDetails,
            borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.5),
          ),
          child: Column(
            children: [
              AuthTextField(
                controller: _emailController,
                hintText: 'auth.email'.tr(),
                keyboardType: TextInputType.emailAddress,
                fieldType: 'email',
                labelText: 'auth.email'.tr(),
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(height: SizeConfig.defaultSize! * 1.5),
              AuthTextField(
                controller: _passwordController,
                hintText: 'auth.password'.tr(),
                isPassword: true,
                fieldType: 'password',
                labelText: 'auth.password'.tr(),
                prefixIcon: Icons.lock_outline,
              ),
              // Add space for the overlapping button
              SizedBox(height: SizeConfig.defaultSize! * 4),
            ],
          ),
        ),
        // Overlapping Button
        Positioned(
          bottom: -SizeConfig.defaultSize! * 2,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: SizeConfig.size(p: 200, l: 200),
              height: SizeConfig.defaultSize! * 5.3,
              child: CustomButton(
                text: 'auth.login'.tr(),
                onPressed: _handleLogin,
                fontSize: SizeConfig.defaultSize! * 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color dividerColor) {
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize!),
          child: Text(
            'auth.or_continue_with'.tr(),
            style: TextStyle(
              color: dividerColor,
              fontSize: SizeConfig.defaultSize! * 1.2,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
    );
  }

  Widget _buildGoogleSignIn(Color textColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize!),
      width: double.infinity,
      height: SizeConfig.defaultSize! * 5,
      child: ElevatedButton(
        onPressed: _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPreIcon.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 3),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.google,
              color: kPrimaryDark,
              size: SizeConfig.defaultSize! * 1.7,
            ),
            SizedBox(width: SizeConfig.defaultSize!),
            Text(
              'auth.continue_with_google'.tr(),
              style: TextStyle(
                color: kPrimaryDark,
                fontSize: SizeConfig.defaultSize! * 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    context.read<AuthBloc>().add(
          ValidateLoginFields(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        signInOption: SignInOption.standard,
      );

      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        context.read<AuthBloc>().add(GoogleSignInRequested());
      }
    } catch (e) {
      UI.errorSnack(
        context,
        'auth.google_sign_in_failed'.tr(args: [e.toString()]),
      );
    }
  }
}

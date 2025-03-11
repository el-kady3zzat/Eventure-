import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:eventure/features/auth/presentation/pages/otp_screen.dart';
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
import 'dart:ui' as ui;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '+2';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
            if (_isNavigating) return;

            if (state is AuthLoading) {
              UI.infoSnack(context, state.message.tr());
            } else if (state is ValidationSuccess) {
              final authBloc = context.read<AuthBloc>();
              if (_phoneController.text.trim() == '+2') {
                authBloc.add(
                  SignUpRequested(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                    phone: '',
                  ),
                );
              } else {
                authBloc.add(
                  PhoneNumberSubmitted(
                      phoneNumber: _phoneController.text.trim()),
                );
              }
            } else if (state is ValidationError) {
              UI.errorSnack(context, state.message.tr());
            } else if (state is AuthSuccess) {
              UI.successSnack(context, state.message.tr());
              setState(() => _isNavigating = true);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            } else if (state is PhoneNumberVerificationSent) {
              UI.successSnack(context, state.message.tr());
              final authBloc = context.read<AuthBloc>();
              final themeCubit = context.read<ThemeCubit>();

              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: authBloc),
                        BlocProvider.value(value: themeCubit),
                      ],
                      child: OTPVerificationScreen(
                        phoneNumber: _phoneController.text.trim(),
                        onVerificationComplete: () {
                          if (!mounted) return;
                          authBloc.add(
                            SignUpRequested(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                              phone: _phoneController.text.trim(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ).then((_) {
                  // Reset _isNavigating when returning from OTP
                  if (mounted) setState(() => _isNavigating = false);
                });
              }
            } else if (state is GoogleSignInSuccess) {
              UI.successSnack(context, state.message.tr());
              setState(() => _isNavigating = true);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            } else if (state is AuthError ||
                state is GoogleSignInError ||
                state is OTPVerificationError) {
              UI.errorSnack(
                context,
                (state is AuthError
                        ? state.message
                        : state is GoogleSignInError
                            ? state.message
                            : (state as OTPVerificationError).message)
                    .tr(),
              );
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
                        horizontal:
                            SizeConfig.defaultSize ?? 16, // Fallback if null
                        vertical: SizeConfig.defaultSize ?? 2,
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
            height: SizeConfig.screenHeight! * 0.25,
            child: SvgPicture.asset(
              'assets/images/Mobile login-pana.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize! * 1.5),
          child: Text(
            'auth.sign_up'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.defaultSize! * 2,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize! * 1.5),
          child: Text(
            'auth.sign_up_subtitle'.tr(),
            style: TextStyle(
              color: subTextColor,
              fontSize: SizeConfig.defaultSize! * 1.5,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildSignUpForm(textColor, accentColor),
        SizedBox(height: SizeConfig.defaultSize! * 4),
        _buildDivider(dividerColor),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildGoogleSignIn(textColor),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildLoginRow(textColor, accentColor, backgroundButton),
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
                height: SizeConfig.screenHeight! * 0.65,
                child: SvgPicture.asset(
                  'assets/images/Mobile login-pana.svg',
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
              SizedBox(height: SizeConfig.defaultSize!),
              Transform.scale(
                scale: 0.9,
                child: _buildLoginRow(textColor, accentColor, backgroundButton),
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
                'auth.sign_up'.tr(),
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 2,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'auth.sign_up_subtitle'.tr(),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: SizeConfig.defaultSize! * 1.5,
                ),
              ),
              //   SizedBox(height: SizeConfig.defaultSize!),
              Transform.scale(
                scale: 0.85,
                child: _buildSignUpForm(textColor, accentColor),
              ),
              // SizedBox(height: SizeConfig.defaultSize! * 2),
              // _buildLoginRow(textColor, accentColor, backgroundButton),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(Color textColor, Color accentColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultSize! * 2), // Reduced margin
          padding:
              EdgeInsets.all(SizeConfig.defaultSize! * 1.2), // Reduced padding
          decoration: BoxDecoration(
            color: kDetails,
            borderRadius: BorderRadius.circular(
                SizeConfig.defaultSize! * 1.2), // Reduced radius
          ),
          child: Column(
            children: [
              AuthTextField(
                controller: _nameController,
                hintText: 'auth.full_name'.tr(),
                fieldType: 'name',
                labelText: 'auth.full_name'.tr(),
                prefixIcon: Icons.person_3_rounded,
              ),
              SizedBox(
                  height: SizeConfig.defaultSize! * 0.8), // Reduced spacing
              AuthTextField(
                controller: _emailController,
                hintText: 'auth.email'.tr(),
                keyboardType: TextInputType.emailAddress,
                fieldType: 'email',
                labelText: 'auth.email'.tr(),
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(
                  height: SizeConfig.defaultSize! * 0.8), // Reduced spacing
              AuthTextField(
                controller: _passwordController,
                hintText: 'auth.password'.tr(),
                isPassword: true,
                fieldType: 'password',
                labelText: 'auth.password'.tr(),
                prefixIcon: Icons.lock_outline,
              ),
              SizedBox(
                  height: SizeConfig.defaultSize! * 0.8), // Reduced spacing
              AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'auth.confirm_password'.tr(),
                isPassword: true,
                fieldType: 'confirmPassword',
                passwordController: _passwordController,
                labelText: 'auth.confirm_password'.tr(),
                prefixIcon: Icons.lock_outline,
              ),
              SizedBox(
                  height: SizeConfig.defaultSize! * 0.8), // Reduced spacing
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: AuthTextField(
                  controller: _phoneController,
                  hintText: 'auth.phone_hint'.tr(),
                  keyboardType: TextInputType.phone,
                  fieldType: 'phone',
                  labelText: 'auth.phone'.tr(),
                  prefixIcon: Icons.phone_android_rounded,
                  maxLength: 16,
                  onChanged: (value) {
                    if (value.length > 16) {
                      _phoneController.text = value.substring(0, 16);
                      _phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: 16),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                  height:
                      SizeConfig.defaultSize! * 3), // Reduced bottom spacing
            ],
          ),
        ),
        Positioned(
          bottom: -SizeConfig.defaultSize! * 1.5, // Reduced bottom position
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: SizeConfig.size(p: 180, l: 180), // Reduced button width
              height: SizeConfig.defaultSize! * 5, // Reduced button height
              child: CustomButton(
                text: 'auth.sign_up'.tr(),
                onPressed: _handleSignUp,
                fontSize: SizeConfig.defaultSize! * 1.3, // Reduced font size
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

  Widget _buildLoginRow(
      Color textColor, Color accentColor, Color backgroundButton) {
    return Transform.scale(
      scale: 1,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundButton,
            borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 3),
          ),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.defaultSize! * 0.9,
            horizontal: SizeConfig.defaultSize! * 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Makes the Row wrap its content
            children: [
              Text(
                'auth.already_have_account'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.defaultSize! * 1.5,
                ),
              ),
              SizedBox(width: SizeConfig.defaultSize! * 0.5),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'auth.login'.tr(),
                  style: TextStyle(
                    color: kButton,
                    fontSize: SizeConfig.defaultSize! * 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_isNavigating) return;

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      UI.errorSnack(
        context,
        'auth.fill_required_fields'.tr(),
      );
      return;
    }

    context.read<AuthBloc>().add(
          CheckUserDataAvailability(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            phone: _phoneController.text.trim(),
          ),
        );
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isNavigating) return;

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

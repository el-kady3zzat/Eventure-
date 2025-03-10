import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:eventure/features/auth/presentation/blocs/auth_bloc/auth_states.dart';
import 'package:eventure/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:eventure/features/auth/presentation/widgets/custom_button.dart';
import 'package:eventure/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}
class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isNavigating = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    SizeConfig.init(context);

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        final backgroundColor = isDarkMode ? kMainDark : Colors.white;
        final textColor = isDarkMode ? Colors.white : kMainLight;
        final subTextColor = isDarkMode ? Colors.white70 : kMainLight.withValues(alpha: 0.7);

        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (_isNavigating) return;

            if (state is AuthLoading) {
              UI.infoSnack(context, state.message.tr());
            } else if (state is ResetPasswordSuccess) {
              UI.successSnack(context, state.message.tr());
              setState(() => _isNavigating = true);
              Navigator.pop(context);
            } else if (state is ResetPasswordError) {
              UI.errorSnack(context, state.message.tr());
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: _buildAppBar(textColor),
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
                            ? _buildPortraitLayout(state, textColor, subTextColor)
                            : _buildLandscapeLayout(state, textColor, subTextColor),
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

  PreferredSizeWidget _buildAppBar(Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: textColor,
          size: SizeConfig.defaultSize! * 2,
        ),
        onPressed: () {
          setState(() => _isNavigating = true);
          Navigator.pop(context);
        },
      ),
    );
  }
  Widget _buildPortraitLayout(AuthState state, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: SizeConfig.screenWidth! * 0.8,
            height: SizeConfig.screenHeight! * 0.30,
            decoration: BoxDecoration(
              color: context.watch<ThemeCubit>().state ? kMainLight : kDetails,
              borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.5),
            ),
            padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
            child: SvgPicture.asset(
              'assets/images/Reset password-rafiki.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        Text(
          'auth.reset_password'.tr(),
          style: TextStyle(
            fontSize: SizeConfig.defaultSize! * 2.4,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 1),
        Text(
          'auth.reset_password_subtitle'.tr(),
          style: TextStyle(
            color: subTextColor,
            fontSize: SizeConfig.defaultSize! * 1.4,
          ),
        ),
        SizedBox(height: SizeConfig.defaultSize! * 2),
        _buildResetForm(textColor),
      ],
    );
  }

  Widget _buildLandscapeLayout(AuthState state, Color textColor, Color subTextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Image
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
            child: Container(
              decoration: BoxDecoration(
                color: context.watch<ThemeCubit>().state ? kMainLight : kDetails,
                borderRadius: BorderRadius.circular(SizeConfig.defaultSize! * 1.5),
              ),
              padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
              child: Center(
                child: SizedBox(
                  height: SizeConfig.screenHeight! * 0.5,
                  width: SizeConfig.screenWidth! * 0.7,
                  child: SvgPicture.asset(
                    'assets/images/Reset password-rafiki.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Right side - Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultSize! * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.defaultSize! * 2),
                Text(
                  'auth.reset_password'.tr(),
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize! * 2.4,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize! * 1),
                Text(
                  'auth.reset_password_subtitle'.tr(),
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: SizeConfig.defaultSize! * 1.4,
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize! * 2),
                _buildResetForm(textColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildResetForm(Color textColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
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
              SizedBox(height: SizeConfig.defaultSize! * 2.5),
            ],
          ),
        ),
        Positioned(
          bottom: -SizeConfig.defaultSize! * 2,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: SizeConfig.size(p: 200, l: 200),
              height: SizeConfig.defaultSize! * 5.3,
              child: CustomButton(
                text: 'auth.submit'.tr(),
                onPressed: _handleResetPassword,
                fontSize: SizeConfig.defaultSize! * 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ResetPasswordRequested(
          email: _emailController.text.trim(),
        ),
      );
    } else {
      UI.errorSnack(
        context,
        'auth.enter_valid_email'.tr(),
      );
    }
  }
}

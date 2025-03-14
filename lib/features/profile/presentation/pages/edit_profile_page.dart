import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:eventure/features/profile/presentation/widgets/edit_profile_page/Custom_input_field.dart';
import 'package:eventure/features/profile/presentation/widgets/edit_profile_page/custom_snack_bar.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/asset_image.dart';
import 'package:eventure/features/profile/presentation/widgets/edit_profile_page/profile_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilePage extends StatefulWidget {
  String name;
  String email;
  String phone;
  EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<EditProfileBloc>().add(SubscribeProfile());
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _phoneNumberController.text =
        widget.phone.isEmpty ? 'messages.n_a'.tr() : widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kPrimaryDark : kWhite;
    final textColor = isDarkMode ? kWhite : kPrimaryDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.01;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 15.sp
                            : 21.w,
                        color: textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(flex: 1),
                    Text(
                      'profile.edit'.tr(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 12.sp
                            : 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(flex: 2)
                  ],
                ),
                SizedBox(height: 20.h),
                BlocConsumer<EditProfileBloc, EditProfileState>(
                    buildWhen: (context, state) =>
                        state is EditProfileImageLoaded ||
                        state is EditProfileImageRemoved,
                    listener: (context, state) {
                      if (state is EditProfileImageUploaded) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        CustomSnackBar.showSuccess(
                            context: context,
                            message: 'messages.image_uploaded'.tr());
                      }

                      if (state is EditProfileImageRemoved) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        CustomSnackBar.showSuccess(
                            context: context,
                            message: 'messages.image_removed'.tr());
                      }
                      if (state is AvatarError) {
                        CustomSnackBar.showError(
                            context: context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is EditProfileImageLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is EditProfileImageLoaded &&
                          state.image != null) {
                        return ProfileImage(
                          con: context,
                          img:
                              MemoryImage(state.image!), // Using uploaded image
                        );
                      }
                      if (state is EditProfileImageRemoved) {
                        return ProfileImage(
                          img: assetProfileImage(),
                          con: context,
                        );
                      }
                      if (state is EditProfileImageError) {
                        return Text(state.errorMessage);
                      }

                      return ProfileImage(
                        img: assetProfileImage(),
                      );
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 25.h),
                      // Name Field
                      CustomInputField(
                          label: 'profile.full_name'.tr(),
                          controller: _nameController),
                      SizedBox(height: 12.h),
                      // Email Field
                      CustomInputField(
                          label: 'profile.email'.tr(),
                          controller: _emailController),
                      SizedBox(height: 11.h),
                      // Phone Field
                      CustomInputField(
                          label: 'profile.phone'.tr(),
                          controller: _phoneNumberController),
                      SizedBox(height: 30.h),
                      // Save Button
                      BlocBuilder<EditProfileBloc, EditProfileState>(
                          builder: (context, state) {
                        if (state is EditLoading) {
                          return CircularProgressIndicator();
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // dispatch SaveEdits event to the Bloc
                              context.read<EditProfileBloc>().add(SaveEdits(
                                    context: context,
                                    formKey: _formKey,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    phoneNumber: _phoneNumberController.text,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ?16.h:15.h),
                            ),
                            child: Text('changepass_screen.save'.tr(),
                                style: TextStyle(
                                    color: kWhite,
                                    fontSize: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 11.sp:16.sp,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

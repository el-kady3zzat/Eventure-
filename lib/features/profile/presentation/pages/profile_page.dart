import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/models/fire_store_user_model.dart';
import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:eventure/features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:eventure/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/asset_image.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/event_widget.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FSUser? userData;
  bool show = false;
  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(ToggleShowEvents(show));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kMainDark : kWhite;
    final textColor = isDarkMode ? kWhite : kMainDark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
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
                      size:  MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 17.w:21.w,
                      color: textColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'profile.title'.tr(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ?12.sp: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: textColor,
                      size: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ?18.sp: 25.w,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (con) => BlocProvider(
                                    create: (con) => EditProfileBloc(),
                                    child: EditProfilePage(
                                      name: userData!.name,
                                      email: userData!.email,
                                      phone: userData!.phone,
                                    ),
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (context, state) => state is ProfileLoaded,
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfileLoaded) {
                      final user = state.user;

                      return CircleAvatar(
                          radius: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 100.r: 75.r,
                          backgroundImage: user!.image.isNotEmpty
                              ? MemoryImage(base64Decode(user.image))
                              : assetProfileImage());
                    }
                    if (state is ProfileImageRemoved) {
                      return CircleAvatar(
                        radius:  MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 100.r:75.r,
                        backgroundImage: assetProfileImage(),
                      );
                    }
                    if (state is ProfileImageError) {
                      return Text(state.errorMessage);
                    }

                    return CircleAvatar(
                        radius:  MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 100.r:75.r, backgroundImage: assetProfileImage());
                  }),
              SizedBox(height: 12.h),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ProfileLoaded) {
                    final user = state.user;

                    userData = state.user;
                    List<String> nameParts = userData!.name.split(" ");
                    String firstName = nameParts[0];
                    return user != null
                        ? Text(firstName,
                            style: TextStyle(
                                color: textColor,
                                fontSize: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 16.sp: 22.sp,
                                fontWeight: FontWeight.bold))
                        : Center(
                            child: Text('messages.user_data_not_found'.tr(),
                                style: TextStyle(color: kWhite)));
                  }
                  return Container();
                },
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is ShowEventsUpdated,
                  builder: (context, state) {
                    final profileBloc = context.read<ProfileBloc>();
                    bool showEvents = profileBloc.showEvents;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      showEvents ? kHeader : kDetails),
                                ),
                                onPressed: () {
                                  context
                                      .read<ProfileBloc>()
                                      .add(ToggleShowEvents(true));
                                },
                                child: Text(
                                  'profile.saved_events'.tr(),
                                  style: TextStyle(
                                      color: showEvents ? kWhite : kGrey),
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      !showEvents ? kHeader : kDetails),
                                ),
                                onPressed: () {
                                  context
                                      .read<ProfileBloc>()
                                      .add(ToggleShowEvents(false));
                                },
                                child: Text(
                                  'profile.my_data'.tr(),
                                  style: TextStyle(
                                      color: !showEvents ? kWhite : kGrey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              BlocConsumer<ProfileBloc, ProfileState>(
                buildWhen: (context, state) =>
                    state is ShowEventsUpdated ||
                    state is ProfileLoaded ||
                    state is ProfileLoading ||
                    state is SavedEventsLoaded ||
                    state is SavedEventLoading,
                listener: (context, state) {
                  if (state is ShowEventsUpdated) {
                    debugPrint(
                        "UI updated: Showing ${state.showEvents ? 'Saved Events' : 'My Data'}");
                  }
                  if (state is ProfileLoaded) {
                    debugPrint("Profile data displayed: ${state.user!.name}");
                  }
                },
                builder: (context, state) {
               
             

                  if (state is ShowEventsUpdated) {
                    debugPrint("show: ${state.showEvents}");
                  }

                  //Show loading indicator while profile is loading
                  if (state is ProfileLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  //Show loading indicator while fetching saved events
                  if (state is SavedEventLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Show saved events list when loaded
                  if (state is SavedEventsLoaded &&
                      context.read<ProfileBloc>().showEvents) {
                    if (state.savedEvents.isEmpty) {
                      return Center(
                        child: Text(
                          "No Saved Events",
                          style: TextStyle(fontSize: 18.sp, color: textColor),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.savedEvents.length,
                        itemBuilder: (context, index) {
                          final event = state.savedEvents[index];
                          return SavedEventCard(
                            title: event.title,
                            date:
                                '${event.date.day} ${DateFormat.MMMM().format(event.date)}, ${event.date.year}',
                            time: DateFormat('hh:mm a').format(event.date),
                            asset: event.cover,
                          );
                        },
                      ),
                    );
                  }

                  if (state is ProfileLoaded &&
                      !context.read<ProfileBloc>().showEvents) {
                    final user = state.user;
                    debugPrint("Profile Data: ${user!.name}");
                    return 
                    Expanded(
                      child:
                      MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ?ListView(
                        
                        
                        children: [
                          ProfileItem(
                              isObscure: true,
                              txt: user.name,
                              icon: Icons.person_2_outlined),
                          ProfileItem(
                              isObscure: true,
                              txt: user.email,
                              icon: Icons.email_outlined),
                          ProfileItem(
                              txt: '888888888',
                              isObscure: false,
                              icon: Icons.lock_open_outlined),
                          ProfileItem(
                              isObscure: true,
                              txt: user.phone.isEmpty ? 'N/A' : user.phone,
                              icon: Icons.phone_android_outlined),
                        ],
                      )
                      
                      :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileItem(
                              isObscure: true,
                              txt: user.name,
                              icon: Icons.person_2_outlined),
                          ProfileItem(
                              isObscure: true,
                              txt: user.email,
                              icon: Icons.email_outlined),
                          ProfileItem(
                              txt: '888888888',
                              isObscure: false,
                              icon: Icons.lock_open_outlined),
                          ProfileItem(
                              isObscure: true,
                              txt: user.phone.isEmpty ? 'N/A' : user.phone,
                              icon: Icons.phone_android_outlined),
                        ],
                      ),
                    );
                  }

                  if (state is ProfileError) {
                    return Center(child: Text("Error: ${state.errorMessage}"));
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
